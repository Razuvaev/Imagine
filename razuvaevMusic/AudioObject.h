//
//  AudioObject.h
//  razuvaevMusic
//
//  Created by Pavel Razuvaev on 15.11.15.
//  Copyright © 2015 Pavel Razuvaev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@protocol AudioDownloadDelegate <NSObject>

- (void)changeStateDownloading:(id)audio;
- (void)changeFraction:(double)fraction;

@end

typedef NS_ENUM(NSUInteger, AudioFileState) {
    AudioFilePlain,
    AudioFileCached,
    AudioFileDownloading
};

@interface AudioObject : NSObject

@property (nonatomic, strong) NSString *artist;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSNumber *duration;

- (void)updateWithDictionary:(NSDictionary *)dict;

#pragma mark - Downloading

@property (nonatomic,strong) id <AudioDownloadDelegate> delegate;
- (AudioFileState)downloadStatus;
- (void)downloadAudioFile;
- (void)cancelDownload;

@property (strong, nonatomic) NSURLSessionDownloadTask *currentTask;
@property (strong, nonatomic) NSProgress *progress;

@end

@interface AudioManagedObject : NSManagedObject

@property (nonatomic, strong) NSString *artist;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *home_url;
@property (nonatomic, strong) NSNumber *duration;
@property (nonatomic, strong) NSNumber *order;

-(void)updateWithAudio:(AudioObject *)audioObject WithHomePath:(NSString*)path;

@end
