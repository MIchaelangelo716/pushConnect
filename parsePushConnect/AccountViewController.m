//
//  AccountViewController.m
//  parsePushConnect
//
//  Created by Michael Kane on 12/31/14.
//  Copyright (c) 2014 ArilogicApps. All rights reserved.
//

#import "AccountViewController.h"

@interface AccountViewController ()
@property (strong, nonatomic) IBOutlet UITextField *accountName;
@property (strong, nonatomic) IBOutlet UITextField *parseID;
@property (strong, nonatomic) IBOutlet UITextField *parseClientKey;
@property (strong, nonatomic) IBOutlet UIVisualEffectView *blurView;
@property (strong, nonatomic) IBOutlet UINavigationBar *nav;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;

@end

@implementation AccountViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *viewWithBlurBG = [[UIVisualEffectView alloc] initWithEffect:effect];
    viewWithBlurBG.frame = self.view.bounds;
    [self.view addSubview:viewWithBlurBG];
    [viewWithBlurBG addSubview:_accountName];
    [viewWithBlurBG addSubview:_parseID];
    [viewWithBlurBG addSubview:_parseClientKey];
    UINavigationBar *navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    [viewWithBlurBG addSubview:navBar];
    [viewWithBlurBG addSubview:_cancelButton];
    [viewWithBlurBG addSubview:_saveButton];
    
    _accountName.text = [self.currentAccount accountName];
    _parseID.text = [self.currentAccount parseID];
    _parseClientKey.text = [self.currentAccount parseClientKey];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)cancel:(id)sender
{
    [self.delegate addAccountDidCancel:[self currentAccount]];
}

- (IBAction)save:(id)sender
{
    [self.currentAccount setAccountName:_accountName.text];
    [self.currentAccount setParseID:_parseID.text];
    [self.currentAccount setParseClientKey:_parseClientKey.text];
    [self.delegate addAccountDidSave];
}
@end
