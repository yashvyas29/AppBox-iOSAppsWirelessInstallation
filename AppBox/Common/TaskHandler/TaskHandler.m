//
//  TaskHandler.m
//  AppBox
//
//  Created by Vineet Choudhary on 27/03/17.
//  Copyright © 2017 Developer Insider. All rights reserved.
//

#import "TaskHandler.h"

@implementation TaskHandler


+ (void)runPrivilegeTaskWithName:(NSString *)name andArgument:(NSArray *)arguments outputStream:(void (^) (STPrivilegedTask *task, BOOL success ,NSString *output))outputStream {
    NSString *launchPath = [[NSBundle mainBundle] pathForResource: name ofType:@"sh"];
    STPrivilegedTask *privilegedTask = [[STPrivilegedTask alloc] init];
    [privilegedTask setLaunchPath:launchPath];
    [privilegedTask setArguments:arguments];
    
    OSStatus err = [privilegedTask launch];
    if (err != errAuthorizationSuccess) {
        if (err == errAuthorizationCanceled) {
            outputStream(privilegedTask, NO, @"Please provide privileges access to change your default Xcode.");
        } else {
            outputStream(privilegedTask, NO, @"Something went wrong");
        }
    } else {
        NSLog(@"Task successfully launched");
        
        [privilegedTask waitUntilExit];
        
        // Read output file handle for data
        NSFileHandle *readHandle = [privilegedTask outputFileHandle];
        NSData *outputData = [readHandle readDataToEndOfFile];
        NSString *outputString = [[NSString alloc] initWithData:outputData encoding:NSUTF8StringEncoding];
        outputStream(privilegedTask, YES, outputString);
    }
}

+ (void)runTaskWithName:(NSString *)name andArgument:(NSArray *)arguments taskLaunch:(void (^) (NSTask *task))taskLaunch outputStream:(void (^) (NSTask *task, NSString *output))outputStream{
    //Setup Task
    NSString *launchPath = [[NSBundle mainBundle] pathForResource: name ofType:@"sh"];
    if (launchPath == nil){
        outputStream(nil, @"Can't able to find script file.");
        return;
    }
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = launchPath;
    if (arguments != nil){
        task.arguments = arguments;        
    }
    
    //Create error, output pipe with handler
    NSPipe *outputPipe = [[NSPipe alloc] init];
    [task setStandardOutput:outputPipe];
    [task setStandardError:outputPipe];
    [outputPipe.fileHandleForReading waitForDataInBackgroundAndNotify];
    [[NSNotificationCenter defaultCenter] addObserverForName:NSFileHandleDataAvailableNotification object:outputPipe.fileHandleForReading queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        NSData *outputData =  outputPipe.fileHandleForReading.availableData;
        NSString *outputString = [[NSString alloc] initWithData:outputData encoding:NSUTF8StringEncoding];
        if (outputStream != nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                outputStream(task, outputString);
            });
        }
    }];
    
    //Launch task
    if (taskLaunch != nil){
        taskLaunch(task);
    }
    [task launch];
}

@end
