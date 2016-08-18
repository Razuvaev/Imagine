//
//  CachedMusicViewController.m
//  razuvaevMusic
//
//  Created by Vladimir Vishnyagov on 16.08.16.
//  Copyright © 2016 Pavel Razuvaev. All rights reserved.
//

#import "CachedMusicViewController.h"

@implementation CachedMusicViewController

#pragma mark setupUI

- (UITabBarItem*)tabBarItem {
    UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:@"Cache" image:[UIImage new] tag:1];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    return item;
}

@end