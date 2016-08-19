//
//  ControlPanelView.m
//  razuvaevMusic
//
//  Created by Pavel Razuvaev on 17.11.15.
//  Copyright © 2015 Pavel Razuvaev. All rights reserved.
//

#import "ControlPanelView.h"

const CGFloat insetForComponetes = 5.f;

@interface ControlPanelView ()

@property (nonatomic, strong) UIButton *pauseButton;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *shuffleButton;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UIButton *previousButton;
@property (nonatomic, strong) UIView *topLine;

@property (nonatomic,strong) UILabel *labelArtist;
@property (nonatomic,strong) UILabel *labelSong;

@end

@implementation ControlPanelView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self setBackgroundColor:[UIColor colorWithRed:(247.0f/255.0f) green:(247.0f/255.0f) blue:(247.0f/255.0f) alpha:1]];
    }
    return self;
}

#pragma mark setupUI

- (void)setupUI {
    [self addSubview:self.previousButton];
    [self addSubview:self.playButton];
    [self addSubview:self.shuffleButton];
    [self addSubview:self.nextButton];
    [self addSubview:self.topLine];
    
    [self addSubview:self.labelArtist];
    [self addSubview:self.labelSong];
}

- (UIButton *)previousButton {
    if (!_previousButton) {
        UIImage *image = [[UIImage imageNamed:@"previous"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

        _previousButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(_shuffleButton.frame) - 10 - 40, 0, 40, 40)];
        [_previousButton setImage:image forState:UIControlStateNormal];
        [_previousButton setImage:[image imageByApplyingAlpha:0.5f] forState:UIControlStateSelected];
        [_previousButton setImage:[image imageByApplyingAlpha:0.5f] forState:UIControlStateHighlighted];
        [_previousButton addTarget:self action:@selector(previousButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _previousButton;
}

- (UIButton*)playButton {
    if (!_playButton) {
        UIImage *image = [[UIImage imageNamed:@"play"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        _playButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_playButton setImage:image forState:UIControlStateNormal];
        [_playButton setImage:[image imageByApplyingAlpha:0.5f] forState:UIControlStateSelected];
        [_playButton setImage:[image imageByApplyingAlpha:0.5f] forState:UIControlStateHighlighted];
        [_playButton addTarget:self action:@selector(playButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

- (UIButton *)shuffleButton {
    if (!_shuffleButton) {
        UIImage *image = [[UIImage imageNamed:@"shuffle"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

        _shuffleButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_shuffleButton setImage:image forState:UIControlStateNormal];
        [_shuffleButton setImage:[image imageByApplyingAlpha:0.5f] forState:UIControlStateSelected];
        [_shuffleButton setImage:[image imageByApplyingAlpha:0.5f] forState:UIControlStateHighlighted];
        [_shuffleButton addTarget:self action:@selector(shuffleButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shuffleButton;
}

- (UIButton *)nextButton {
    if (!_nextButton) {
        UIImage *image = [[UIImage imageNamed:@"next"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        _nextButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_nextButton setImage:image forState:UIControlStateNormal];
        [_nextButton setImage:[image imageByApplyingAlpha:0.5f] forState:UIControlStateSelected];
        [_nextButton setImage:[image imageByApplyingAlpha:0.5f] forState:UIControlStateHighlighted];
        [_nextButton addTarget:self action:@selector(nextButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}

- (UIView*)topLine {
    if (!_topLine) {
        _topLine = [[UIView alloc] initWithFrame:CGRectZero];
        _topLine.backgroundColor = [UIColor colorWithWhite:0. alpha:0.25f];
    }
    return _topLine;
}

- (UILabel*)labelArtist {
    if (!_labelArtist) {
        _labelArtist = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelArtist.font = [UIFont boldSystemFontOfSize:12.f];
        _labelArtist.textAlignment = NSTextAlignmentCenter;
        _labelArtist.numberOfLines = 1;
        _labelArtist.lineBreakMode = NSLineBreakByTruncatingTail;
        [_labelArtist setText:@"Metallica"];
    }
    return _labelArtist;
}

- (UILabel*)labelSong {
    if (!_labelSong) {
        _labelSong = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelSong.font = [UIFont systemFontOfSize:11.f];
        _labelSong.textAlignment = NSTextAlignmentCenter;
        _labelSong.numberOfLines = 1;
        _labelSong.lineBreakMode = NSLineBreakByTruncatingTail;
        [_labelSong setText:@"Nothing else matters; Load (1991); 5:32"];
    }
    return _labelSong;
}

#pragma mark - layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _previousButton.frame = (CGRect) {
        .origin.x = insetForComponetes,
        .origin.y = insetForComponetes,
        .size.width = panelHeight-insetForComponetes*2.f,
        .size.height = panelHeight-insetForComponetes*2.f
    };
    
    _playButton.frame = (CGRect) {
        .origin.x = panelHeight,
        .origin.y = insetForComponetes,
        .size.width = panelHeight-insetForComponetes*2.f,
        .size.height = panelHeight-insetForComponetes*2.f
    };
    
    _shuffleButton.frame = (CGRect) {
        .origin.x = self.frame.size.width-panelHeight*2.f+insetForComponetes*2.f,
        .origin.y = insetForComponetes,
        .size.width = panelHeight-insetForComponetes*2.f,
        .size.height = panelHeight-insetForComponetes*2.f
    };
    
    _nextButton.frame = (CGRect) {
        .origin.x = self.frame.size.width-panelHeight+insetForComponetes,
        .origin.y = insetForComponetes,
        .size.width = panelHeight-insetForComponetes*2.f,
        .size.height = panelHeight-insetForComponetes*2.f
    };
    
    _topLine.frame= (CGRect) {
        .size.width = self.frame.size.width,
        .size.height = 1.f/[UIScreen mainScreen].scale
    };
    
    _labelArtist.frame = (CGRect) {
        .origin.x = CGRectGetMaxX(_playButton.frame),
        .origin.y = insetForComponetes/2.f,
        .size.width = CGRectGetMinX(_shuffleButton.frame)-CGRectGetMaxX(_playButton.frame),
        .size.height = panelHeight/2.f
    };
    
    _labelSong.frame = (CGRect) {
        .origin.x = CGRectGetMaxX(_playButton.frame)+insetForComponetes,
        .origin.y = panelHeight/2.f,
        .size.width = CGRectGetMinX(_shuffleButton.frame)-CGRectGetMaxX(_playButton.frame) - insetForComponetes*2.f,
        .size.height = panelHeight/2.f-insetForComponetes
    };
}

#pragma mark Actions

- (void)previousButtonAction {
    [self.delegate previousTrack];
}

- (void)playButtonAction {
    [self.delegate play];
}

- (void)nextButtonAction {
    [self.delegate nextTrack];
}

- (void)shuffleButtonAction {
    [self.delegate shuffle];
}

@end
