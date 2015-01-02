//
//  editViewController.h
//  parsePushConnect
//
//  Created by Michael Kane on 12/31/14.
//  Copyright (c) 2014 ArilogicApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Account.h"

@interface editViewController : UIViewController

@property (strong, nonatomic) Account *currentAccount;
@property (strong, nonatomic) IBOutlet UITextField *accountName;
@property (strong, nonatomic) IBOutlet UITextField *parseID;
@property (strong, nonatomic) IBOutlet UITextField *parseClientKey;

@end
