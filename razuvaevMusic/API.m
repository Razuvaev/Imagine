//
//  API.m
//  razuvaevMusic
//
//  Created by Pavel Razuvaev on 16.11.15.
//  Copyright © 2015 Pavel Razuvaev. All rights reserved.
//

#import "API.h"

#define BING_KEY @"A4Ft6X7rDaHlQ0hJvoE15HNZOfr9UWAY53WqAlgxOlQ"

@implementation API

API *sharedAPI = nil;

+(API *)sharedAPI {
    if(sharedAPI == nil) {
        sharedAPI = [[API alloc] init];
        
    }
    return sharedAPI;
}

-(NSString *)getUrlAPI {
    return [NSString stringWithFormat:@"%@", coverURLAPI];
}

- (void)getCoverWithCompletion:(PRAPICompletion)completion ByArtist:(NSString *)artist andTitle:(NSString *)title {
    AFHTTPRequestOperationManager *currentRequestManaget = [AFHTTPRequestOperationManager manager];
    [currentRequestManaget setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    currentRequestManaget.responseSerializer = [AFJSONResponseSerializer serializer];
    
    currentRequestManaget.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/javascript", nil];
    
//    NSString *keyString = [NSString stringWithFormat:@"%@:%@", BING_KEY, BING_KEY];
//    NSData *plainTextData = [keyString dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *base64String = [plainTextData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//    NSString *authValue = [NSString stringWithFormat:@"Basic %@", base64String];
//    [currentRequestManaget.requestSerializer setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    [currentRequestManaget.requestSerializer setAuthorizationHeaderFieldWithUsername:@"" password:BING_KEY];
    
    NSString *unescaped = [NSString stringWithFormat:@"%@ %@", artist, title];
    NSString *escapedString = [unescaped stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    NSString *urlRequest = [NSString stringWithFormat:@"%@%@&$format=json",[self getUrlAPI], escapedString];

    [currentRequestManaget GET:urlRequest parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSURL *url;
        if (![[responseObject valueForKey:@"responseData"] isKindOfClass:[NSNull class]]) {
            for (NSDictionary *dict in [[responseObject valueForKey:@"responseData"] valueForKey:@"results"]) {
                url = [NSURL URLWithString:[dict valueForKey:@"url"]];
                
                if(urlIsImage(url)) {
                    break;
                }
            }
            completion([url absoluteString], nil);
        }else {
            completion(nil, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

BOOL urlIsImage(NSURL *url) {
    NSMutableURLRequest *request = [[NSURLRequest requestWithURL:url] mutableCopy];
    NSURLResponse *response = nil;
    NSError *error = nil;
    [request setValue:@"HEAD" forKey:@"HTTPMethod"];
    [NSURLConnection sendSynchronousRequest:request
                          returningResponse:&response
                                      error:&error];
    NSString *mimeType = [response MIMEType];
    NSRange range = [mimeType rangeOfString:@"image"];
    return (range.location != NSNotFound);
}

@end
