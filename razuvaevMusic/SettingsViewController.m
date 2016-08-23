//
//  SettingsViewController.m
//  razuvaevMusic
//
//  Created by Vladimir Vishnyagov on 23.08.16.
//  Copyright © 2016 Pavel Razuvaev. All rights reserved.
//

#import "SettingsViewController.h"
#import "AutodownloadCell.h"
#import "TabBarController.h"
#import "MyMusicViewController.h"

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Настройки";
    self.tableView = [[UITableView alloc]initWithFrame:self.tableView.frame style:UITableViewStyleGrouped];
    [self.tableView registerClass:[AutodownloadCell class] forCellReuseIdentifier:@"autodownloadcell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        AutodownloadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"autodownloadcell"];
        cell.selectionStyle = UITableViewCellEditingStyleNone;
        return cell;
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.selectionStyle = UITableViewStylePlain;
        cell.textLabel.text = @"Очистить все загрузки";
        cell.textLabel.textColor = [UIColor redColor];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        PSTAlertController *alert = [PSTAlertController alertControllerWithTitle:@"Imagine" message:@"Вы уверены?" preferredStyle:PSTAlertControllerStyleAlert];
        [alert addAction:[PSTAlertAction actionWithTitle:@"Да" style:PSTAlertActionStyleDefault handler:^(PSTAlertAction * _Nonnull action) {
            [self removeAllMp3Files];
            [[MainStorage sharedMainStorage] clearAudioBase];
        
#warning rewrite this place
            
            MyMusicViewController *myMusicVc = (MyMusicViewController *)[TabBarController viewControllerForIndex:0];
            [myMusicVc.tableView reloadData];
            
        }]];
        [alert addAction:[PSTAlertAction actionWithTitle:@"Нет" style:PSTAlertActionStyleDestructive handler:^(PSTAlertAction * _Nonnull action) {
        }]];
        [alert showWithSender:nil controller:[UIApplication sharedApplication].keyWindow.rootViewController animated:YES completion:^{}];
    }
}

- (void)removeAllMp3Files
{
    NSFileManager  *manager = [NSFileManager defaultManager];
    
    // the preferred way to get the apps documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    // grab all the files in the documents dir
    NSArray *allFiles = [manager contentsOfDirectoryAtPath:documentsDirectory error:nil];
    
    // filter the array for only sqlite files
    NSPredicate *fltr = [NSPredicate predicateWithFormat:@"self ENDSWITH '.mp3'"];
    NSArray *sqliteFiles = [allFiles filteredArrayUsingPredicate:fltr];
    
    // use fast enumeration to iterate the array and delete the files
    for (NSString *sqliteFile in sqliteFiles)
    {
        NSError *error = nil;
        [manager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:sqliteFile] error:&error];
        NSAssert(!error, @"Assertion: MP3 file deletion shall never throw an error.");
    }
}

@end
