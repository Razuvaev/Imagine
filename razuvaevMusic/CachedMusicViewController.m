//
//  CachedMusicViewController.m
//  razuvaevMusic
//
//  Created by Vladimir Vishnyagov on 16.08.16.
//  Copyright © 2016 Pavel Razuvaev. All rights reserved.
//

#import "CachedMusicViewController.h"
#import "MusicTableViewCell.h"
#import "MyMusicViewController.h"

static CGFloat const rowHeight = 63.5f;

@interface CachedMusicViewController () <UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate>

@property (nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation CachedMusicViewController

@synthesize fetchedResultsController = _fetchedResultsController;

#pragma mark setupUI

- (UITabBarItem*)tabBarItem {
    UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:@"Кэш" image:nil tag:0];
    [item setImage:[[UIImage imageNamed:@"folder"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item setSelectedImage:[[UIImage imageNamed:@"folder"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]} forState:UIControlStateSelected];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]} forState:UIControlStateFocused];
    return item;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Кэш";
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(changeEditingMode)];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.tableView];
}

- (void)changeEditingMode {
    if (![_tableView isEditing]) {
        if ([PlayerViewController currentPlayer]) {
            [[TabBarController tabBarController] kickPlayer];
        }
    }
    [_tableView setEditing:!_tableView.editing animated:YES];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, self.view.frame.size.height) style:UITableViewStyleGrouped];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView registerClass:[MusicTableViewCell class] forCellReuseIdentifier:@"cell"];
        [_tableView setSeparatorColor:[UIColor grayColor]];
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, screenWidth, 0, screenWidth)];
        _tableView.editing = NO;
    }
    return _tableView;
}

#pragma mark TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.fetchedResultsController sections].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id  sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    NSUInteger numberOfObjects = [sectionInfo numberOfObjects];
    self.navigationItem.rightBarButtonItem.enabled = numberOfObjects > 0;
    return numberOfObjects;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return rowHeight;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.tableView.editing;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        AudioManagedObject *managedObject = [_fetchedResultsController objectAtIndexPath:indexPath];
        NSError *error;
        NSString *path = [NSURL URLWithString:managedObject.home_url].absoluteURL.absoluteString;
        if (![[NSFileManager defaultManager] removeItemAtPath:path error:&error]) {
            NSLog(@"%@",error.localizedDescription);
        }
        [[MainStorage sharedMainStorage].managedObjectContext deleteObject:managedObject];
        [[MainStorage sharedMainStorage] saveContext];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath{
    
    self.fetchedResultsController.delegate = nil;
    
    NSMutableArray *objects = [[_fetchedResultsController sections][0] objects].mutableCopy;
    AudioManagedObject *fromAudioObject = [_fetchedResultsController objectAtIndexPath:fromIndexPath];
    [objects removeObjectAtIndex:fromIndexPath.row];
    [objects insertObject:fromAudioObject atIndex:toIndexPath.row];
    int i = 0;
    for (AudioManagedObject *mo in objects) {
        mo.order = @(i);
        i++;
    }
    [self performSelector:@selector(saveContextWithDelay) withObject:nil afterDelay:0.5f];
}

- (void)saveContextWithDelay {
    [[MainStorage sharedMainStorage] saveContext];
    self.fetchedResultsController.delegate = self;
    NSError *error;
    [self.fetchedResultsController performFetch:&error];
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[MusicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    [cell setupCellWithAudioManagedObject:[_fetchedResultsController objectAtIndexPath:indexPath]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[TabBarController tabBarController] playerWithMusicArray:[_fetchedResultsController fetchedObjects].copy WithCurrentPlayingIndex:indexPath.row];
}

#pragma mark FRC

#pragma mark - fetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AudioManagedObject" inManagedObjectContext:[MainStorage sharedMainStorage].managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[MainStorage sharedMainStorage].managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    NSError *error;
    [self.fetchedResultsController performFetch:&error];
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        default:
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

@end