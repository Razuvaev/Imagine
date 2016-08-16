//
//  AuthViewController.m
//  razuvaevMusic
//
//  Created by Pavel Razuvaev on 15.11.15.
//  Copyright © 2015 Pavel Razuvaev. All rights reserved.
//

#import "AuthViewController.h"
#import "MyMusicViewController.h"

static CGFloat const leftOffset = 20.f;
static CGFloat const buttonHeight = 40.f;

@interface AuthViewController ()

@property (nonatomic, strong) UIImageView *logoImage;
@property (nonatomic, strong) UIButton *authButton;

@end

@implementation AuthViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark setupUI
- (void)setupUI {
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.logoImage];
    [self.view addSubview:self.authButton];
}

- (UIImageView *)logoImage {
    if(!_logoImage) {
        _logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Itunes_Artwork"]];
    }
    return _logoImage;
}

- (UIButton *)authButton {
    if (!_authButton) {
        _authButton = [[UIButton alloc] init];
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

#pragma mark - VKDelegate
- (void)vkSdkAccessAuthorizationFinishedWithResult:(VKAuthorizationResult *)result {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:result.token.accessToken forKey:@"accessToken"];
    
    UserObject *user = [[UserObject alloc] init];
    [user updateWithUser:result.user];
    [[MainStorage sharedMainStorage] createNewUser:user];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate setMain];
}

- (void)vkSdkUserAuthorizationFailed {
    NSLog(@"Error");
}

#pragma mark - Layout
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    _logoImage.frame = CGRectMake(leftOffset, leftOffset, screenWidth - 2*leftOffset, screenWidth - 2*leftOffset);
    _authButton.frame = CGRectMake(leftOffset, screenHeight/2 - buttonHeight/2, screenWidth - 2*leftOffset, buttonHeight);
}

@end
