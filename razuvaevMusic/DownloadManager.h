//
//  DownloadManager.h
//  razuvaevMusic
//
//  Created by Vladimir Vishnyagov on 22.08.16.
//  Copyright © 2016 Pavel Razuvaev. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AudioLoadOperationDelegate <NSObject>

- (void)dataWasLoaded;

@end

@interface DownloadManager : NSObject <AudioLoadOperationDelegate>

+ (instancetype)sharedInstance;

@end

@interface AudioLoadOperation : NSOperation

@property (nonatomic, strong) NSObject<AudioLoadOperationDelegate> *delegate;
@property (nonatomic, strong) NSString *url;

@end