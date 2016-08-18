//
//  TabBarController.h
//  razuvaevMusic
//
//  Created by Vladimir Vishnyagov on 16.08.16.
//  Copyright © 2016 Pavel Razuvaev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerViewController.h"

@interface TabBarController : UITabBarController

#pragma mark - class methods

+ (UIViewController*)viewControllerForIndex:(NSInteger)index;
+ (TabBarController*)tabBarController;

#pragma mark - player

- (PlayerViewController*)createPlayerWithMusicArray:(NSMutableArray*)musicArray WithIndex:(NSInteger)index;

@end
