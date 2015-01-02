//
//  Account.h
//  parsePushConnect
//
//  Created by Michael Kane on 12/31/14.
//  Copyright (c) 2014 ArilogicApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Account : NSManagedObject

@property (nonatomic, retain) NSString * accountName;
@property (nonatomic, retain) NSString * parseID;
@property (nonatomic, retain) NSString * parseClientKey;

@end
