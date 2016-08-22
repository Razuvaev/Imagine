//
//  MusicTableViewCell.m
//  razuvaevMusic
//
//  Created by Pavel Razuvaev on 15.11.15.
//  Copyright © 2015 Pavel Razuvaev. All rights reserved.
//

#import "MusicTableViewCell.h"
#import "AudioObject.h"
#import "LLACircularProgressView.h"
#import "DownloadManager.h"
#import "UIButton+AppStore.h"

@interface MusicTableViewCell () <AudioDownloadDelegate>

@property (nonatomic, strong) UILabel *artist;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIButton *cacheMusic;
@property (nonatomic, strong) LLACircularProgressView *progressView;

@end

@implementation MusicTableViewCell

- (void)prepareForReuse {
    _progressView.hidden = YES;
    _cacheMusic.hidden = YES;
    [_cacheMusic.allTargets.allObjects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [_cacheMusic removeTarget:obj action:@selector(downloadAudioFile) forControlEvents:UIControlEventTouchUpInside];
    }];
    [_progressView.allTargets.allObjects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [_cacheMusic removeTarget:obj action:@selector(cancelDownload) forControlEvents:UIControlEventTouchUpInside];
    }];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.artist];
        [self.contentView addSubview:self.progressView];
        [self.contentView addSubview:self.cacheMusic];
    }
    return self;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        [_title setTextColor:[UIColor blackColor]];
        [_title setFont:[UIFont systemFontOfSize:18]];
    }
    return _title;
}

- (UILabel *)artist {
    if (!_artist) {
        _artist = [[UILabel alloc] init];
        [_artist setTextColor:[UIColor grayColor]];
        [_artist setFont:[UIFont systemFontOfSize:14]];
    }
    return _artist;
}

#pragma mark - Download components

- (UIButton *)cacheMusic {
    if (!_cacheMusic) {
        _cacheMusic = [UIButton ASButtonWithFrame:CGRectMake(screenWidth - 85, 63.5f/2.f-12.5f,70, 25) title:@"ЗАГРУЗИТЬ"];
        _cacheMusic.titleLabel.font = [UIFont systemFontOfSize:10.f];
        _cacheMusic.hidden = YES;
    }
    return _cacheMusic;
}

- (LLACircularProgressView*)progressView {
    if (!_progressView) {
        _progressView = [[LLACircularProgressView alloc]initWithFrame:CGRectMake(screenWidth-55,63.5f/2.f-22,44,44)];
        _progressView.progress = 0.0f;
        _progressView.tintColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
        _progressView.hidden = YES;
    }
    return _progressView;
}

#pragma mark - Setter

- (void)setupCellWithAudio:(AudioObject *)audio {
    [self setTitleLabel:audio.title];
    [self setArtistLabel:audio.artist];
    audio.delegate = self;
    
    switch ([audio downloadStatus]) {
        case AudioFilePlain: {
            _progressView.progress = 0.0;
            _progressView.hidden = YES;
            _cacheMusic.hidden = NO;
            [_cacheMusic addTarget:audio action:@selector(downloadAudioFile) forControlEvents:UIControlEventTouchUpInside];
            break;
        }
        case AudioFileDownloading: {
            _progressView.progress = audio.progress.fractionCompleted;
            _progressView.hidden = NO;
            _cacheMusic.hidden = YES;
            [_progressView addTarget:audio action:@selector(cancelDownload) forControlEvents:UIControlEventTouchUpInside];
            break;
        }
        case AudioFileCached: {
            break;
        }
    }
}

- (void)changeStateDownloading:(AudioObject*)audio {
    [self setupCellWithAudio:audio];
}

- (void)changeFraction:(double)fraction {
    _progressView.progress = fraction;
}

- (void)setupCellWithAudioManagedObject:(AudioManagedObject *)audio {
    [self setTitleLabel:audio.title];
    [self setArtistLabel:audio.artist];
}

- (void)setTitleLabel:(NSString *)title {
    [_title setText:title];
    [_title sizeToFit];
    [_title setFrame:CGRectMake(10, 10, screenWidth - 100, _title.frame.size.height)];
}

- (void)setArtistLabel:(NSString *)artist {
    [_artist setText:artist];
    [_artist sizeToFit];
    [_artist setFrame:CGRectMake(10, CGRectGetMaxY(_title.frame) + 5, screenWidth - 100, _artist.frame.size.height)];
}

#pragma mark Height

+ (CGFloat)cellHeightForMusicCell:(AudioObject *)audio {
    MusicTableViewCell *cell = [[MusicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    [cell setupCellWithAudio:audio];
    CGFloat height;
    UIView *view = [[cell.contentView subviews] lastObject];
    height += CGRectGetMaxY(view.frame);
    return height + 10;
}

@end
