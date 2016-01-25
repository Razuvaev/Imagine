//
//  API.h
//  razuvaevMusic
//
//  Created by Pavel Razuvaev on 16.11.15.
//  Copyright © 2015 Pavel Razuvaev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

#define coverURLAPI @"https://api.datamarket.azure.com/Data.ashx/Bing/Search/v1/Image?Query="

@interface API : NSObject <NSXMLParserDelegate>

+(API *)sharedAPI;
-(NSString *)getUrlAPI;

typedef void (^PRAPICompletion)(id response, NSError *error);

- (void)getCoverWithCompletion:(PRAPICompletion)completion ByArtist:(NSString *)artist andTitle:(NSString *)title;

@end
