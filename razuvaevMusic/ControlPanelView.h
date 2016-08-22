//
//  ControlPanelView.h
//  razuvaevMusic
//
//  Created by Pavel Razuvaev on 17.11.15.
//  Copyright © 2015 Pavel Razuvaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ControlPanelViewDelegate;

@interface ControlPanelView : UIView

@property (nonatomic) BOOL isPlaying;
@property (nonatomic, weak) NSObject<ControlPanelViewDelegate> *delegate;

- (void)newAudio:(AudioObject *)audio;
- (void)changePlaybackState;

@end

@protocol ControlPanelViewDelegate <NSObject>
@optional

- (void)play;
- (void)pause;
- (void)nextTrack;
- (void)previousTrack;
- (void)shuffle;

@end

