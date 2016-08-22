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
#import "STKAudioPlayer.h"

@protocol PRSoundManagerDelegate;

@interface PRSoundManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, weak) NSObject<PRSoundManagerDelegate> *delegate;

- (void)nextAudio:(AudioObject*)audioObject;
- (void)pause;

- (STKAudioPlayerState)playerState;

//@property (nonatomic, strong) MPMoviePlayerController *player;
//@property (nonatomic, strong) NSMutableArray *playlist;
//@property (nonatomic) NSInteger currentIndex;
//@property (nonatomic) BOOL shuffle;

//- (void)playAudio:(AudioObject *)audio;

//- (void)pause;
//- (void)play;
//- (void)previousTrack;
//- (void)nextTrack;

@end

@protocol PRSoundManagerDelegate<NSObject>
//@optional
//- (void)coverWasFound:(NSString *)url;
//- (void)newAudio:(AudioObject *)audio;
- (void)changePlaybackState;

@end