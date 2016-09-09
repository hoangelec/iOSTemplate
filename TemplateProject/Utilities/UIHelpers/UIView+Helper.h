//
//  UIView+Helper.h
//  Bukket
//
//  Created by Tuan Nguyen on 4/5/14.
//  Copyright (c) 2014 Sigterm LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Helper)
-(void) setFont:(NSString *)name size:(float)size;
-(void) setFontWithName:(NSString *)name;
-(void) roundCorner:(CGFloat)radius;
- (CGPoint)origin;
- (void)setOrigin:(CGPoint)newOrigin;
- (CGSize)size;
- (void)setSize:(CGSize)newSize;

- (CGFloat)x;
- (void)setX:(CGFloat)newX;
- (CGFloat)y;
- (void)setY:(CGFloat)newY;

- (CGFloat)height;
- (void)setHeight:(CGFloat)newHeight;
- (CGFloat)width;
- (void)setWidth:(CGFloat)newWidth;
-(void)scrollToY:(float)y;
-(void)scrollToView:(UIView *)view;
-(void)scrollElement:(UIView *)view toPoint:(float)y;
@end
