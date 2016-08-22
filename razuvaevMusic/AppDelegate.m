//
//  AppDelegate.m
//  razuvaevMusic
//
//  Created by Pavel Razuvaev on 15.11.15.
//  Copyright © 2015 Pavel Razuvaev. All rights reserved.
//

#import "AppDelegate.h"
#import "AuthViewController.h"
#import "MyMusicViewController.h"
#import "CachedMusicViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSError* error;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    [VKSdk initializeWithAppId:VKAPP_ID];
    
    _window = [[UIWindow alloc] initWithFrame:screenBounds];
    [_window setBackgroundColor:[UIColor blackColor]];
    [self setInitialController];
    [_window makeKeyAndVisible];
    
    if (![TokenManager isAuthorised]) {
        [self setAuth];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSError *activationError = nil;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:&activationError];
    [audioSession setActive:YES error:&activationError];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

#pragma mark - RemoteControlDelegate
-(void)remoteControlReceivedWithEvent:(UIEvent *)event {
    
    if ([PlayerViewController currentPlayer]) {
        
        if (event.type == UIEventTypeRemoteControl){
            switch (event.subtype) {
                case UIEventSubtypeRemoteControlPause:
                {
                    [[PlayerViewController currentPlayer] pause];
                    break;
                }
                case UIEventSubtypeRemoteControlPlay:
                {
                    [[PlayerViewController currentPlayer]  play];
                    break;
                }
                case UIEventSubtypeRemoteControlNextTrack:
                {
                    [[PlayerViewController currentPlayer]  nextTrack];
                    break;
                }
                case UIEventSubtypeRemoteControlPreviousTrack:
                {
                    [[PlayerViewController currentPlayer]  previousTrack];
                    break;
                }
                default:
                    break;
            }
        }
        
    }
}

#pragma mark - VK delegate

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    [VKSdk processOpenURL:url fromApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [VKSdk processOpenURL:url fromApplication:sourceApplication];
    return YES;
}

#pragma mark - Navigation

- (void)setAuth {
    AuthViewController *auth = [[AuthViewController alloc] init];
    [_window.rootViewController presentViewController:auth animated:NO completion:nil];
}

- (void)setInitialController {
    TabBarController *tabBarController = [[TabBarController alloc]init];
    MyMusicViewController *musicViewController = [[MyMusicViewController alloc] init];
    CachedMusicViewController *cachedMusicViewController = [[CachedMusicViewController alloc] init];
    
    UINavigationController *musicNavigationController = [[UINavigationController alloc] initWithRootViewController:musicViewController];
    UINavigationController *cachedMusicNavigationController = [[UINavigationController alloc] initWithRootViewController:cachedMusicViewController];
    [tabBarController setViewControllers:@[musicNavigationController,cachedMusicNavigationController]];
    
    _window.rootViewController = tabBarController;
}

+ (TabBarController*)mainTabBarController {
    return (TabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
}

@end
