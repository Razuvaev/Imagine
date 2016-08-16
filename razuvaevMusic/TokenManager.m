//
//  TokenManager.m
//  razuvaevMusic
//
//  Created by Vladimir Vishnyagov on 16.08.16.
//  Copyright © 2016 Pavel Razuvaev. All rights reserved.
//

#import "TokenManager.h"

NSString * const accessTokenKey = @"accessToken";

@implementation TokenManager

+ (NSString*)fetchToken {
    return [userDefaults valueForKey:accessTokenKey];
}

+ (void)persistToken:(NSString*)token {
    [userDefaults setValue:token forKey:accessTokenKey];
}

+ (BOOL)isAuthorised
{
    return [TokenManager fetchToken] != nil;
}

@end
