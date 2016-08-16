//
//  MyMusicHeader.h
//  razuvaevMusic
//
//  Created by Pavel Razuvaev on 15.11.15.
//  Copyright © 2015 Pavel Razuvaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyMusicHeader : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIButton *searchButton;

- (void)setSoundNumber:(NSNumber *)count;
- (void)reloadData;

@end
