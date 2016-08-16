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

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    _window = [[UIWindow alloc] initWithFrame:screenBounds];
    [_window setBackgroundColor:[UIColor blackColor]];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"accessToken"] == nil) {
        [self setAuth];
    }else {
        [self setMain];
    }
    
    [_window makeKeyAndVisible];
    
    [VKSdk initializeWithAppId:VKAPP_ID];
    
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
    if (event.type == UIEventTypeRemoteControl){
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPause:
            {
                [[PRSoundManager sharedManager] pause];
                break;
            }
            case UIEventSubtypeRemoteControlPlay:
            {
                [[PRSoundManager sharedManager] play];
                break;
            }
            case UIEventSubtypeRemoteControlNextTrack:
            {
                [[PRSoundManager sharedManager] nextTrack];
                break;
            }
            case UIEventSubtypeRemoteControlPreviousTrack:
            {
                [[PRSoundManager sharedManager] previousTrack];
                break;
            }
            default:
                break;
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

#pragma mark - RootViewController
- (void)setAuth {
    AuthViewController *auth = [[AuthViewController alloc] init];
    _window.rootViewController = auth;
}

- (void)setMain {
    MyMusicViewController *music = [[MyMusicViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:music];
    _window.rootViewController = navController;
}

@end
