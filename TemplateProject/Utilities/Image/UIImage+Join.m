//
//  UIImage+Join.m
//  ELIMagazine
//
//  Created by Ryhor Burakou on 6/3/13.
//  Copyright (c) 2013 khoa nguen. All rights reserved.
//

#import "UIImage+Join.h"

@implementation UIImage (Join)
+ (UIImage *)joinedImageFromFirstImage:(UIImage *)im1 secondImage:(UIImage *)im2 backgroundColor:(UIColor*)backColor forceSize:(CGSize)forceSize
{
    
    //Joins 2 UIImages together, stitching them horizontally
    float totalWidth, w1=0, w2=0, h;
    
    UIImage *finalImage = nil;
    
    if (forceSize.width == 0 || forceSize.height == 0)
    {
        if (im1 && !im2) {totalWidth = im1.size.width * 2; w1 = w2 = totalWidth / 2.0f; h = im1.size.height;}
        else if (im2 && !im1) {totalWidth = im2.size.width * 2; w1 = w2 = totalWidth / 2.0f; h = im2.size.height;}
        else /*(im2 && im1)*/ {totalWidth = im2.size.width + im1.size.width; w1 = im1.size.width; h = im2.size.height;}
    }
    else
    {
        //        if ([UIScreen isRetina])
        //        {
        //            forceSize.width *= 2;
        //            forceSize.height *= 2;
        //        }
        
        w1 = w2 = forceSize.width;
        totalWidth = w1 + w2;
        h = forceSize.height;
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(NULL, totalWidth,h, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    // draw to the context here
    {
        CGContextSetFillColorWithColor(ctx, backColor.CGColor);
        if (im1)
            CGContextFillRect(ctx, CGRectMake(0, 0, w1, h));
        
        if (im2)
            CGContextFillRect(ctx, CGRectMake(w1, 0, w2, h));
        
        @autoreleasepool
        {
        if (im1)
        {
            CGContextDrawImage(ctx, CGRectMake(0, 0, w1, h), im1.CGImage);
        }
        if (im2)
            CGContextDrawImage(ctx, CGRectMake(w1, 0, w2, h), im2.CGImage);        
        }
        CGImageRef newCGImage = CGBitmapContextCreateImage(ctx);
        CGContextRelease(ctx);
        finalImage = nil;//[UIImage imageWithCGImage:newCGImage scale:1.0f orientation: UIImageOrientationUp];
        CGImageRelease(newCGImage);

    }
    return finalImage;
}

+ (void)joinedVerticallyImageFromImages:(NSArray *)images backgroundColor:(UIColor*)backColor callback:(ImageCallbackBlock)callback
{
    dispatch_queue_t queue = dispatch_queue_create("image.join", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        //do the joining here
        
        //Joins UIImages together, stitching them vertically
        float totalWidth=0, totalHeight=0, w1=0, w2=0, h1=0, h2=0;
        
        //set totalWudth
        UIImage *finalImage = nil;
        for (UIImage *image in images)
        {
            if (image.size.width >totalWidth)
                totalWidth = image.size.width;
        }
        
        for (int i = 0; i<images.count; i++)
        {
            UIImage *image = images[i];
            
            w1 = finalImage.size.width;
            w2 = image.size.width;
            
            h1 =finalImage.size.height;
            h2 =image.size.height;
            totalHeight = h1 + h2;
            
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGContextRef ctx = CGBitmapContextCreate(NULL, totalWidth, totalHeight, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
            CGColorSpaceRelease(colorSpace);
            
            // draw to the context here
            {
                CGContextSetFillColorWithColor(ctx, backColor.CGColor);
                if (finalImage)
                {
                    CGRect imageRect = CGRectMake(totalWidth/2-w1/2, totalHeight-h1, totalWidth, h1);
                    CGContextFillRect(ctx, imageRect);
                    
                }
                
                if (image)
                {
                    CGRect imageRect = CGRectMake(totalWidth/2-w2/2, 0, w2, h2);
                    CGContextFillRect(ctx, imageRect);
                }
                
                
                @autoreleasepool
                {
                    if (finalImage)
                    {
                        CGRect imageRect = CGRectMake(totalWidth/2-w1/2, totalHeight-h1, totalWidth, h1);
                        CGContextDrawImage(ctx, imageRect, finalImage.CGImage);
                    }
                    if (image)
                    {
                        CGRect imageRect = CGRectMake(totalWidth/2-w2/2, 0, w2, h2);
                        CGContextDrawImage(ctx, imageRect, image.CGImage);
                    }
                    
                }
                CGImageRef newCGImage = CGBitmapContextCreateImage(ctx);
                CGContextRelease(ctx);
                finalImage = nil;
                finalImage = [UIImage imageWithCGImage:newCGImage scale:1.0f orientation: UIImageOrientationUp];
                CGImageRelease(newCGImage);
            }
        }

        //report back to main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(finalImage);
        });
        
    });
}


- (UIImage*) transparentImageOnBackground:(UIColor*)backColor
{
    CGSize size = self.size;
    UIGraphicsBeginImageContext(size);
    
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [backColor set];
    CGContextFillRect(ctx, CGRectMake(0,0,size.width,size.height));
    
    CGPoint image2Point = CGPointMake(0, 0);
    [self drawAtPoint:image2Point];
    
    UIImage* finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return finalImage;
}
@end
