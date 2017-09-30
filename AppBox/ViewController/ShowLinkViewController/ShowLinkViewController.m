//
//  ShowLinkViewController.m
//  AppBox
//
//  Created by Vineet Choudhary on 07/09/16.
//  Copyright © 2016 Developer Insider. All rights reserved.
//

#import "ShowLinkViewController.h"

#define ShortURLUserHint @"Your app is ready. Copy this link and send it to anyone."
#define LongURLUserHint @"Your app is ready. Copy this link and send it to anyone, sorry for long url, google shortener API getting failed currently."

@interface ShowLinkViewController ()

@end

@implementation ShowLinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [EventTracker logScreen:@"AppBox ShareLink"];
    [textFieldAppLink setStringValue: self.project.appShortShareableURL.absoluteString];
    [textFieldHint setStringValue: ([self.project.appShortShareableURL isEqualTo:self.project.appLongShareableURL]) ? LongURLUserHint : ShortURLUserHint];
    [[AppDelegate appDelegate] addSessionLog:[NSString stringWithFormat:@"App URL - %@",textFieldHint.stringValue]];
}


- (IBAction)buttonCopyToClipboardTapped:(NSButton *)sender {
    [EventTracker logEventWithName:@"Copy to Clipboard" customAttributes:@{@"Copy to Clipboard":@1}
                            action:@"Copy to Clipboard" label:@"Copy to Clipboard" value:@1];
    [[NSPasteboard generalPasteboard] clearContents];
    [[NSPasteboard generalPasteboard] setString:self.project.appShortShareableURL.absoluteString  forType:NSStringPboardType];
    [sender setTitle:@"Copied!!"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [sender setTitle:@"Copy to Clipboard"];
    });
}

- (IBAction)buttonCloseTapped:(NSButton *)sender {
    [self dismissController:self];
}

#pragma mark - Navigation
-(void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender{
    if ([segue.destinationController isKindOfClass:[QRCodeViewController class]]){
        ((QRCodeViewController *) segue.destinationController).project = self.project;
    }
}

@end
