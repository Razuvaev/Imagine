//
//  MainStorage.h
//  razuvaevMusic
//
//  Created by Pavel Razuvaev on 15.11.15.
//  Copyright © 2015 Pavel Razuvaev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "UserManagedObject.h"

@interface MainStorage : NSObject

+(MainStorage *)sharedMainStorage;
- (void)createNewUser:(UserObject *)user;

@property (nonatomic, strong, readonly) UserObject *currentUser;

@end
