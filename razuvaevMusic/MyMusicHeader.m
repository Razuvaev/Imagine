//
//  MyMusicHeader.m
//  razuvaevMusic
//
//  Created by Pavel Razuvaev on 15.11.15.
//  Copyright © 2015 Pavel Razuvaev. All rights reserved.
//

#import "MyMusicHeader.h"
#import "WebImageView.h"

@interface MyMusicHeader ()

@property (nonatomic, strong) WebImageView *avatar;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *numberOfSounds;
@property (nonatomic, strong) UIView *separator;

@end

@implementation MyMusicHeader

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:0.95]];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.avatar];
    [self addSubview:self.name];
    [self addSubview:self.numberOfSounds];
    [self addSubview:self.separator];
    [self addSubview:self.searchButton];
}

- (WebImageView *)avatar {
    if (!_avatar) {
        _avatar = [[WebImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        [_avatar setUserInteractionEnabled:YES];
        [_avatar setContentMode:UIViewContentModeScaleAspectFill];
        [_avatar setClipsToBounds:YES];
        [_avatar.layer setCornerRadius:_avatar.frame.size.width/2];
        [_avatar setImageWithURL:[MainStorage sharedMainStorage].currentUser.avatarMediumUrl];
    }
    return _avatar;
}

- (UILabel *)name {
    if (!_name) {
        _name = [[UILabel alloc] init];
        [_name setFont:[UIFont systemFontOfSize:18]];
        [_name setTextColor:[UIColor blackColor]];
        [_name setText:[MainStorage sharedMainStorage].currentUser.fullName];
        [_name setTextAlignment:NSTextAlignmentLeft];
        [_name sizeToFit];
        [_name setFrame:CGRectMake(CGRectGetMaxX(_avatar.frame) + 10, 8, screenWidth - (CGRectGetMaxX(_avatar.frame) + 5) - 45, _name.frame.size.height)];
    }
    return _name;
}

- (UILabel *)numberOfSounds {
    if (!_numberOfSounds) {
        _numberOfSounds = [[UILabel alloc] init];
        [_numberOfSounds setFont:[UIFont systemFontOfSize:14]];
        [_numberOfSounds setTextColor:[UIColor grayColor]];
        [_numberOfSounds setAlpha:0.0];
    }
    return _numberOfSounds;
}

- (UIView *)separator {
    if (!_separator) {
        _separator = [[UIView alloc] initWithFrame:CGRectMake(0, 59.5, screenWidth, 0.5)];
        [_separator setBackgroundColor:[UIColor grayColor]];
    }
    return _separator;
}

- (UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth - 40, 10, 40, 40)];
        [_searchButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    }
    return _searchButton;
}

#pragma mark setters
- (void)setSoundNumber:(NSNumber *)count {
    [_numberOfSounds setText:[NSString stringWithFormat:@"%@ %@", count, [self countString:count]]];
    [_numberOfSounds sizeToFit];
    [_numberOfSounds setFrame:CGRectMake(CGRectGetMaxX(_avatar.frame) + 10, CGRectGetMaxY(_name.frame) + 5, _numberOfSounds.frame.size.width, _numberOfSounds.frame.size.height)];
    [UIView animateWithDuration:0.25 animations:^{
        [_numberOfSounds setAlpha:1.0];
    }];
}

#pragma mark Helpers
-(NSString*)countString:(NSNumber *)count {
    NSString* balls=@"Аудиозаписей";
    if (count.integerValue%10>4 || count.integerValue%10==0) {
        balls=@"Аудиозаписей";
    }else if (count.integerValue%10==1){
        balls=@"Аудиозапись";
    }else{
        balls=@"Аудиозаписи";
    }
    return balls;
}

@end
