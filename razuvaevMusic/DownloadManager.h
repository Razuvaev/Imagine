//
//  DownloadManager.h
//  razuvaevMusic
//
//  Created by Vladimir Vishnyagov on 22.08.16.
//  Copyright © 2016 Pavel Razuvaev. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DownloadManager : NSObject

+ (instancetype)sharedInstance;

- (NSURLSessionDownloadTask*)downloadAudioWithAudioObject:(AudioObject*)audioObject WithProgress:(NSProgress*)progress WithCompletion:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;

@end