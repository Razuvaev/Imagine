//
//  MusicTableViewCell.h
//  razuvaevMusic
//
//  Created by Pavel Razuvaev on 15.11.15.
//  Copyright © 2015 Pavel Razuvaev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioObject.h"

@interface MusicTableViewCell : UITableViewCell

- (void)setupCellWithAudio:(AudioObject *)audio;

+ (CGFloat)cellHeightForMusicCell:(AudioObject *)audio;

@end
