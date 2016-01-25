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

@property (nonatomic, strong) UIButton *pauseButton;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *shuffleButton;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UIButton *previousButton;

@property (nonatomic) BOOL isPlaying;
@property (nonatomic, weak) NSObject<ControlPanelViewDelegate> *delegate;

@end

@protocol ControlPanelViewDelegate <NSObject>
@optional

- (void)play;
- (void)pause;
- (void)nextTrack;
- (void)previousTrack;
- (void)shuffle;

@end

