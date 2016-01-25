//
//  ControlPanelView.m
//  razuvaevMusic
//
//  Created by Pavel Razuvaev on 17.11.15.
//  Copyright © 2015 Pavel Razuvaev. All rights reserved.
//

#import "ControlPanelView.h"
@interface ControlPanelView ()

@end

@implementation ControlPanelView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setupUI];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeButtonStates) name:@"changePlayBackState" object:nil];
    }
    return self;
}

#pragma mark setupUI
- (void)setupUI {
    [self addSubview:self.playButton];
    [self addSubview:self.pauseButton];
    [self addSubview:self.shuffleButton];
    [self addSubview:self.nextButton];
    [self addSubview:self.previousButton];
}

- (UIButton *)playButton {
    if (!_playButton) {
        UIImage *image = [[UIImage imageNamed:@"play"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        _playButton = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth/2 + 5, 0, 40, 40)];
        [_playButton setImage:image forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(playButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

- (UIButton *)pauseButton {
    if (!_pauseButton) {
        UIImage *image = [[UIImage imageNamed:@"pause"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        _pauseButton = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth/2 + 5, 0, 40, 40)];
        [_pauseButton setImage:image forState:UIControlStateNormal];
        [_pauseButton addTarget:self action:@selector(pauseButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pauseButton;
}

- (UIButton *)shuffleButton {
    if (!_shuffleButton) {
        UIImage *image = [[UIImage imageNamed:@"shuffle"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        _shuffleButton = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth/2 - 5 - 40, 0, 40, 40)];
        [_shuffleButton setImage:image forState:UIControlStateNormal];
        [_shuffleButton addTarget:self action:@selector(shuffleButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shuffleButton;
}

- (UIButton *)nextButton {
    if (!_nextButton) {
        UIImage *image = [[UIImage imageNamed:@"next"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        _nextButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_playButton.frame) + 10, 0, 40, 40)];
        [_nextButton setImage:image forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(nextButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}

- (UIButton *)previousButton {
    if (!_previousButton) {
        UIImage *image = [[UIImage imageNamed:@"previous"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

        _previousButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(_shuffleButton.frame) - 10 - 40, 0, 40, 40)];
        [_previousButton setImage:image forState:UIControlStateNormal];
        [_previousButton addTarget:self action:@selector(previousButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _previousButton;
}

#pragma mark Actions
- (void)playButtonAction {
    [self.delegate play];
}

- (void)pauseButtonAction {
    [self.delegate pause];
}

- (void)nextButtonAction {
    [self.delegate nextTrack];
}

- (void)previousButtonAction {
    [self.delegate previousTrack];
}

- (void)shuffleButtonAction {
    [self.delegate shuffle];
}

#pragma mark Notification

- (void)changeButtonStates {
    [UIView animateWithDuration:0.25 animations:^{
        [_playButton setAlpha:@(!_isPlaying).floatValue];
        [_pauseButton setAlpha:@(_isPlaying).floatValue];
    }];    
    _isPlaying = !_isPlaying;
}

@end
