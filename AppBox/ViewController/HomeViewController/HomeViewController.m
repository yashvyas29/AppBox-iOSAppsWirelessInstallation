//
//  HomeViewController.m
//  AppBox
//
//  Created by Vineet Choudhary on 29/08/16.
//  Copyright © 2016 Developer Insider. All rights reserved.
//

#import "HomeViewController.h"

@implementation HomeViewController{
    XCProject *project;
    XCProject *repoProject;
    ScriptType scriptType;
    NSArray *allTeamIds;
    UploadManager *uploadManager;
    NSInteger schemeScriptRunCount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    project = [[XCProject alloc] init];
    allTeamIds = [KeychainHandler getAllTeamId];
    //Notification Handler
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initBuildRepoProcess:) name:abBuildRepoNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dropboxLogoutHandler:) name:abDropBoxLoggedOutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLoggedInNotification:) name:abDropBoxLoggedInNotification object:nil];
    
    //setup initial value
    [project setBuildDirectory: [UserData buildLocation]];
    
    //setup dropbox
    [UploadManager setupDBClientsManager];
    [self setupUploadManager];
    
    //update available memory
    [[NSApplication sharedApplication] updateDropboxUsage];
    
    //Start monitoring internet connection
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [[AppDelegate appDelegate] setIsInternetConnected:!(status == AFNetworkReachabilityStatusNotReachable)];
        if ([AppDelegate appDelegate].processing){
            if (status == AFNetworkReachabilityStatusNotReachable){
                [self showStatus:abNotConnectedToInternet andShowProgressBar:YES withProgress:-1];
            }else{
                [self showStatus:abConnectedToInternet andShowProgressBar:NO withProgress:-1];
                //restart last failed operation
                if (uploadManager.lastfailedOperation){
                    [uploadManager.lastfailedOperation start];
                    uploadManager.lastfailedOperation = nil;
                }
            }
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    //Track screen
    [EventTracker logScreen:@"Home Screen"];
    
    //Get Xcode and Application Loader path
    [XCHandler getXCodePathWithCompletion:^(NSString *xcodePath, NSString *applicationLoaderPath) {
        [UserData setXCodeLocation:xcodePath];
        [UserData setApplicationLoaderLocation:applicationLoaderPath];
    }];
    
    //Get Xcode Version
    [XCHandler getXcodeVersionWithCompletion:^(BOOL success, XcodeVersion version, NSString *versionString) {
        
    }];
}

- (void)viewWillAppear{
    [super viewWillAppear];
    [self updateMenuButtons];
    
    //Handle Dropbox Login
    if ([DBClientsManager authorizedClient] == nil) {
        [self performSegueWithIdentifier:@"DropBoxLogin" sender:self];
    }
    [[AppDelegate appDelegate] setIsReadyToBuild:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:abAppBoxReadyToBuildNotification object:self];
}

#pragma mark - Upload Manager
-(void)setupUploadManager{
    uploadManager = [[UploadManager alloc] init];
    [uploadManager setProject:project];
    [uploadManager setCurrentViewController:self];
    
    __unsafe_unretained typeof(self) weakSelf = self;
    
    [uploadManager setProgressBlock:^(NSString *title){
        
    }];
    
    [uploadManager setErrorBlock:^(NSError *error, BOOL terminate){
        if (terminate) {
            [weakSelf viewStateForProgressFinish:YES];
        }
    }];
    
    [uploadManager setItcLoginBlock:^(){
        [weakSelf performSegueWithIdentifier:@"ITCLogin" sender:weakSelf];
    }];
    
    [uploadManager setCompletionBlock:^(){
        [weakSelf logAppUploadEventAndShareURLOnSlackChannel];
    }];
}


#pragma mark - Build Repo
- (void)initBuildRepoProcess:(NSNotification *)notification {
    if ([notification.object isKindOfClass:[XCProject class]]) {
        repoProject = notification.object;
        [tabView selectTabViewItem:tabView.tabViewItems.firstObject];
        [self initProjectBuildProcessForURL: repoProject.fullPath];
    }
}

#pragma mark - Controls Action Handler -
#pragma mark → Project / Workspace Controls Action
//Project Path Handler
- (IBAction)projectPathHandler:(NSPathControl *)sender {
    NSURL *projectURL = [sender.URL filePathURL];
    [self initProjectBuildProcessForURL: projectURL];
}

- (void)initProjectBuildProcessForURL:(NSURL *)projectURL {
    if (![project.fullPath isEqualTo:projectURL]){
        [self viewStateForProgressFinish:YES];
        [project setFullPath: projectURL];
        [pathProject setURL:projectURL];
        [self runGetSchemeScript];
    }
}

//Scheme Value Changed
- (IBAction)comboBuildSchemeValueChanged:(NSComboBox *)sender {
    [self updateViewState];
    [project setSelectedSchemes:sender.stringValue];
}

//Team Value Changed
- (IBAction)comboTeamIdValueChanged:(NSComboBox *)sender {
    NSString *teamId;
    if (sender.stringValue.length != 10 || [sender.stringValue containsString:@" "]){
        NSDictionary *team = [[allTeamIds filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.fullName LIKE %@",sender.stringValue]] firstObject];
        teamId = [team valueForKey:abTeamId];
        [project setTeamId: teamId];
    }else{
        [project setTeamId: sender.stringValue];
    }
    [self updateViewState];
}

//Build Type Changed
- (IBAction)comboBuildTypeValueChanged:(NSComboBox *)sender {
    if (![project.buildType isEqualToString:sender.stringValue]){
        [project setBuildType: sender.stringValue];
        if ([project.buildType isEqualToString:BuildTypeAppStore]){
            [self performSegueWithIdentifier:@"ITCLogin" sender:self];
        }
        [self updateViewState];
    }
}

#pragma mark → IPA File Controlles Actions
//IPA File Path Handler
- (IBAction)ipaFilePathHandle:(NSPathControl *)sender {
    if (![project.fullPath isEqual:sender.URL]){
        project.ipaFullPath = sender.URL.filePathURL;
        [self updateViewState];
    }
}

- (IBAction)buttonUniqueLinkTapped:(NSButton *)sender{
    project.isKeepSameLinkEnabled = (sender.state == NSOnState);
}

- (IBAction)buttonSameLinkHelpTapped:(NSButton *)sender {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText: abKeepSameLinkHelpTitle];
    [alert setInformativeText:abKeepSameLinkHelpMessage];
    [alert setAlertStyle:NSInformationalAlertStyle];
    [alert addButtonWithTitle:@"Know More"];
    [alert addButtonWithTitle:@"Ok"];
    if ([alert runModal] == NSAlertFirstButtonReturn){
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:abKeepSameLinkReadMoreURL]];
        [EventTracker logEventWithType:LogEventTypeExternalLinkKeepSameLink];
    }
}


#pragma mark → Mail Controls Action
//Send mail option
- (IBAction)sendMailOptionValueChanged:(NSButton *)sender {
    [self enableMailField:(sender.state == NSOnState)];
}

//Shutdown mac option
- (IBAction)sendMailMacOptionValueChanged:(NSButton *)sender {
    //No action required
}

//email id text field
- (IBAction)textFieldMailValueChanged:(NSTextField *)sender {
    //removed spaces
    [sender setStringValue: [sender.stringValue stringByReplacingOccurrencesOfString:@" " withString:abEmptyString]];
    
    //check all mails vaild or not and setup mailed option based on this
    BOOL isAllMailVaild = sender.stringValue.length > 0 && [MailHandler isAllValidEmail:sender.stringValue];
    [buttonShutdownMac setEnabled:isAllMailVaild];
    if (isAllMailVaild){
        [project setEmails:sender.stringValue];
        
        //save user emails, if they doesn't have any
        if ([[UserData userEmail] isEqualToString:abEmptyString]){
            [UserData setUserEmail:sender.stringValue];
        }
    }else if (sender.stringValue.length > 0){
        [MailHandler showInvalidEmailAddressAlert];
    }
}

//developer message text field
- (IBAction)textFieldDevMessageValueChanged:(NSTextField *)sender {
    if (sender.stringValue.length > 0){
        if ([[UserData userMessage] isEqualToString:abEmptyString]) {
            [UserData setUserMessage:sender.stringValue];
        }
        [project setPersonalMessage:sender.stringValue];
    }
}

#pragma mark → Final Action Button (Build/IPA/CI)
//Build Button Action
- (IBAction)actionButtonTapped:(NSButton *)sender {
    if (buttonSendMail.state == NSOffState || (textFieldEmail.stringValue.length > 0 && [MailHandler isAllValidEmail:textFieldEmail.stringValue])){
        //set email
        if (project.emails == nil) {
            [self enableMailField:buttonSendMail.state == NSOnState];
        }
        
        //set processing flg
        [[AppDelegate appDelegate] setProcessing:true];
        [[textFieldEmail window] makeFirstResponder:self.view];
        
        if (project.fullPath && tabView.tabViewItems.firstObject.tabState == NSSelectedTab){
            NSDictionary *currentSetting = [self getBasicViewStateWithOthersSettings:@{@"Build Type" : comboBuildType.stringValue}];
            [EventTracker logEventSettingWithType:LogEventSettingTypeArchiveAndUpload andSettings:currentSetting];
            [project setIsBuildOnly:NO];
            [self runBuildScript];
        }else if (project.ipaFullPath  && tabView.tabViewItems.lastObject.tabState == NSSelectedTab){
            NSDictionary *currentSetting = [self getBasicViewStateWithOthersSettings:nil];
            [EventTracker logEventSettingWithType:LogEventSettingTypeUploadIPA andSettings:currentSetting];
            [uploadManager uploadIPAFile:project.ipaFullPath];
        }
        [self viewStateForProgressFinish:NO];
    }else{
        [MailHandler showInvalidEmailAddressAlert];
    }
}

//Config CI
- (IBAction)buttonConfigCITapped:(NSButton *)sender {
    
}

#pragma mark - NSTask (Scheme, TeamId and Archive) -
#pragma mark → Task

- (void)runGetSchemeScript{
    [self showStatus:@"Getting project scheme..." andShowProgressBar:YES withProgress:-1];
    scriptType = ScriptTypeGetScheme;
    NSString *schemeScriptPath = [[NSBundle mainBundle] pathForResource:@"GetSchemeScript" ofType:@"sh"];
    [self runTaskWithLaunchPath:schemeScriptPath andArgument:@[project.rootDirectory]];
}

- (void)runTeamIDScript{
    [self showStatus:@"Getting project team id..." andShowProgressBar:YES withProgress:-1];
    scriptType = ScriptTypeTeamId;
    NSString *teamIdScriptPath = [[NSBundle mainBundle] pathForResource:@"TeamIDScript" ofType:@"sh"];
    [self runTaskWithLaunchPath:teamIdScriptPath andArgument:@[project.rootDirectory]];
}

- (void)runBuildScript{
    [self showStatus:@"Cleaning..." andShowProgressBar:YES withProgress:-1];
    scriptType = ScriptTypeBuild;
    
    //Create Export Option Plist
    if (![project createExportOptionPlist]){
        [Common showAlertWithTitle:@"Error" andMessage:@"Unable to create file in this directory."];
        return;
    }
    
    //Build Script
    NSString *buildScriptPath = [[NSBundle mainBundle] pathForResource:@"ProjectBuildScript" ofType:@"sh"];
    NSMutableArray *buildArgument = [[NSMutableArray alloc] init];
    
    //${1} Project Location
    [buildArgument addObject:project.rootDirectory];
    
    //${2} Project type workspace/scheme
    [buildArgument addObject:pathProject.URL.lastPathComponent];
    
    //${3} Build Scheme
    [buildArgument addObject:comboBuildScheme.stringValue];
    
    //${4} Archive Location
    [buildArgument addObject:[project.buildArchivePath.resourceSpecifier stringByRemovingPercentEncoding]];
    
    //${5} ipa Location
    [buildArgument addObject:[project.buildUUIDDirectory.resourceSpecifier stringByRemovingPercentEncoding]];
    
    //${6} export options plist Location
    [buildArgument addObject:[project.exportOptionsPlistPath.resourceSpecifier stringByRemovingPercentEncoding]];
    
    //Run Task
    [self runTaskWithLaunchPath:buildScriptPath andArgument:buildArgument];
}

- (void)runXcodePathScript{
    scriptType = ScriptTypeXcodePath;
    NSString *xcodePathSriptPath = [[NSBundle mainBundle] pathForResource:@"XCodePath" ofType:@"sh"];
    [self runTaskWithLaunchPath:xcodePathSriptPath andArgument:nil];
}

- (void)runALAppStoreScriptForValidation:(BOOL)isValidation{
    scriptType = isValidation ? ScriptTypeAppStoreValidation : ScriptTypeAppStoreUpload;
    [self showStatus:isValidation ? @"Validating IPA with AppStore..." : @"Uploading IPA on AppStore..." andShowProgressBar:YES withProgress:-1];
    NSString *alSriptPath = [[NSBundle mainBundle] pathForResource: @"ALAppStore" ofType:@"sh"];
    NSMutableArray *buildArgument = [[NSMutableArray alloc] init];

    
    //${1} Purpose
    NSString *purpose = isValidation ? abALValidateApp : abALUploadApp;
    [buildArgument addObject:purpose];
    
    //${2} AL Path
    [buildArgument addObject:project.alPath];
    
    //${3} Project Location
    [buildArgument addObject: [project.ipaFullPath.resourceSpecifier stringByRemovingPercentEncoding]];
    
    //${4} Project type workspace/scheme
    [buildArgument addObject:project.itcUserName];
    
    //${5} Build Scheme
    [buildArgument addObject:project.itcPasswod];
    
    [self runTaskWithLaunchPath:alSriptPath andArgument:buildArgument];
}


#pragma mark → Run and Capture task data

- (void)runTaskWithLaunchPath:(NSString *)launchPath andArgument:(NSArray *)arguments{
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = launchPath;
    task.arguments = arguments;
    [self captureStandardOutputWithTask:task];
    [task launch];
    if (scriptType == ScriptTypeTeamId){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [task terminate];
            [[AppDelegate appDelegate] addSessionLog:@"terminating task!!"];
        });
    }
}

- (void)captureStandardOutputWithTask:(NSTask *)task{
    NSPipe *outputPipe = [[NSPipe alloc] init];
    [task setStandardOutput:outputPipe];
    [task setStandardError:outputPipe];
    [outputPipe.fileHandleForReading waitForDataInBackgroundAndNotify];
    [[NSNotificationCenter defaultCenter] addObserverForName:NSFileHandleDataAvailableNotification object:outputPipe.fileHandleForReading queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        NSData *outputData =  outputPipe.fileHandleForReading.availableData;
        NSString *outputString = [[NSString alloc] initWithData:outputData encoding:NSUTF8StringEncoding];
        [[AppDelegate appDelegate] addSessionLog:[NSString stringWithFormat:@"Task Output - %@\n",outputString]];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //Handle Project Scheme Response
            if (scriptType == ScriptTypeGetScheme){
                NSError *error;
                NSDictionary *buildList = [NSJSONSerialization JSONObjectWithData:outputData options:NSJSONReadingAllowFragments error:&error];
                if (buildList != nil){
                    [project setBuildListInfo:buildList];
                    [comboBuildScheme removeAllItems];
                    [comboBuildScheme addItemsWithObjectValues:project.schemes];
                    if (comboBuildScheme.numberOfItems > 0){
                        [comboBuildScheme selectItemAtIndex:0];
                        if (repoProject == nil) {
                            [self comboBuildSchemeValueChanged:comboBuildScheme];
                            
                            //Run Team Id Script
                            [self runTeamIDScript];
                        } else {
                            [RepoBuilder setProjectSettingFromProject:repoProject toProject:project];
                            [comboTeamId removeAllItems];
                            [comboTeamId addItemWithObjectValue:project.teamId];
                            [comboTeamId selectItemWithObjectValue:project.teamId];
                            [comboBuildType selectItemWithObjectValue:project.buildType];
                            [textFieldEmail setStringValue:project.emails];
                            [textFieldMessage setStringValue:project.personalMessage];
                            if (project.emails.length > 0){
                                [buttonSendMail setState:NSOnState];
                            }
                            [self actionButtonTapped:buttonAction];
                        }
                    }
                }else{
                    if (schemeScriptRunCount == 3){
                        schemeScriptRunCount = 0;
                        [self viewStateForProgressFinish:YES];
                        [Common showAlertWithTitle:@"" andMessage:@"Failed to load scheme information. Please try again."];
                    } else {
                        schemeScriptRunCount++;
                        [self runGetSchemeScript];
                        [[AppDelegate appDelegate] addSessionLog:@"Failed to load scheme information."];
                    }
                }
            }
            
            //Handle Team Id Response
            else if (scriptType == ScriptTypeTeamId){
                if ([outputString.lowercaseString containsString:@"development_team"]){
                    NSArray *outputComponent = [outputString componentsSeparatedByString:@"\n"];
                    NSString *devTeam = [[outputComponent filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF CONTAINS 'DEVELOPMENT_TEAM'"]] firstObject];
                    if (devTeam != nil) {
                        project.teamId = [[devTeam componentsSeparatedByString:@" = "] lastObject];
                        if (project.teamId != nil){
                            NSDictionary *team = [[allTeamIds filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.teamId LIKE %@",project.teamId]] firstObject];
                            if (team != nil){
                                [comboTeamId selectItemAtIndex:[allTeamIds indexOfObject:team]];
                            }else{
                                [comboTeamId addItemWithObjectValue:project.teamId];
                                [comboTeamId selectItemWithObjectValue:project.teamId];
                            }
                            [self updateViewState];
                            [self showStatus:@"Now please select ipa type (save for). You can view log from File -> View Log." andShowProgressBar:NO withProgress:-1];
                        }
                    }
                } else if ([outputString.lowercaseString containsString:@"endofteamidscript"] || outputString.lowercaseString.length == 0) {
                    [self showStatus:@"Can't able to find Team ID! Please select/enter manually!" andShowProgressBar:NO withProgress:-1];
                } else {
                    [outputPipe.fileHandleForReading waitForDataInBackgroundAndNotify];
                }
            }
            
            //Handle Build Response
            else if (scriptType == ScriptTypeBuild){
                
                XCArchiveResult *result = [XCArchiveParser archiveResultMessageFromString:outputString];
                switch (result.type) {
                    case XCArchiveResultCleanSucceeded:{
                        
                    }break;
                        
                    case XCArchiveResultArchiveFailed:{
                        
                    }break;
                        
                    case XCArchiveResultArchiveSucceeded:{
                        
                    }break;
                        
                    case XCArchiveResultExportFailed:{
                        
                    }break;
                        
                    case XCArchiveResultExportSucceeded:{
                        
                    }break;
                        
                    default:
                        break;
                }
                
                
                if ([outputString.lowercaseString containsString:@"archive succeeded"]){
                    [self showStatus:@"Creating IPA..." andShowProgressBar:YES withProgress:-1];
                    [outputPipe.fileHandleForReading waitForDataInBackgroundAndNotify];
                } else if ([outputString.lowercaseString containsString:@"clean succeeded"]){
                    [self showStatus:@"Archiving..." andShowProgressBar:YES withProgress:-1];
                    [outputPipe.fileHandleForReading waitForDataInBackgroundAndNotify];
                } else if ([outputString.lowercaseString containsString:@"export succeeded"]){
                    //Check and Upload IPA File
                    if (project.isBuildOnly){
                        [self showStatus:[NSString stringWithFormat:@"Export Succeeded - %@",project.buildUUIDDirectory] andShowProgressBar:NO withProgress:-1];
                    }else{
                        [self showStatus:@"Export Succeeded" andShowProgressBar:YES withProgress:-1];
                        [self checkIPACreated];
                    }
                    
                } else if ([outputString.lowercaseString containsString:@"export failed"]){
                    [self showStatus:@"Export Failed" andShowProgressBar:NO withProgress:-1];
                    [Common showAlertWithTitle:@"Export Failed" andMessage:outputString];
                    [self viewStateForProgressFinish:YES];
                } else if ([outputString.lowercaseString containsString:@"archive failed"]){
                    if ([AppDelegate appDelegate].isInternetConnected || [outputString containsString:@"^"]){
                        [self showStatus:@"Archive Failed" andShowProgressBar:NO withProgress:-1];
                        [Common showAlertWithTitle:@"Archive Failed" andMessage:outputString];
                        [self viewStateForProgressFinish:YES];
                    }else{
                        [self showStatus:abNotConnectedToInternet andShowProgressBar:YES withProgress:-1];
                        uploadManager.lastfailedOperation = [NSBlockOperation blockOperationWithBlock:^{
                            [self runBuildScript];
                        }];
                    }
                } else {
                    [outputPipe.fileHandleForReading waitForDataInBackgroundAndNotify];
                }
            }
            
            //Handle Xcode Path Response
            else if (scriptType == ScriptTypeXcodePath){
                
            }
            
            //Handle AppStore Validation and Upload Response
            else if (scriptType == ScriptTypeAppStoreValidation || scriptType == ScriptTypeAppStoreUpload){
                [self appStoreScriptOutputHandlerWithOutput:outputString];
            }
        });
    }];
}

-(void)appStoreScriptOutputHandlerWithOutput:(NSString *)output{
    //parse application loader response
    ALOutput *alOutput = [ALOutputParser messageFromXMLString:output];
    [alOutput.messages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self showStatus:obj andShowProgressBar:NO withProgress:-1];
    }];
    
    //check if response is valid or error
    if (alOutput.isValid){
        if (scriptType == ScriptTypeAppStoreValidation){
            //run appstore upload script
            [self runALAppStoreScriptForValidation:NO];
        }else if (scriptType == ScriptTypeAppStoreUpload){
            //show upload succeess message
            [self showStatus:@"App uploaded to AppStore." andShowProgressBar:NO withProgress:-1];
            [Common showAlertWithTitle:@"App uploaded to AppStore." andMessage:nil];
            [self viewStateForProgressFinish:YES];
            NSDictionary *currentSetting = [self getBasicViewStateWithOthersSettings:@{@"Uploaded to":@"AppStore"}];
            [EventTracker logEventSettingWithType:LogEventSettingTypeUploadIPASuccess andSettings:currentSetting];
        }
    }else{
        //if internet is connected, show direct error
        if ([AppDelegate appDelegate].isInternetConnected){
            [Common showAlertWithTitle:@"Error" andMessage:[alOutput.messages componentsJoinedByString:@"\n\n"]];
            [self viewStateForProgressFinish:YES];
        }else{
            
            //if internet connection is lost, show watting message and start process again when connected
            [self showStatus:abNotConnectedToInternet andShowProgressBar:YES withProgress:-1];
            uploadManager.lastfailedOperation = [NSBlockOperation blockOperationWithBlock:^{
                if (scriptType == ScriptTypeAppStoreValidation){
                    [self runALAppStoreScriptForValidation:YES];
                }else if (scriptType == ScriptTypeAppStoreUpload){
                    [self runALAppStoreScriptForValidation:NO];
                }
            }];
        }
    }
}

#pragma mark - Get IPA Info and Upload -

-(void)checkIPACreated{
    NSString *ipaPath = [project.ipaFullPath.resourceSpecifier stringByRemovingPercentEncoding];
    if ([[NSFileManager defaultManager] fileExistsAtPath:ipaPath]){
        if ([comboBuildType.stringValue isEqualToString: BuildTypeAppStore]){
            //get required info and upload to appstore
            [self runALAppStoreScriptForValidation:YES];
        }else{
            //get ipa details and upload to dropbox
            [uploadManager uploadIPAFile:project.ipaFullPath];
        }
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self checkIPACreated];
        });
    }
}

#pragma mark - Dropbox Helper -
#pragma mark → Dropbox Notification Handler
- (void)handleLoggedInNotification:(NSNotification *)notification{
    [self updateMenuButtons];
    [self viewStateForProgressFinish:YES];
}

- (void)dropboxLogoutHandler:(id)sender{
    //handle dropbox logout for authorized users
    if ([DBClientsManager authorizedClient]){
        [DBClientsManager unlinkAndResetClients];
        [self viewStateForProgressFinish:YES];
        [self performSegueWithIdentifier:@"DropBoxLogin" sender:self];
    }
}


#pragma mark - Controller Helpers -

-(void)viewStateForProgressFinish:(BOOL)finish{
    [[AppDelegate appDelegate] addSessionLog:[NSString stringWithFormat:@"Updating view setting for finish - %@", [NSNumber numberWithBool:finish]]];
    [[AppDelegate appDelegate] setProcessing:!finish];
    [[AppDelegate appDelegate] setIsReadyToBuild:!finish];
    
    //reset project
    if (finish){
        project = [[XCProject alloc] init];
        [project setBuildDirectory:[UserData buildLocation]];
        [uploadManager setProject:project];
        [MBProgressHUD hideAllHUDsForView:self.view animated:true];
    }
    
    //unique link
    [buttonUniqueLink setEnabled:finish];
    [buttonUniqueLink setState: finish ? NSOffState : buttonUniqueLink.state];
    
    //ipa path
    [pathIPAFile setEnabled:finish];
    [pathIPAFile setURL: finish ? nil : pathIPAFile.URL.filePathURL];
    
    //project path
    [pathProject setEnabled:finish];
    [pathProject setURL: finish ? nil : pathProject.URL.filePathURL];
    
    //team id combo
    [comboTeamId setEnabled:finish];
    if (finish){
        //setup team id
        [comboTeamId removeAllItems];
        [comboTeamId setStringValue:abEmptyString];
        [allTeamIds enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [comboTeamId addItemWithObjectValue:[obj valueForKey:abFullName]];
        }];
    }
    
    //build type combo
    [comboBuildType setEnabled:finish];
    if (finish && comboBuildType.indexOfSelectedItem >= 0) [comboBuildType deselectItemAtIndex:comboBuildType.indexOfSelectedItem];
    
    //build scheme
    [comboBuildScheme setEnabled:finish];
    if (finish){
        if (comboBuildScheme.indexOfSelectedItem >= 0){
            [comboBuildScheme setStringValue:abEmptyString];
            [comboBuildScheme deselectItemAtIndex:comboBuildType.indexOfSelectedItem];
        }
        [comboBuildScheme removeAllItems];
    }
    
    
    //send mail
    [buttonSendMail setEnabled:finish];
    [buttonShutdownMac setEnabled:(finish && buttonSendMail.state == NSOnState)];
    [textFieldEmail setEnabled:(finish && buttonSendMail.state == NSOnState)];
    [textFieldMessage setEnabled:(finish && buttonSendMail.state == NSOnState)];
    
    //action button
    [self updateViewState];
    
    //logout buttons
    [self updateMenuButtons];
}

-(void)resetBuildOptions{
    [comboTeamId removeAllItems];
    [comboBuildScheme removeAllItems];
}

-(void)showStatus:(NSString *)status andShowProgressBar:(BOOL)showProgressBar withProgress:(double)progress{
    //log status in session log
    [[AppDelegate appDelegate]addSessionLog:[NSString stringWithFormat:@"%@",status]];
    
    //start/stop/progress based on showProgressBar and progress
    if (progress == -1){
        if (showProgressBar){
            [MBProgressHUD showStatus:status onView:self.view];
        }else{
            [MBProgressHUD showOnlyStatus:status onView:self.view];
        }
    }else{
        if (showProgressBar){
            [MBProgressHUD showStatus:status witProgress:progress onView:self.view];
        }else{
            [MBProgressHUD showOnlyStatus:status onView:self.view];
        }
    }
}

-(void)updateViewState{
    //update action button
    BOOL enable = ((comboBuildScheme.stringValue != nil && comboBuildType.stringValue.length > 0 && //build scheme
                    comboBuildType.stringValue != nil && comboBuildType.stringValue.length > 0 && //build type
                    comboTeamId.stringValue != nil && comboTeamId.stringValue.length > 0 && //team id
                    tabView.tabViewItems.firstObject.tabState == NSSelectedTab &&
                    (![comboBuildType.stringValue isEqualToString: BuildTypeAppStore] || project.itcPasswod.length > 0)) ||
                   
                   //if ipa selected
                   (project.ipaFullPath != nil && tabView.tabViewItems.lastObject.tabState == NSSelectedTab));
    [buttonAction setEnabled:(enable && (pathProject.enabled || pathIPAFile.enabled))];
    [buttonAction setTitle:(tabView.selectedTabViewItem.label)];
    
    //update CI button
    //[buttonConfigCI setHidden:(tabView.tabViewItems.lastObject.tabState == NSSelectedTab)];
    //[buttonConfigCI setEnabled:(buttonAction.enabled && !buttonConfigCI.hidden)];
    
    //update keepsame link
    [buttonUniqueLink setEnabled:((project.buildType == nil || ![project.buildType isEqualToString:BuildTypeAppStore] ||
                                  tabView.tabViewItems.lastObject.tabState == NSSelectedTab) && ![[AppDelegate appDelegate] processing])];
    
    //update advanced button
    [buttonAdcanced setEnabled:buttonAction.enabled];
    
}

-(void)updateMenuButtons{
    //Menu Buttons
    BOOL enable = ([DBClientsManager authorizedClient] && pathProject.enabled && pathIPAFile.enabled);
    [[[AppDelegate appDelegate] dropboxLogoutButton] setEnabled:enable];
}

//get optional feature enable/disable dictionary
-(NSDictionary *)getBasicViewStateWithOthersSettings:(NSDictionary *)otherSettings{
    if (otherSettings == nil){
        otherSettings = @{};
    }
    NSMutableDictionary *viewState = [[NSMutableDictionary alloc] initWithDictionary:otherSettings];
    [viewState setValue:[NSNumber numberWithInteger: buttonUniqueLink.state] forKey:@"Same Link"];
    [viewState setValue:[NSNumber numberWithInteger: buttonSendMail.state] forKey:@"Sent Mail"];
    [viewState setValue:[NSNumber numberWithInteger: buttonShutdownMac.state] forKey:@"Shudown Mac"];
    return viewState;
}

#pragma mark - E-Mail -
-(void)enableMailField:(BOOL)enable{
    //Gmail Logout Button
    [self updateMenuButtons];
    
    //Enable text fields
    [textFieldEmail setEnabled:enable];
    [textFieldMessage setEnabled:enable];
    
    //Get last time valid data
    [textFieldEmail setStringValue: enable ? [UserData userEmail] : abEmptyString];
    [textFieldMessage setStringValue: enable ? [UserData userMessage] : abEmptyString];
    
    //Just for confirm changes
    [self textFieldMailValueChanged:textFieldEmail];
    [self textFieldDevMessageValueChanged:textFieldMessage];
}

#pragma mark - TabView Delegate -
-(void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem{
    //update view state based on selected tap
    [self updateViewState];
}

-(BOOL)tabView:(NSTabView *)tabView shouldSelectTabViewItem:(NSTabViewItem *)tabViewItem{
    return ![AppDelegate appDelegate].processing;
}

#pragma mark - ProjectAdvancedViewDelegate - 
- (void)projectAdvancedSaveButtonTapped:(NSButton *)sender{

}

- (void)projectAdvancedCancelButtonTapped:(NSButton *)sender{
    
}

#pragma mark - AppleDeveloperLogin Delegate -
- (void)itcLoginResult:(BOOL)success{
    if (success) {
        //check xcode and application loader path
        [XCHandler getXCodePathWithCompletion:^(NSString *xcodePath, NSString *applicationLoaderPath) {
            if (xcodePath != nil){
                [project setXcodePath: xcodePath];
                if (applicationLoaderPath != nil){
                    [project setAlPath: applicationLoaderPath];
                    
                    //check for ipa, if ipa start upload
                    if (project.fullPath == nil && tabView.tabViewItems.lastObject.tabState == NSSelectedTab){
                        [self runALAppStoreScriptForValidation:YES];
                    }else{
                        [self updateViewState];
                    }
                }else{
                    [Common showAlertWithTitle:@"Error" andMessage:@"Can't able to find application loader in your machine."];
                }
            }else{
                [Common showAlertWithTitle:@"Error" andMessage:@"Can't able to find xcode in your machine."];
            }
        }];
    }
}

-(void)itcLoginCanceled{
    if (project.fullPath == nil && tabView.tabViewItems.lastObject.tabState == NSSelectedTab){
        [uploadManager uploadIPAFileWithoutUnzip:project.ipaFullPath];
    } else {
        [project setBuildType:abEmptyString];
        [comboBuildType deselectItemAtIndex:comboBuildType.indexOfSelectedItem];
        [self updateViewState];
    }
}

#pragma mark - Navigation -
-(void)logAppUploadEventAndShareURLOnSlackChannel{
    //Log IPA Upload Success Rate with Other Options
    NSDictionary *currentSetting = [self getBasicViewStateWithOthersSettings:@{@"Uploaded to":@"Dropbox"}];
    [EventTracker logEventSettingWithType:LogEventSettingTypeUploadIPASuccess andSettings:currentSetting];
    
    if ([UserData userSlackMessage].length > 0) {
        [self showStatus:@"Sending Message on Slack..." andShowProgressBar:YES withProgress:-1];
        [SlackClient sendMessageForProject:project completion:^(BOOL success) {
            [self handleAppURLAfterSlack];
        }];
    } else {
        [self handleAppURLAfterSlack];
    }
}


-(void) handleAppURLAfterSlack {
    //Send mail if valid email address othervise show link
    if (textFieldEmail.stringValue.length > 0 && [MailHandler isAllValidEmail:textFieldEmail.stringValue]) {
        [self showStatus:@"Sending Mail..." andShowProgressBar:YES withProgress:-1];
        [MailHandler sendMailForProject:project complition:^(BOOL success) {
            if (success) {
                [MBProgressHUD showStatus:@"Mail Sent" forSuccess:YES onView:self.view];
                if (buttonShutdownMac.state == NSOnState){
                    //if mac shutdown is checked then shutdown mac after 60 sec
                    [self viewStateForProgressFinish:YES];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [MacHandler shutdownSystem];
                    });
                }else if(![self.presentedViewControllers.lastObject isKindOfClass:[ShowLinkViewController class]]){
                    //if mac shutdown isn't checked then show link
                    if (repoProject == nil){
                        [self performSegueWithIdentifier:@"ShowLink" sender:self];
                    }else{
                        [self viewStateForProgressFinish:YES];
                        exit(0);
                    }
                }
            } else {
                [MBProgressHUD showStatus:@"Mail Failed" forSuccess:NO onView:self.view];
                [self performSegueWithIdentifier:@"ShowLink" sender:self];
            }
        }];
    }else{
        [self performSegueWithIdentifier:@"ShowLink" sender:self];
    }
}

-(void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender{
    
    //prepare to show link
    if ([segue.destinationController isKindOfClass:[ShowLinkViewController class]]) {
        //set project to destination
        [((ShowLinkViewController *)segue.destinationController) setProject:project];
        [self viewStateForProgressFinish:YES];
    }
    
    //prepare to show advanced project settings
    else if([segue.destinationController isKindOfClass:[ProjectAdvancedViewController class]]){
        ProjectAdvancedViewController *projectAdvancedViewController = ((ProjectAdvancedViewController *)segue.destinationController);
        [projectAdvancedViewController setProject:project];
        [projectAdvancedViewController setDelegate:self];
    }
    
    //prepare to show CI controller
    else if([segue.destinationController isKindOfClass:[CIViewController class]]){
        CIViewController *ciViewController = ((CIViewController *)segue.destinationController);
        [ciViewController setProject:project];
    }
    
    //prepare to show AppleDeveloperLogin
    else if ([segue.destinationController isKindOfClass:[ITCLoginViewController class]]){
        ITCLoginViewController *itcLoginViewController = ((ITCLoginViewController *)segue.destinationController);
        [itcLoginViewController setProject:project];
        [itcLoginViewController setDelegate:self];
    }
}

@end
