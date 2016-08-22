//
//  DownloadManager.m
//  razuvaevMusic
//
//  Created by Vladimir Vishnyagov on 22.08.16.
//  Copyright © 2016 Pavel Razuvaev. All rights reserved.
//

#import "DownloadManager.h"
#import "MyMusicViewController.h"
#import "TabBarController.h"

@interface DownloadManager ()

@end

@implementation DownloadManager

#pragma mark Inititialization

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (NSURLSessionDownloadTask*)downloadAudioWithAudioObject:(AudioObject*)audioObject WithProgress:(NSProgress*)progress WithCompletion:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:audioObject.url]];
    
    id newCompletionHandler = ^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (!error && audioObject) {
            
            AudioManagedObject *audioManagedObject = [[MainStorage sharedMainStorage] createNewAudioObject];
            [audioManagedObject updateWithAudio:audioObject WithHomePath:[filePath path]];
            [[MainStorage sharedMainStorage] saveContext];
            
#warning TODO: rewrite this place
            MyMusicViewController *myMusicVc = (MyMusicViewController *)[TabBarController viewControllerForIndex:0];
            [myMusicVc.tableView reloadData];
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        completionHandler(response,filePath,error);
    };
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:&progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:newCompletionHandler];
    [downloadTask resume];
    return downloadTask;
}

@end