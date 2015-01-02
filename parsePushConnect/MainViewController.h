//
//  ViewController.h
//  parsePushConnect
//
//  Created by Michael Kane on 12/31/14.
//  Copyright (c) 2014 ArilogicApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountViewController.h"
#import <CoreData/CoreData.h>

@interface MainViewController : UIViewController <addAccountDelegate>

@property(nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

