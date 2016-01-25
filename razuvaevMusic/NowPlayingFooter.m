//
//  NowPlayingFooter.m
//  razuvaevMusic
//
//  Created by Pavel Razuvaev on 19.11.15.
//  Copyright © 2015 Pavel Razuvaev. All rights reserved.
//

#import "NowPlayingFooter.h"
@interface NowPlayingFooter ()

@property (nonatomic, strong) UIImageView *nowPlayingImage;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *artist;

@end

@implementation NowPlayingFooter

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor blackColor]];
        [self setupUI];
    }
    return self;
}

#pragma mark setupUI
- (void)setupUI {
    [self addSubview:self.nowPlayingImage];
    [self addSubview:self.title];
    [self addSubview:self.artist];
}

- (UIImageView *)nowPlayingImage {
    if (!_nowPlayingImage) {
        _nowPlayingImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 46, 60)];
        [_nowPlayingImage setImage:[UIImage imageNamed:@"nowListening"]];
    }
    return _nowPlayingImage;
}

@end
