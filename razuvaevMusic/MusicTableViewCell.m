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

static void *ProgressObserverContext = &ProgressObserverContext;

@interface MusicTableViewCell ()

@property (nonatomic, strong) UILabel *artist;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) AudioObject *audioObject;
@property (nonatomic, strong) UIButton *cacheMusic;
@property (nonatomic, strong) LLACircularProgressView *progressView;

@property (strong, nonatomic) NSProgress *progress;

@end

@implementation MusicTableViewCell
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

- (UIButton *)cacheMusic {
    if (!_cacheMusic) {
        _cacheMusic = [UIButton ASButtonWithFrame:CGRectMake(self.frame.size.width - 25, 63.5f/2.f-12.5f,70, 25) title:@"ЗАГРУЗИТЬ"];
        _cacheMusic.titleLabel.font = [UIFont systemFontOfSize:10.f];
        [_cacheMusic addTarget:self action:@selector(download) forControlEvents:UIControlEventTouchUpInside];
        _cacheMusic.hidden = YES;
    }
    return _cacheMusic;
}

#pragma mark setters
- (void)setupCellWithAudio:(AudioObject *)audio {
    _audioObject = audio;
    [self setTitleLabel:audio.title];
    [self setArtistLabel:audio.artist];
    
    if (![[MainStorage sharedMainStorage] checkAudioCached:audio.title artist:audio.artist]) {
        _cacheMusic.hidden = NO;
    }
    else {
        _cacheMusic.hidden = YES;
    }
}

- (void)setupCellWithAudioManagedObject:(AudioManagedObject *)audio {
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

#pragma mark download components

- (LLACircularProgressView*)progressView {
    if (!_progressView) {
        _progressView = [[LLACircularProgressView alloc]initWithFrame:CGRectMake(self.frame.size.width-10,63.5f/2.f-22,44,44)];
        _progressView.progress = 0.0f;
        _progressView.tintColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
        _progressView.hidden = YES;
    }
    return _progressView;
}

- (void)download {
    _cacheMusic.hidden = YES;
    _progressView.hidden = NO;
    self.progress = [NSProgress progressWithTotalUnitCount:1];
    
    [self.progress addObserver:self
                    forKeyPath:NSStringFromSelector(@selector(fractionCompleted))
                       options:NSKeyValueObservingOptionInitial
                       context:ProgressObserverContext];
    
    [self.progress becomeCurrentWithPendingUnitCount:1];
    [[DownloadManager sharedInstance] downloadAudioWithAudioObject:_audioObject WithProgress:self.progress];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context
{
    if (context == ProgressObserverContext)
    {
        NSProgress *progress = object;
        _progressView.progress = progress.fractionCompleted;
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object
                               change:change context:context];
    }
}


@end
