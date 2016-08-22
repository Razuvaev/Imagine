//
//  DownloadManager.m
//  razuvaevMusic
//
//  Created by Vladimir Vishnyagov on 22.08.16.
//  Copyright © 2016 Pavel Razuvaev. All rights reserved.
//

#import "DownloadManager.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Category)

- (NSString *)urlDataLocalPath {
    NSString *localPath = [NSString stringWithFormat:@"%@/tmp/music/%@", NSHomeDirectory(), [self md5]];
    
    return localPath;
}

- (NSString *)md5 {
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5( cStr, strlen(cStr), result );
    
    NSString *output = [[NSString
                         stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                         result[0], result[1],
                         result[2], result[3],
                         result[4], result[5],
                         result[6], result[7],
                         result[8], result[9],
                         result[10], result[11],
                         result[12], result[13],
                         result[14], result[15]] lowercaseString];
    
    return output;
}

@end


@interface DownloadManager ()

@property NSOperationQueue *queue;
@property NSString *url;
@property NSData *data;

@end

@implementation DownloadManager

@synthesize url = _url;

#pragma mark Inititialization

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark quene

- (NSData*)downloadAudioWithUrl:(NSString*)url/* WithProgress:(NSProgress*)progress */{
    
    _url = url;
    
    NSString *localPath = [_url urlDataLocalPath];
    NSData *data = [NSData dataWithContentsOfFile:localPath];
    
    if (data) {
        return data;
    }
    else {
        
        AudioLoadOperation *operation = [AudioLoadOperation new];
        operation.queuePriority = NSOperationQueuePriorityNormal;
        operation.url = _url;
        operation.delegate = self;
        
        if (_queue == nil) {
            _queue = [NSOperationQueue new];
            _queue.maxConcurrentOperationCount = 1;
        }
        
        [_queue addOperation:operation];
    
//        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//    
//        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
//        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:&progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
//        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
//        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
//        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//        // Do operation after download is complete
//            
//        }];
//        [downloadTask resume];
        
        return data;
    }
}

- (void)dataWasLoaded {
    self.data = [self downloadAudioWithUrl:_url/* WithProgress:nil*/];
}

@end

@implementation AudioLoadOperation

@synthesize delegate = _delegate;
@synthesize url = _url;

- (void)main {
    NSURL *url = [NSURL URLWithString:self.url];
    
    NSString *localPath = [self.url urlDataLocalPath];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    [data writeToFile:localPath atomically:NO];
    
    [self addSkipBackupAttributeToItemAtURL:url andLocalPath:localPath];
    
    [self.delegate performSelectorOnMainThread:@selector(dataWasLoaded) withObject:nil waitUntilDone:YES];
}

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL andLocalPath:(NSString*)localPath
{
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }else {
        //NSLog(@"Successfully exluded %@ at localPath: %@", [URL lastPathComponent], localPath);
    }
    return success;
}


@end