//
//  TabBarController.m
//  razuvaevMusic
//
//  Created by Vladimir Vishnyagov on 16.08.16.
//  Copyright © 2016 Pavel Razuvaev. All rights reserved.
//

#import "TabBarController.h"

const CGFloat playerAnimationDuration = 0.35f;

@interface TabBarController ()

@property UIPanGestureRecognizer *panGestureRecognizer;
@property PlayerViewController *playerController;
@property PlayerState playerState;

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.translucent = NO;
    self.tabBar.tintColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
}

#pragma mark - Layout

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

#pragma mark - player position

- (PlayerViewController*)playerWithMusicArray:(NSMutableArray*)musicArray WithCurrentPlayingIndex:(NSInteger)index {
    
    if (!_playerController) {
        
        _playerState = PlayerStatePanel;
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
        _playerController = [[PlayerViewController alloc] init];
        [PRSoundManager sharedInstance].delegate = _playerController;
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openPlayerFromPanel)];
        [_playerController.controlPanel addGestureRecognizer:tapRecognizer];
        
        [_playerController.view addGestureRecognizer:_panGestureRecognizer];
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
        
    }
    _playerController.musicArray = musicArray;
    _playerController.currentMusicIndex = index;
    
    AudioObject *nextAudio = [musicArray objectAtIndex:index];
    [_playerController.controlPanel newAudio:nextAudio];
    [[PRSoundManager sharedInstance] nextAudio:nextAudio];
    
    return _playerController;
}

- (PlayerViewController*)currentPlayer {
    if (_playerController)
        return _playerController;
    return nil;
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
                        _playerController.controlPanel.alpha = (translatedPoint.y-self.view.center.y)/startPosition;
                    }
                    else {
                        translatedPoint = CGPointMake(self.view.center.x, startPosition);
                        [[panRecognizer view] setCenter:translatedPoint];
                        _playerController.controlPanel.alpha = 1.f;
                    }
                    break;
                }
                case PlayerStateFullScreen: {
                    if (translatedPoint.y <= startPosition) {
                        translatedPoint = CGPointMake(self.view.center.x, startPosition);
                        [[panRecognizer view] setCenter:translatedPoint];
                        _playerController.controlPanel.alpha = 0.f;
                    }
                    else {
                        [[panRecognizer view] setCenter:translatedPoint];
                        _playerController.controlPanel.alpha = (translatedPoint.y-self.view.center.y)/startPosition;
                    }
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case UIGestureRecognizerStateEnded: {
            
            CGFloat velocityY = (0.2f*[panRecognizer velocityInView:self.view].y);
            CGFloat animationDuration = (ABS(velocityY)*.0002)+.3;
            
            CGFloat pointPlayerViewTop = _playerController.view.frame.origin.y;
            CGFloat alphaControlPanel = 0.f;
            CGRect newFrame = CGRectZero;
            
            if (ABS(velocityY) < 50.f) {
                if (pointPlayerViewTop < self.view.center.y - self.tabBar.frame.size.height) {
                    newFrame = _playerController.view.frame;
                    newFrame.origin.y = -panelHeight;
                    _playerState = PlayerStateFullScreen;
                    alphaControlPanel = 0.f;
                }
                else {
                    newFrame = _playerController.view.frame;
                    newFrame.origin.y = self.view.frame.size.height - self.tabBar.frame.size.height - panelHeight;
                    _playerState = PlayerStatePanel;
                    alphaControlPanel = 1.f;
                }
                animationDuration = playerAnimationDuration;
            }
            else
            {
                if (velocityY < 0) {
                    newFrame = _playerController.view.frame;
                    newFrame.origin.y = -panelHeight;
                    _playerState = PlayerStateFullScreen;
                    alphaControlPanel = 0.f;
                }
                else {
                    newFrame = _playerController.view.frame;
                    newFrame.origin.y = self.view.frame.size.height - self.tabBar.frame.size.height - panelHeight;
                    _playerState = PlayerStatePanel;
                    alphaControlPanel = 1.f;
                }
            }
            
            [TabBarController hideShowTabBarAnimated:_playerState == PlayerStateFullScreen];
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:animationDuration];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            [UIView setAnimationDelegate:self];
            
            _playerController.view.frame = newFrame;
            _playerController.controlPanel.alpha = alphaControlPanel;
            
            [UIView commitAnimations];
            break;
        }
        default: {
            startPosition = [[panRecognizer view] center].y;
            break;
        }
    }
}

- (void)openPlayerFromPanel {
    
    CGRect newFrame = _playerController.view.frame;
    newFrame.origin.y = -panelHeight;
    
    [TabBarController hideShowTabBarAnimated:YES];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:playerAnimationDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    
    _playerController.view.frame = newFrame;
    _playerController.controlPanel.alpha = 0.f;
    
    [UIView commitAnimations];
    _playerState = PlayerStateFullScreen;
}

- (void)closePlayerFromFullScreen {
    
    CGRect newFrame = _playerController.view.frame;
    newFrame.origin.y = self.view.frame.size.height - self.tabBar.frame.size.height - panelHeight;
    
    [TabBarController hideShowTabBarAnimated:NO];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:playerAnimationDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    
    _playerController.view.frame = newFrame;
    _playerController.controlPanel.alpha = 1.f;
    
    [UIView commitAnimations];
    _playerState = PlayerStatePanel;
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

+ (void)hideShowTabBarAnimated:(BOOL)hide {
    UITabBar *tabBar = [TabBarController tabBarController].tabBar;
    if (!hide) {
        tabBar.hidden = NO;
        CGRect newFrame = tabBar.frame;
        newFrame.origin.y = [TabBarController tabBarController].view.frame.size.height - tabBar.frame.size.height;
        [UIView animateWithDuration:playerAnimationDuration animations:^{
            tabBar.frame = newFrame;
        }];
    }
    else {
        CGRect newFrame = tabBar.frame;
        newFrame.origin.y = [TabBarController tabBarController].view.frame.size.height + tabBar.frame.size.height;
        [UIView animateWithDuration:playerAnimationDuration animations:^{
            tabBar.frame = newFrame;
        } completion:^(BOOL finished) {
            tabBar.hidden = YES;
        }];
    }
}

@end
