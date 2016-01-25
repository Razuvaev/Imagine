//
//  WebImageView.m
//  Allure
//
//  Created by Александр Чередников on 7/30/12.
//  Copyright (c) 2012 Personal. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>

NSOperationQueue *queue = nil;

@implementation NSString (Category)

- (NSString *)urlDataLocalPath {
	NSString *localPath = [NSString stringWithFormat:@"%@/tmp/%@", NSHomeDirectory(), [self md5]];
	
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


#import "WebImageView.h"

@implementation WebImageView

@synthesize activityIndicator = _activityIndicator;
@synthesize url = _url;
@synthesize isProductImage = _isProductImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		self.contentMode = UIViewContentModeScaleAspectFit;
		
        [self setBackgroundColor:[UIColor blackColor]];
		_activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		_activityIndicator.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
		_activityIndicator.hidesWhenStopped = YES;
		[self addSubview:_activityIndicator];
        [self bringSubviewToFront:_activityIndicator];
		
		[self.activityIndicator startAnimating];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	
	self.activityIndicator.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
}

- (void)setImageWithURL:(NSString *)url {
    if (url && url.length > 0) {
        self.image = [self imageForUrl:url];
    }
    else
    {
        self.image = [UIImage imageNamed:@"Zaglu6ka.png"];
        [self setBackgroundColor:[UIColor blackColor]];
        [_activityIndicator stopAnimating];
    }
}

- (UIImage *)imageForUrl:(NSString *)url {
	self.url = url;
	
	NSString *localPath = [url urlDataLocalPath];
	
	UIImage *image = [UIImage imageWithContentsOfFile:localPath];
	if (image == nil) {
		DataLoadOperation *operation = [DataLoadOperation new];
		operation.queuePriority = NSOperationQueuePriorityVeryLow;
		operation.url = url;
		operation.delegate = self;
		[self.activityIndicator startAnimating];
		
		if (queue == nil) {
			queue = [NSOperationQueue new];
			queue.maxConcurrentOperationCount = 1;
		}
		
		[queue addOperation:operation];
        [self setBackgroundColor:[UIColor blackColor]];
	}else {
        if (_isProductImage) {
            
        }
		[self.activityIndicator stopAnimating];
		
		if (self.backgroundFromImage) {
			CGRect fromRect = CGRectMake(0, 0, 1, 1);
			CGImageRef drawImage = CGImageCreateWithImageInRect(image.CGImage, fromRect);
			UIImage *patternImage = [UIImage imageWithCGImage:drawImage];
			CGImageRelease(drawImage);
			
			self.backgroundColor = [UIColor colorWithPatternImage:patternImage];
		}
	}
    if (image != nil) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"imageLoaded" object:image];
    }
	return image;
}

- (void)dataWasLoaded {
    [self setBackgroundColor:[UIColor blackColor]];
	self.image = [self imageForUrl:self.url];
}

@end

@implementation DataLoadOperation

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
