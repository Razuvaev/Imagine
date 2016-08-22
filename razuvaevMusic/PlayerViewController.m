//
//  PlayerViewController.m
//  razuvaevMusic
//
//  Created by Pavel Razuvaev on 15.11.15.
//  Copyright © 2015 Pavel Razuvaev. All rights reserved.
//

#import "PlayerViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UICircularSlider.h"
#import "UIImage+ColorArt.h"
#import "MyMusicViewController.h"

@interface PlayerViewController ()

//@property (nonatomic, strong) UIButton *closeButton;
//
//@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
//
//@property (nonatomic, strong) UILabel *titleLabel;
//@property (nonatomic, strong) UILabel *artistLabel;
//
//@property (nonatomic, strong) WebImageView *imgToLoad;
//@property (nonatomic, strong) UIImageView *blurCover;
//@property (nonatomic, strong) WebImageView *cover;
//
//@property (nonatomic, strong) UICircularSlider *slider;
//@property (nonatomic, strong) SLColorArt *colorArt;

@end

@implementation PlayerViewController

+ (PlayerViewController*)currentPlayer {
    return [[TabBarController tabBarController] currentPlayer];
}

-(void)loadView {
    [super loadView];
    [self.view addSubview:self.controlPanel];
    
    CALayer *backgroundLayer = [[CALayer alloc] init];
    backgroundLayer.backgroundColor = [UIColor blackColor].CGColor;
    backgroundLayer.frame = (CGRect) {
        .origin.x = 0,
        .origin.y = panelHeight,
        .size.width = self.view.frame.size.width,
        .size.height = self.view.frame.size.height,
    };
    [self.view.layer addSublayer:backgroundLayer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.view addSubview:self.moviePlayer.view];
//    [self.view addSubview:self.imgToLoad];
//    [self.view addSubview:self.blurCover];
//    [self.view addSubview:self.cover];
//    [self.view addSubview:self.slider];
//    [self.view addSubview:self.closeButton];
//    [self.view addSubview:self.artistLabel];
//    [self.view addSubview:self.titleLabel];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupCoverAndColors:) name:@"imageLoaded" object:nil];
}

- (void)changePlaybackState {
    [self.controlPanel changePlaybackState];
}

- (void)play {
    if ([[PRSoundManager sharedInstance] playerState] ==  STKAudioPlayerStatePaused) {
        [[PRSoundManager sharedInstance] resume];
    }
    else {
        AudioObject *audio = [_musicArray objectAtIndex:_currentMusicIndex];
        [self.controlPanel newAudio:audio];
        [[PRSoundManager sharedInstance] nextAudio:audio];
    }
}

- (void)pause {
    [[PRSoundManager sharedInstance]pause];
}

- (void)previousTrack {
    if (_currentMusicIndex > 0) {
        _currentMusicIndex = _currentMusicIndex - 1;
    }else {
        _currentMusicIndex = _musicArray.count-1;
    }

    AudioObject *audio = [_musicArray objectAtIndex:_currentMusicIndex];
    [self.controlPanel newAudio:audio];
    [[PRSoundManager sharedInstance] nextAudio:audio];
    
    [self changeSelectionOnDataSource];
}

- (void)nextTrack {
    if (/* DISABLES CODE */ (YES)) {//_shuffle
        if (_currentMusicIndex < _musicArray.count - 1) {
            _currentMusicIndex = _currentMusicIndex + 1;
        }else {
            _currentMusicIndex = 0;
        }
    }else {
        _currentMusicIndex = arc4random_uniform((unsigned int)_musicArray.count);
    }
    AudioObject *audio = [_musicArray objectAtIndex:_currentMusicIndex];
    [self.controlPanel newAudio:audio];
    [[PRSoundManager sharedInstance] nextAudio:audio];
    
    [self changeSelectionOnDataSource];
}

- (void)changeSelectionOnDataSource {

#warning TODO: need reload list of songs

//    MyMusicViewController *dataSourceController = (MyMusicViewController *)[TabBarController viewControllerForIndex:0];
//    [dataSourceController.tableView reloadData];
//    [dataSourceController.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_currentMusicIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
    
    [super viewWillDisappear:animated];
}

#pragma mark - Layout

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [_controlPanel setFrame:CGRectMake(0.f,0.f,self.view.frame.size.width, panelHeight)];
}
//
//#pragma mark setupUI
//
//- (MPMoviePlayerController *)moviePlayer {
//    [[PRSoundManager sharedManager] setDelegate:self];
//    _moviePlayer = [PRSoundManager sharedManager].player;
//    [_moviePlayer.view setHidden:YES];
//    
//    return _moviePlayer;
//}
//
//- (UIButton *)closeButton {
//    if (!_closeButton) {
//        _closeButton = [[UIButton alloc] init];
//        [_closeButton setTitle:@"Закрыть" forState:UIControlStateNormal];
//        [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_closeButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateHighlighted];
//        [_closeButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateSelected];
//        [_closeButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
//        [_closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
//        [_closeButton sizeToFit];
//        [_closeButton setFrame:CGRectMake(screenWidth - 10 - _closeButton.frame.size.width, statusBarHeight, _closeButton.frame.size.width, _closeButton.frame.size.height)];
//    }
//    return _closeButton;
//}
//
//- (WebImageView *)imgToLoad {
//    if (!_imgToLoad) {
//        _imgToLoad = [[WebImageView alloc] init];
//        [_imgToLoad setHidden:YES];
//    }
//    return _imgToLoad;
//}
//
//- (UIImageView *)blurCover {
//    if (!_blurCover) {
//        _blurCover = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
//        [_blurCover setContentMode:UIViewContentModeScaleAspectFill];
//        [_blurCover setClipsToBounds:YES];
//    }
//    return _blurCover;
//}
//
//- (WebImageView *)cover {
//    if (!_cover) {
//        _cover = [[WebImageView alloc] initWithFrame:CGRectMake(20, screenHeight/2 - (screenWidth/2 - 10), screenWidth - 40, screenWidth - 40)];
//        [_cover setContentMode:UIViewContentModeScaleToFill];
//        [_cover setClipsToBounds:YES];
//        [_cover.layer setCornerRadius:_cover.frame.size.width/2];
//    }
//    return _cover;
//}
//
//- (UICircularSlider *)slider {
//    if (!_slider) {
//        _slider = [[UICircularSlider alloc] initWithFrame:_cover.frame];
//        [_slider setBackgroundColor:[UIColor clearColor]];
//    }
//    return _slider;
//}
//
//- (UILabel *)artistLabel {
//    if (!_artistLabel) {
//        _artistLabel = [[UILabel alloc] init];
//        [_artistLabel setTextColor:[UIColor colorWithWhite:1.0 alpha:0.7]];
//        [_artistLabel setFont:[UIFont systemFontOfSize:16]];
//        [_artistLabel setTextAlignment:NSTextAlignmentCenter];
//    }
//    return _artistLabel;
//}
//
//- (UILabel *)titleLabel {
//    if (!_titleLabel) {
//        _titleLabel = [[UILabel alloc] init];
//        [_titleLabel setTextColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
//        [_titleLabel setFont:[UIFont systemFontOfSize:18]];
//        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
//    }
//    return _titleLabel;
//}
//
- (ControlPanelView *)controlPanel {
    if (!_controlPanel) {
        _controlPanel = [[ControlPanelView alloc] initWithFrame:CGRectZero];
        _controlPanel.isPlaying = YES;
        [_controlPanel setDelegate:self];
    }
    return _controlPanel;
}
//
//#pragma mark Actions
//- (void)closeAction {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
//- (void)setupCoverAndColors:(NSNotification *)noti {
//    UIImage *image = (UIImage *)noti.object;
//    UIImage *bluredImage = [image blurredImage];
//    _colorArt = [image colorArt];
//
////    [_controlPanel.playButton setTintColor:_colorArt.secondaryColor];
////    [_controlPanel.pauseButton setTintColor:_colorArt.secondaryColor];
////    [_controlPanel.nextButton setTintColor:_colorArt.secondaryColor];
////    [_controlPanel.previousButton setTintColor:_colorArt.secondaryColor];
////    [_controlPanel.shuffleButton setTintColor:[_colorArt.secondaryColor colorWithAlphaComponent:[PRSoundManager sharedManager].shuffle ? 1.0 : 0.5]];
//    
//    [UIView transitionWithView:self.view duration:1.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
//        [_cover.activityIndicator stopAnimating];
//        [_artistLabel setTextColor:_colorArt.primaryColor];
//        [_titleLabel setTextColor:_colorArt.secondaryColor];
//        [_closeButton setTitleColor:_colorArt.detailColor forState:UIControlStateNormal];
//        [_closeButton setTitleColor:[_colorArt.detailColor colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
//        [_closeButton setTitleColor:[_colorArt.detailColor colorWithAlphaComponent:0.5] forState:UIControlStateSelected];
//        _slider.minimumTrackTintColor = _colorArt.detailColor;
//        [_cover setImage:image];
//        [_blurCover setImage:bluredImage];
//    } completion:nil];
//}
//
//#pragma mark ControlPanel Delegate
//- (void)play {
//    if ([[PRSoundManager sharedManager].player playbackState] == MPMoviePlaybackStatePaused || [[PRSoundManager sharedManager].player playbackState] == MPMoviePlaybackStateStopped) {
//        [[PRSoundManager sharedManager] play];
//    }
//}
//
//- (void)pause {
//    if ([[PRSoundManager sharedManager].player playbackState] == MPMoviePlaybackStatePlaying) {
//        [[PRSoundManager sharedManager] pause];
//    }
//}
//
//- (void)nextTrack {
//    [[PRSoundManager sharedManager] nextTrack];
//}
//
//- (void)previousTrack {
//    [[PRSoundManager sharedManager] previousTrack];
//}
//
//- (void)shuffle {
//    [PRSoundManager sharedManager].shuffle = ![PRSoundManager sharedManager].shuffle;
////    [_controlPanel.shuffleButton setTintColor:[_colorArt.secondaryColor colorWithAlphaComponent:[PRSoundManager sharedManager].shuffle ? 1.0 : 0.5]];
//}
//
//- (void)changePlaybackState {
//    [self.controlPanel changePlaybackState];
//}
//
//#pragma mark SoundManagerDelegate
//- (void)newAudio:(AudioObject *)audio {
//    [_artistLabel setText:audio.artist];
//    [_artistLabel sizeToFit];
//    [_artistLabel setFrame:CGRectMake(10, CGRectGetMinY(_cover.frame) - 10 - _artistLabel.frame.size.height, screenWidth - 20, _artistLabel.frame.size.height)];
//    
//    [_titleLabel setText:audio.title];
//    [_titleLabel sizeToFit];
//    [_titleLabel setFrame:CGRectMake(10, CGRectGetMinY(_artistLabel.frame) - 10 - _titleLabel.frame.size.height, screenWidth - 20, _titleLabel.frame.size.height)];
    
//    [self.controlPanel newAudio:audio];
    
//}
//
//- (void)coverWasFound:(NSString *)url {
//    [UIView transitionWithView:self.view duration:1.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
//        [_blurCover setImage:nil];
//        [_cover setImage:nil];
//    } completion:nil];
//    [_cover.activityIndicator startAnimating];
//    [_imgToLoad setImageWithURL:url];
//}
//
//#pragma mark Others
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

@end
