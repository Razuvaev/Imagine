//
//  TabBarController.m
//  razuvaevMusic
//
//  Created by Vladimir Vishnyagov on 16.08.16.
//  Copyright © 2016 Pavel Razuvaev. All rights reserved.
//

#import "TabBarController.h"

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - class methods

- (UIViewController*)viewControllerForIndex:(NSInteger)index {
    NSArray *controllers = self.viewControllers;
    if (index < controllers.count) {
        UINavigationController *navigationController = controllers[index];
        return navigationController.topViewController;
    }
    return nil;
}

@end
