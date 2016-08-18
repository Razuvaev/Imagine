//
//  PRSoundManager.h
//  razuvaevMusic
//
//  Created by Pavel Razuvaev on 16.11.15.
//  Copyright © 2015 Pavel Razuvaev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AudioObject.h"

@protocol PRSoundManagerDelegate;

@interface PRSoundManager : NSObject

+ (PRSoundManager *)sharedManager;

@property (nonatomic, strong) MPMoviePlayerController *player;
@property (nonatomic, strong) NSMutableArray *playlist;
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic) BOOL shuffle;

@property (nonatomic, weak) NSObject<PRSoundManagerDelegate> *delegate;

- (void)playAudio:(AudioObject *)audio;

- (void)pause;
- (void)play;
- (void)previousTrack;
- (void)nextTrack;
- (BOOL)isPlayingNow;

@end

@protocol PRSoundManagerDelegate<NSObject>
@optional
- (void)coverWasFound:(NSString *)url;
- (void)newAudio:(AudioObject *)audio;
@end