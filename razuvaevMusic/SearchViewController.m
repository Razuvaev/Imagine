//
//  SearchViewController.m
//  razuvaevMusic
//
//  Created by Pavel Razuvaev on 28.11.15.
//  Copyright © 2015 Pavel Razuvaev. All rights reserved.
//

#import "SearchViewController.h"
#import "MusicTableViewCell.h"
#import "PlayerViewController.h"

@interface SearchViewController ()

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *musicArray;

@property (nonatomic, strong) UIActivityIndicatorView *ai;

@property (nonatomic) BOOL loadMoreAudio;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self.view setBackgroundColor:[UIColor blackColor]];
    _musicArray = [NSMutableArray new];
    // Do any additional setup after loading the view.
    [self subscribeToNotifications];
    [self setupUI];
}

- (void)setupUI {
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.ai];
    [_searchBar becomeFirstResponder];
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(60, 20, screenWidth-60, 40)];
        [_searchBar setDelegate:self];
        [_searchBar setBackgroundColor:[UIColor blackColor]];
        [_searchBar setTintColor:[UIColor blackColor]];
        [_searchBar setBarTintColor:[UIColor blackColor]];
    }
    return _searchBar;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_searchBar.frame), screenWidth, screenHeight - statusBarHeight - CGRectGetHeight(_searchBar.frame)) style:UITableViewStylePlain];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView registerClass:[MusicTableViewCell class] forCellReuseIdentifier:@"cell"];
        [_tableView setSeparatorColor:[UIColor colorWithWhite:1.0 alpha:0.7]];
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, screenWidth, 0, screenWidth)];
        [_tableView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    }
    return _tableView;
}

- (UIActivityIndicatorView *)ai {
    if (!_ai) {
        _ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_ai setCenter:CGPointMake(screenWidth/2, screenHeight/2)];
    }
    return _ai;
}

#pragma mark TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _musicArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 63.5;
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PlayerViewController *player = [[PlayerViewController alloc] init];
    player.currentMusicIndex = indexPath.row;
    player.musicArray = _musicArray;
    [self.navigationController presentViewController:player animated:YES completion:^{
        
    }];
}

#pragma mark Search
- (void)searchWithText:(NSString *)text {
    NSDictionary *dict = @{VK_API_ACCESS_TOKEN : [[MainStorage sharedMainStorage] returnAccessToken], VK_API_OWNER_ID : [MainStorage sharedMainStorage].currentUser.userId, @"count" : [NSNumber numberWithInt:100], @"offset" : [NSNumber numberWithInt:_musicArray.count], @"search_own" : [NSNumber numberWithBool:YES], @"auto_complete" : [NSNumber numberWithBool:YES], @"q" : text};
    VKRequest *audioRequest = [VKRequest requestWithMethod:@"audio.search" andParameters:dict];
    [audioRequest executeWithResultBlock:^(VKResponse *response) {
        if ([response.json isKindOfClass:[NSDictionary class]]) {
            NSArray *items = [response.json valueForKey:@"items"];
            if (items.count > 0) {
                for(NSDictionary *dict in items) {
                    AudioObject *audio = [[AudioObject alloc] init];
                    [audio updateWithDictionary:dict];
                    [_musicArray addObject:audio];
                }
                [_tableView reloadData];
                _loadMoreAudio = NO;
            }else {
                _loadMoreAudio = YES;
            }
            [_ai stopAnimating];
            
        }
    } errorBlock:^(NSError *error) {
        
    }];
}

#pragma mark SearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [_musicArray removeAllObjects];
    [_ai startAnimating];
    [self searchWithText:searchBar.text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [_musicArray removeAllObjects];
    [_tableView reloadData];
}

#pragma mark Notifications
- (void)subscribeToNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    [self configureWithKeyboardNotification:notification];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if (![self.navigationController.viewControllers containsObject:self]) {
        return;
    }
    [self configureWithKeyboardNotification:notification];
}

- (void)configureWithKeyboardNotification:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    
    CGRect keyboardEndFrame;
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    [UIView animateKeyframesWithDuration:0.25 delay:0.0 options:458752 animations:^{
        if (notification.name == UIKeyboardWillHideNotification) {
            [_tableView setFrame:CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, screenHeight - statusBarHeight - 40)];
        }else {
            [_tableView setFrame:CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, [UIScreen mainScreen].bounds.size.height - keyboardEndFrame.size.height - statusBarHeight - 40)];
        }
    } completion:nil];
}

#pragma mark ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!_loadMoreAudio && scrollView.contentOffset.y > scrollView.contentSize.height - _tableView.bounds.size.height) {
        _loadMoreAudio = YES;
        if (_musicArray.count >= 100) {
            [_ai startAnimating];
            //            [scrollView setContentSize:CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height + _ai.frame.size.height*3)];
            [self searchWithText:_searchBar.text];
        }
    }
}

#pragma mark Others
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
