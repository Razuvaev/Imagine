//
//  AuthViewController.m
//  razuvaevMusic
//
//  Created by Pavel Razuvaev on 15.11.15.
//  Copyright © 2015 Pavel Razuvaev. All rights reserved.
//

#import "AuthViewController.h"
#import "MyMusicViewController.h"

@interface AuthViewController ()

@property (nonatomic, strong) UIButton *authButton;

@end

@implementation AuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    self.title = @"Авторизация";
    
    [self setupUI];
}

#pragma mark setupUI
- (void)setupUI {
    [self.view addSubview:self.authButton];
}

- (UIButton *)authButton {
    if (!_authButton) {
        _authButton = [[UIButton alloc] initWithFrame:CGRectMake(20, (screenHeight - statusBarHeight - navigationBarHeight)/2 - 22, screenWidth - 40, 44)];
        [_authButton setTitle:@"Авторизоваться" forState:UIControlStateNormal];
        [_authButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_authButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateHighlighted];
        [_authButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateSelected];
        [_authButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_authButton addTarget:self action:@selector(authAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _authButton;
}

#pragma mark Actions
- (void)authAction {
    VKSdk *vkSdk = [VKSdk initializeWithAppId:VKAPP_ID];
    [vkSdk registerDelegate:self];
    
    NSArray *scope = [NSArray arrayWithObjects:@"friends", @"audio", nil];
    [VKSdk authorize:scope];
}

- (void)vkSdkAccessAuthorizationFinishedWithResult:(VKAuthorizationResult *)result {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:result.token.accessToken forKey:@"accessToken"];
    
    UserObject *user = [[UserObject alloc] init];
    [user updateWithUser:result.user];
    [[MainStorage sharedMainStorage] createNewUser:user];
    
    MyMusicViewController *music = [[MyMusicViewController alloc] init];
    [self.navigationController pushViewController:music animated:YES];
}

- (void)vkSdkUserAuthorizationFailed {
    NSLog(@"Error");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
