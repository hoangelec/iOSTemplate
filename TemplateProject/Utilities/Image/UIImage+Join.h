//
//  UIImage+Join.h
//  ELIMagazine
//
//  Created by Ryhor Burakou on 6/3/13.
//  Copyright (c) 2013 khoa nguen. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "UIScreen+Retina

typedef void(^ImageCallbackBlock)(UIImage *joinedImage);

@interface UIImage (Join)


+ (UIImage *)joinedImageFromFirstImage:(UIImage *)im1 secondImage:(UIImage *)im2 backgroundColor:(UIColor*)backColor forceSize:(CGSize)forceSize;

+ (void)joinedVerticallyImageFromImages:(NSArray *)images backgroundColor:(UIColor*)backColor callback:(ImageCallbackBlock)callback;

- (UIImage*) transparentImageOnBackground:(UIColor*)backColor;


@end
