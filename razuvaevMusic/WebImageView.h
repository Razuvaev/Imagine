//
//  WebImageView.h
//  Allure
//
//  Created by Александр Чередников on 7/30/12.
//  Copyright (c) 2012 Personal. All rights reserved.
//

@protocol DataLoadOperationDelegate <NSObject>

- (void)dataWasLoaded;

@end

@interface WebImageView : UIImageView <DataLoadOperationDelegate>

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) NSString *url;
@property BOOL backgroundFromImage;
@property BOOL isProductImage;

- (void)setImageWithURL:(NSString *)url;

@end

@interface DataLoadOperation : NSOperation

@property (nonatomic, strong) NSObject<DataLoadOperationDelegate> *delegate;
@property (nonatomic, strong) NSString *url;

@end
