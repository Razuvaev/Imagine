//
//  UserManagedObject.m
//  razuvaevMusic
//
//  Created by Pavel Razuvaev on 15.11.15.
//  Copyright © 2015 Pavel Razuvaev. All rights reserved.
//

#import "UserManagedObject.h"

@implementation UserManagedObject

@dynamic userId;
@dynamic firstName;
@dynamic lastName;
@dynamic avatarMediumUrl;
@dynamic settings;

@end

@implementation UserObject

- (void)updateWithUser:(VKUser *)user {
    self.userId = user.id;
    self.firstName = user.first_name;
    self.lastName = user.last_name;
    self.avatarMediumUrl = user.photo_100;
}

- (NSString *)fullName {
    return [NSString stringWithFormat:@"%@ %@", _firstName, _lastName];
}

@end
