//
//  LocalServerHandler.m
//  AppBox
//
//  Created by Vineet Choudhary on 12/08/17.
//  Copyright © 2017 Developer Insider. All rights reserved.
//

#import "LocalServerHandler.h"

@implementation LocalServerHandler

+(void)getLocalIPAddressWithCompletion:(void (^)(NSString *ipAddress))completion{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *ipAddresses = [[NSHost currentHost] addresses];
        for (NSString *ipAddress in ipAddresses) {
            if ([ipAddress componentsSeparatedByString:@"."].count == 4) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(ipAddress);
                });
                return;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(@"Not Connected.");
            return;
        });
    });
}

+(void)startLocalServerWithCompletion:(void (^)(BOOL isOn))completion{
    [TaskHandler runTaskWithName:@"PythonServer" andArgument:@[[UserData buildLocation].absoluteString] taskLaunch:nil outputStream:^(NSTask *task, NSString *output) {
        [[AppDelegate appDelegate] addSessionLog:output];
        completion(YES);
    }];
}

@end
