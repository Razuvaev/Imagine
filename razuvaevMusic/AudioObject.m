//
//  AudioObject.m
//  razuvaevMusic
//
//  Created by Pavel Razuvaev on 15.11.15.
//  Copyright © 2015 Pavel Razuvaev. All rights reserved.
//

#import "AudioObject.h"
#import "DownloadManager.h"
#import "MyMusicViewController.h"
#import "TabBarController.h"

static void *ProgressObserverContext = &ProgressObserverContext;

@interface AudioObject ()

@end

@implementation AudioObject

-(void)dealloc {
    self.delegate = nil;
}

- (void)updateWithDictionary:(NSDictionary *)dict {
    if ([[dict valueForKey:@"artist"] isKindOfClass:[NSString class]]) {
        self.artist = [dict valueForKey:@"artist"];
    }
    
    if ([[dict valueForKey:@"title"] isKindOfClass:[NSString class]]) {
        self.title = [dict valueForKey:@"title"];
    }
    
    if ([[dict valueForKey:@"url"] isKindOfClass:[NSString class]]) {
        self.url = [dict valueForKey:@"url"];
    }
    
    if ([[dict valueForKey:@"duration"] isKindOfClass:[NSNumber class]]) {
        self.duration = [dict valueForKey:@"duration"];
    }
}

- (AudioFileState)downloadStatus {
    if (_currentTask) {
        if (_progress && _progress.fractionCompleted != 1.0) {
            return AudioFileDownloading;
        }
    }
    if ([[MainStorage sharedMainStorage] checkAudioCached:self.title artist:self.artist]) {
        return AudioFileCached;
    }
    return AudioFilePlain;
}

- (void)downloadAudioFile {
    self.progress = [NSProgress progressWithTotalUnitCount:1];
    [self.progress addObserver:self forKeyPath:NSStringFromSelector(@selector(fractionCompleted)) options:NSKeyValueObservingOptionInitial context:ProgressObserverContext];
    [self.progress becomeCurrentWithPendingUnitCount:1];
    self.currentTask = [[DownloadManager sharedInstance] downloadAudioWithAudioObject:self WithProgress:self.progress WithCompletion:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        if (!error) {
            AudioManagedObject *audioManagedObject = [[MainStorage sharedMainStorage] createNewAudioObject];
            [audioManagedObject updateWithAudio:self WithHomePath:filePath.lastPathComponent];
            [[MainStorage sharedMainStorage] saveContext];
#warning TODO: need reload list of songs, something like this
            MyMusicViewController *myMusicVc = (MyMusicViewController *)[TabBarController viewControllerForIndex:0];
            [myMusicVc.tableView reloadData];
        }
        else
        {
            NSLog(@"%@",error.localizedDescription);
        }

        @try {
            [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(fractionCompleted)) context:ProgressObserverContext];
        } @catch (NSException *exception) {
        }
        
        self.currentTask = nil;
        self.progress = nil;
        [self.delegate changeStateDownloading:self];
    }];
    [self.delegate changeStateDownloading:self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    if (context == ProgressObserverContext) {
        NSProgress *progress = object;
        [self.delegate changeFraction:progress.fractionCompleted];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object
                               change:change context:context];
    }
}

- (void)cancelDownload {
    @try {
        [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(fractionCompleted)) context:ProgressObserverContext];
    } @catch (NSException *exception) {
    }
    if (_currentTask) {
        [_currentTask cancel];
    }
    _progress = nil;
    _currentTask = nil;
    
    [self.delegate changeStateDownloading:self];
}

@end

@implementation AudioManagedObject

@dynamic artist;
@dynamic title;
@dynamic url;
@dynamic home_url;
@dynamic duration;
@dynamic order;

-(void)updateWithAudio:(AudioObject *)audioObject WithHomePath:(NSString*)path {
    self.artist = audioObject.artist;
    self.title = audioObject.title;
    self.url = audioObject.url;
    self.duration = audioObject.duration;
    self.home_url = path;
    self.order = @([MainStorage sharedMainStorage].nextOrderNumber);
}

@end
