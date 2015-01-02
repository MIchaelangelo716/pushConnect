//
//  editViewController.m
//  parsePushConnect
//
//  Created by Michael Kane on 12/31/14.
//  Copyright (c) 2014 ArilogicApps. All rights reserved.
//

#import "editViewController.h"
#import "AppDelegate.h"

@interface editViewController ()
@property (strong, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UIVisualEffectView *blurView;

@end

@implementation editViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _doneButton.hidden = YES; 
    _accountName.text = [self.currentAccount accountName];
    _parseID.text = [self.currentAccount parseID];
    _parseClientKey.text = [self.currentAccount parseClientKey];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)done:(id)sender
{
    _accountName.enabled = NO;
    _parseClientKey.enabled = NO;
    _parseID.enabled = NO;
    
    _editButton.hidden = NO;
    _doneButton.hidden = YES;
    
    _accountName.borderStyle = UITextBorderStyleNone;
    _parseClientKey.borderStyle = UITextBorderStyleNone;
    _parseID.borderStyle = UITextBorderStyleNone;
    
    _currentAccount.accountName = _accountName.text;
    _currentAccount.parseClientKey = _parseClientKey.text;
    _currentAccount.parseID = _parseID.text; 
    
    AppDelegate *myApp = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [myApp saveContext];
}

- (IBAction)edit:(id)sender
{
    _accountName.enabled = YES;
    _parseClientKey.enabled = YES;
    _parseID.enabled = YES;
    
    _editButton.hidden = YES;
    _doneButton.hidden = NO;
    
    _accountName.borderStyle = UITextBorderStyleRoundedRect;
    _parseID.borderStyle = UITextBorderStyleRoundedRect;
    _parseClientKey.borderStyle = UITextBorderStyleRoundedRect;
}

@end
