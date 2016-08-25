//
//  PRSoundManager.m
//  razuvaevMusic
//
//  Created by Pavel Razuvaev on 16.11.15.
//  Copyright © 2015 Pavel Razuvaev. All rights reserved.
//

#import "PRSoundManager.h"

@interface PRSoundManager () <STKAudioPlayerDelegate>

@property STKAudioPlayer *audioPlayer;

@end

@implementation PRSoundManager

#pragma mark - Inititialization

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance createPlayer];
    });
    
    return sharedInstance;
}

- (void)createPlayer {
    if (!_audioPlayer) {
        _audioPlayer = [[STKAudioPlayer alloc]init];
        _audioPlayer.delegate = self;
    }
}

#pragma mark - Player Actions

- (void)nextAudio:(id)audioObject {
    if ([audioObject isKindOfClass:[AudioManagedObject class]]) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        NSURL *url = [NSURL fileURLWithPathComponents:@[[documentsDirectoryURL path],[(AudioManagedObject*)audioObject home_url]]];
        [_audioPlayer play:url.absoluteString];
    }
    else {
        AudioManagedObject *managedObject = [[MainStorage sharedMainStorage] getCachedAudio:[audioObject title] artist:[audioObject artist]];
        if (managedObject) {
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            NSURL *url = [NSURL fileURLWithPathComponents:@[[documentsDirectoryURL path],[managedObject home_url]]];
            [_audioPlayer play:url.absoluteString];
        }
        else {
            NSURL *url = [NSURL URLWithString:[(AudioObject*)audioObject url]];
            [_audioPlayer play:url.absoluteString];
            if ([MainStorage sharedMainStorage].currentUser.settings.autodownload.boolValue) {
                if ([audioObject downloadStatus] == AudioFilePlain) {
                    [audioObject downloadAudioFile];
                }
            }
        }
    }
    [self setRemoteInfo:audioObject];
}

- (void)resume {
    [_audioPlayer resume];
}

- (void)pause {
    [_audioPlayer pause];
}

#pragma mark - STKAudioPlayerDelegate

- (void)audioPlayer:(STKAudioPlayer *)audioPlayer didStartPlayingQueueItemId:(NSObject *)queueItemId {
    
}

- (void)audioPlayer:(STKAudioPlayer *)audioPlayer unexpectedError:(STKAudioPlayerErrorCode)errorCode {
    
}

- (void)audioPlayer:(STKAudioPlayer *)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState {
    [self.delegate changePlaybackState];
}

- (void)audioPlayer:(STKAudioPlayer *)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject *)queueItemId {
    
}

- (void)audioPlayer:(STKAudioPlayer *)audioPlayer didFinishPlayingQueueItemId:(NSObject *)queueItemId withReason:(STKAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration {
    if (stopReason == STKAudioPlayerStopReasonEof) {
        [(PlayerViewController*)self.delegate nextTrack];
    }
}

#pragma mark Actions

- (void)setRemoteInfo:(AudioObject *)audio {
    if (!audio) {
        return;
    }
    
    NSMutableDictionary *albumInfo = [[NSMutableDictionary alloc] init];
    
    [albumInfo setObject:audio.title forKey:MPMediaItemPropertyTitle];
    [albumInfo setObject:audio.artist forKey:MPMediaItemPropertyArtist];
    [albumInfo setObject:audio.duration forKey:MPMediaItemPropertyPlaybackDuration];
    
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:albumInfo];
    
    //    UIImage *artWork = [UIImage imageNamed:@"launch4"];
    //    [albumInfo setObject:album.title forKey:MPMediaItemPropertyAlbumTitle];
    //    [albumInfo setObject:artWork forKey:MPMediaItemPropertyArtwork];
    //    [albumInfo setObject:album.elapsedTime forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime]
}

//- (void)playAudio:(AudioObject *)audio {
//    if (!_player) {
//        _player = [[MPMoviePlayerController alloc] init];
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(moviePlayBackDidFinish:)
//                                                     name:MPMoviePlayerPlaybackDidFinishNotification
//                                                   object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangePlaybackState) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
//        _shuffle = NO;
//    }
//    [_player setContentURL:[NSURL URLWithString:audio.url]];
//    [self setRemoteInfo:audio];
//    [_player play];
//    
//    [self.delegate newAudio:audio];
//    
//    [[API sharedAPI] getCoverWithCompletion:^(id response, NSError *error) {
//        [self.delegate coverWasFound:response];
//    } ByArtist:audio.artist andTitle:audio.title];
//}
//
//- (void)pause {
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"changePlayBackState" object:nil];
//    [_player pause];
//}
//
//- (void)play {
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"changePlayBackState" object:nil];    
//    [_player play];
//}
//

//

//
//#pragma mark Notifications
//- (void)moviePlayBackDidFinish:(NSNotification *)noti {
//    [self nextTrack];
//}
//
//- (void)didChangePlaybackState {
//    [self.delegate changePlaybackState];
//}
//
#pragma mark - State

- (STKAudioPlayerState)playerState {
    return _audioPlayer.state;
}

@end
