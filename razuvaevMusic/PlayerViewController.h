//
//  PlayerViewController.h
//  razuvaevMusic
//
//  Created by Pavel Razuvaev on 15.11.15.
//  Copyright © 2015 Pavel Razuvaev. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AudioObject.h"
#import "ControlPanelView.h"
#import "WebImageView.h"
#import "PRSoundManager.h"

typedef NS_ENUM(NSUInteger, PlayerState) {
    PlayerStatePanel,
    PlayerStateFullScreen,
};

@interface PlayerViewController : UIViewController <PRSoundManagerDelegate, ControlPanelViewDelegate>

@property (nonatomic, strong) ControlPanelView *controlPanel;

@property (nonatomic) NSInteger currentMusicIndex;
@property (nonatomic, strong) NSMutableArray *musicArray;

- (void)play;
- (void)pause;
- (void)previousTrack;
- (void)nextTrack;

+ (PlayerViewController*)currentPlayer;

@end
