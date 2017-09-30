//
//  ADLViewController.h
//  AppBox
//
//  Created by Vineet Choudhary on 25/03/17.
//  Copyright © 2017 Developer Insider. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ITCLogin.h"

@protocol ITCLoginDelegate <NSObject>

- (void)itcLoginCanceled;
- (void)itcLoginResult:(BOOL)success;

@end

@interface ITCLoginViewController : NSViewController{
    IBOutlet NSButton *buttonLogin;
    IBOutlet NSButton *buttonCancel;
    IBOutlet NSComboBox *comboUserName;
    IBOutlet NSTextField *textFieldUserName;
    IBOutlet NSSecureTextField *textFieldPassword;
    IBOutlet NSProgressIndicator *progressIndicator;
}

@property(nonatomic, strong) XCProject *project;
@property(weak) id <ITCLoginDelegate> delegate;

- (IBAction)buttonLoginTapped:(NSButton *)sender;
- (IBAction)buttonCancelTapped:(NSButton *)sender;
- (IBAction)comboUserNameValueChanged:(NSComboBox *)sender;
- (IBAction)textFieldUserNameValueChanged:(NSTextField *)sender;
- (IBAction)textFieldPasswordValueChanged:(NSSecureTextField *)sender;

@end
