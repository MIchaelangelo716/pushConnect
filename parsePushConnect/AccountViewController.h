//
//  AccountViewController.h
//  parsePushConnect
//
//  Created by Michael Kane on 12/31/14.
//  Copyright (c) 2014 ArilogicApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Account.h"

@protocol addAccountDelegate;

@interface AccountViewController : UIViewController

@property (nonatomic, strong) Account *currentAccount;
@property (nonatomic, weak) id <addAccountDelegate> delegate;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end

@protocol addAccountDelegate <NSObject>

-(void)addAccountDidSave;
-(void)addAccountDidCancel:(Account*)accountToDelete;

@end