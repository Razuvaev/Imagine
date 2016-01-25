//
//  PlayerViewController.h
//  razuvaevMusic
//
//  Created by Pavel Razuvaev on 15.11.15.
//  Copyright © 2015 Pavel Razuvaev. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AudioObject.h"
#import "ControlPanelView.h"
#import "WebImageView.h"

@interface PlayerViewController : UIViewController <PRSoundManagerDelegate, ControlPanelViewDelegate>

@property (nonatomic) NSInteger currentMusicIndex;
@property (nonatomic, strong) NSMutableArray *musicArray;

@end
