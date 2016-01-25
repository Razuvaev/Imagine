//
//  MusicTableViewCell.m
//  razuvaevMusic
//
//  Created by Pavel Razuvaev on 15.11.15.
//  Copyright © 2015 Pavel Razuvaev. All rights reserved.
//

#import "MusicTableViewCell.h"
#import "AudioObject.h"

@interface MusicTableViewCell ()

@property (nonatomic, strong) UILabel *artist;
@property (nonatomic, strong) UILabel *title;

@end

@implementation MusicTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor blackColor]];
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.artist];
    }
    return self;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        [_title setTextColor:[UIColor whiteColor]];
        [_title setFont:[UIFont systemFontOfSize:18]];
    }
    return _title;
}

- (UILabel *)artist {
    if (!_artist) {
        _artist = [[UILabel alloc] init];
        [_artist setTextColor:[UIColor colorWithWhite:1.0 alpha:0.7]];
        [_artist setFont:[UIFont systemFontOfSize:14]];
    }
    return _artist;
}

#pragma mark setters
- (void)setupCellWithAudio:(AudioObject *)audio {
    [self setTitleLabel:audio.title];
    [self setArtistLabel:audio.artist];
}

- (void)setTitleLabel:(NSString *)title {
    [_title setText:title];
    [_title sizeToFit];
    [_title setFrame:CGRectMake(10, 10, screenWidth - 20, _title.frame.size.height)];
}

- (void)setArtistLabel:(NSString *)artist {
    [_artist setText:artist];
    [_artist sizeToFit];
    [_artist setFrame:CGRectMake(10, CGRectGetMaxY(_title.frame) + 5, screenWidth - 20, _artist.frame.size.height)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark Helpers
+ (CGFloat)cellHeightForMusicCell:(AudioObject *)audio {
    MusicTableViewCell *cell = [[MusicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    [cell setupCellWithAudio:audio];
    
    CGFloat height;
    
    UIView *view = [[cell.contentView subviews] lastObject];
    height += CGRectGetMaxY(view.frame);

    
    return height + 10;
}

@end
