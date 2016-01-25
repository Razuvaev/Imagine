//
//  UIImage+ColorArt.m
//  ColorArt
//
//  Created by Fred Leitz on 2012-12-17.
//  Copyright (c) 2012 Fred Leitz. All rights reserved.
//

#import "UIImage+ColorArt.h"
#import "UIImage+Scale.h"
@implementation UIImage (ColorArt)

- (SLColorArt *)colorArt:(CGSize)scale{
    return [[SLColorArt alloc] initWithImage:[self scaledToSize: scale]];
}

- (SLColorArt *)colorArt{
    return [self colorArt:CGSizeMake(512, 512)];
}

- (UIImage *)blurredImage {
    //  Create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:self.CGImage];
    
    //  Setting up Gaussian Blur
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:45.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    /*  CIGaussianBlur has a tendency to shrink the image a little, this ensures it matches
     *  up exactly to the bounds of our original image */
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    UIImage *retVal = [UIImage imageWithCGImage:cgImage];
    return retVal;
}

@end
