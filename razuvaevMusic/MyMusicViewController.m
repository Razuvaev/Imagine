//
//  MyMusicViewController.m
//  razuvaevMusic
//
//  Created by Pavel Razuvaev on 15.11.15.
//  Copyright © 2015 Pavel Razuvaev. All rights reserved.
//

#import "MyMusicViewController.h"
#import "SearchViewController.h"

#import "MyMusicHeader.h"
#import "MusicTableViewCell.h"
#import "NowPlayingFooter.h"

#import "AudioObject.h"

#import "PlayerViewController.h"

#import <MediaPlayer/MediaPlayer.h>

static CGFloat const headerHeight = 60.f;
static CGFloat const rowHeight = 63.5f;

@interface MyMusicViewController ()

@property (nonatomic, strong) MyMusicHeader *header;
@property (nonatomic, strong) NowPlayingFooter *footer;
@property (nonatomic, strong) UIActivityIndicatorView *ai;
@property (nonatomic, strong) NSMutableArray *musicArray;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic) BOOL loadMoreAudio;

@end

@implementation MyMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.ai];
    [self.view addSubview:self.tableView];
    
    _musicArray = [NSMutableArray new];
    _imageArray = [NSMutableArray new];
    
    if ([TokenManager isAuthorised]) {
        [self loadData];
    }
}

#pragma mark loadData
- (void)loadData {
    NSDictionary *dict = @{VK_API_ACCESS_TOKEN : [TokenManager fetchToken], VK_API_OWNER_ID : [MainStorage sharedMainStorage].currentUser.userId, @"count" : [NSNumber numberWithInt:100], @"offset" : [NSNumber numberWithInteger:_musicArray.count]};
    VKRequest *audioRequest = [VKRequest requestWithMethod:@"audio.get" andParameters:dict];
    [audioRequest executeWithResultBlock:^(VKResponse *response) {
        if ([response.json isKindOfClass:[NSDictionary class]]) {
            NSNumber *number = [response.json valueForKey:@"count"];
            [_header setSoundNumber:number];
            
            NSArray *items = [response.json valueForKey:@"items"];
            if (items.count > 0) {
                for(NSDictionary *dict in items) {
                    AudioObject *audio = [[AudioObject alloc] init];
                    [audio updateWithDictionary:dict];
                    [_musicArray addObject:audio];
                }
                [_tableView reloadData];
                [_header reloadData];
                _loadMoreAudio = NO;
            }else {
                _loadMoreAudio = YES;
            }
            [_ai stopAnimating];
            
        }
    } errorBlock:^(NSError *error) {
        
    }];
}

#pragma mark setupUI

- (UITabBarItem*)tabBarItem {
    UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:@"My Music" image:[UIImage new] tag:0];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    return item;
}

- (UIActivityIndicatorView *)ai {
    if (!_ai) {
        _ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_ai setCenter:CGPointMake(screenWidth/2, screenHeight/2)];
        [_ai startAnimating];
    }
    return _ai;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, statusBarHeight, screenWidth, screenHeight - statusBarHeight) style:UITableViewStylePlain];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView registerClass:[MusicTableViewCell class] forCellReuseIdentifier:@"cell"];
        [_tableView setSeparatorColor:[UIColor grayColor]];
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, screenWidth, 0, screenWidth)];
    }
    return _tableView;
}

- (MyMusicHeader *)header {
    if (!_header) {
        _header = [[MyMusicHeader alloc] initWithFrame:CGRectMake(0, 0, screenWidth, headerHeight)];
        [_header.searchButton addTarget:self action:@selector(searchButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _header;
}

- (NowPlayingFooter *)footer {
    if (!_footer) {
        _footer = [[NowPlayingFooter alloc] initWithFrame:CGRectMake(0, 0, screenWidth, headerHeight)];
    }
    return _footer;
}

#pragma mark TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _musicArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return headerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    return self.footer;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[MusicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    [cell setupCellWithAudio:[_musicArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[TabBarController tabBarController] playerWithMusicArray:_musicArray WithCurrentPlayingIndex:indexPath.row];
}

#pragma mark ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!_loadMoreAudio && scrollView.contentOffset.y > scrollView.contentSize.height - _tableView.bounds.size.height) {
        _loadMoreAudio = YES;
        if (_musicArray.count >= 20) {
            [_ai startAnimating];
            [self loadData];
        }
    }
}

#pragma mark Actions
- (void)searchButtonAction {
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark - Layout 
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
