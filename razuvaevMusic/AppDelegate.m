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
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_window setBackgroundColor:[UIColor blackColor]];
    
    UINavigationController *navController;

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"accessToken"] == nil) {
        AuthViewController *auth = [[AuthViewController alloc] init];
        navController = [[UINavigationController alloc] initWithRootViewController:auth];
    }else {
        MyMusicViewController *music = [[MyMusicViewController alloc] init];
        navController = [[UINavigationController alloc] initWithRootViewController:music];
    }
    
    _window.rootViewController = navController;
    [_window makeKeyAndVisible];
    
    [VKSdk initializeWithAppId:VKAPP_ID];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {    
    NSError *activationError = nil;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:&activationError];
    [audioSession setActive:YES error:&activationError];
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)remoteControlReceivedWithEvent:(UIEvent *)event{
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

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    [VKSdk processOpenURL:url fromApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [VKSdk processOpenURL:url fromApplication:sourceApplication];
    return YES;
}

@end
