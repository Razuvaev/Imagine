//
//  TabBarController.m
//  razuvaevMusic
//
//  Created by Vladimir Vishnyagov on 16.08.16.
//  Copyright © 2016 Pavel Razuvaev. All rights reserved.
//

#import "TabBarController.h"

const CGFloat panelHeight = 35.f;

@interface TabBarController () <PRSoundManagerDelegate>

@property UIPanGestureRecognizer *panGestureRecognizer;
@property PlayerViewController *playerController;
@property PlayerState playerState;

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Layout

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

#pragma mark - player position

- (PlayerViewController*)createPlayerWithMusicArray:(NSMutableArray*)musicArray WithIndex:(NSInteger)index {
    _playerState = PlayerStatePanel;
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
    
    [PRSoundManager sharedManager].delegate = self;
    _playerController = [[PlayerViewController alloc] init];
    [_playerController.view addGestureRecognizer:_panGestureRecognizer];
    _playerController.musicArray = musicArray;
    _playerController.currentMusicIndex = index;
    
    _playerController.view.frame = (CGRect) {
        .origin.x = 0.f,
        .origin.y = self.view.frame.size.height,
        .size.width = self.view.frame.size.width,
        .size.height = self.view.frame.size.height + panelHeight
    };
    
    [self addChildViewController:_playerController];
    [self.view insertSubview:_playerController.view belowSubview:self.tabBar];
    
    [UIView animateWithDuration:0.25 animations:^{
        _playerController.view.frame = (CGRect) {
            .origin.x = 0.f,
            .origin.y = self.view.frame.size.height - self.tabBar.frame.size.height - panelHeight,
            .size.width = self.view.frame.size.width,
            .size.height = self.view.frame.size.height + panelHeight
        };
    }];
    return _playerController;
}

#pragma mark - gesture recognizer for player

CGFloat startPosition = 0.f;

-(void)handleGesture:(UIPanGestureRecognizer*)panRecognizer {
    switch (panRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            startPosition = [[panRecognizer view] center].y;
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGPoint translatedPoint = [panRecognizer translationInView:self.view];
            translatedPoint = CGPointMake(self.view.center.x, startPosition + (int)translatedPoint.y);
            switch (_playerState) {
                case PlayerStatePanel: {
                    if (startPosition - translatedPoint.y > 0) {
                        [[panRecognizer view] setCenter:translatedPoint];
                    }
                    else {
                        translatedPoint = CGPointMake(self.view.center.x, startPosition);
                        [[panRecognizer view] setCenter:translatedPoint];
                    }
                    break;
                }
                case PlayerStateFullScreen: {
                    if (translatedPoint.y <= startPosition) {
                        translatedPoint = CGPointMake(self.view.center.x, startPosition);
                        [[panRecognizer view] setCenter:translatedPoint];
                    }
                    else {
                        [[panRecognizer view] setCenter:translatedPoint];
                    }
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case UIGestureRecognizerStateEnded: {
            CGFloat pointPlayerViewTop = _playerController.view.frame.origin.y;
            if (pointPlayerViewTop < self.view.center.y - self.tabBar.frame.size.height) {
                CGRect newFrame = _playerController.view.frame;
                newFrame.origin.y = -panelHeight;
                [UIView animateWithDuration:0.45f animations:^{
                    _playerController.view.frame = newFrame;
                    _playerState = PlayerStateFullScreen;
                }];
            }
            else
            {
                CGRect newFrame = _playerController.view.frame;
                newFrame.origin.y = self.view.frame.size.height - self.tabBar.frame.size.height - panelHeight;
                [UIView animateWithDuration:0.45f animations:^{
                    _playerController.view.frame = newFrame;
                    _playerState = PlayerStatePanel;
                }];
            }
            break;
        }
        default: {
            startPosition = [[panRecognizer view] center].y;
            break;
        }
    }
}

#pragma mark - class methods

+ (UIViewController*)viewControllerForIndex:(NSInteger)index {
    NSArray *controllers = [TabBarController tabBarController].viewControllers;
    if (index < controllers.count) {
        UINavigationController *navigationController = controllers[index];
        return navigationController.topViewController;
    }
    return nil;
}

+ (TabBarController*)tabBarController {
    return (TabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
}

@end
