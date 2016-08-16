//
//  TokenManager.h
//  razuvaevMusic
//
//  Created by Vladimir Vishnyagov on 16.08.16.
//  Copyright © 2016 Pavel Razuvaev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TokenManager : NSObject

+ (NSString*)fetchToken;
+ (void)persistToken:(NSString*)token;
+ (BOOL)isAuthorised;

@end
