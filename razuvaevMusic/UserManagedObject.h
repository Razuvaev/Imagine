//
//  UserManagedObject.h
//  razuvaevMusic
//
//  Created by Pavel Razuvaev on 15.11.15.
//  Copyright © 2015 Pavel Razuvaev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Settings.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserManagedObject : NSManagedObject

@property (nonatomic, copy) NSNumber *userId;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *avatarMediumUrl;
@property (nullable, nonatomic, retain) Settings *settings;

@end

@interface UserObject : NSObject

@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *avatarMediumUrl;
@property (nullable, nonatomic, retain) Settings *settings;

@property (nonatomic, readonly) NSString *fullName;

-(void)updateWithUser:(VKUser *)user;

@end

NS_ASSUME_NONNULL_END