//
//  UIView+Helper.m
//  Bukket
//
//  Created by Tuan Nguyen on 4/5/14.
//  Copyright (c) 2014 Sigterm LLC. All rights reserved.
//

#import "UIView+Helper.h"

@implementation UIView (Helper)
-(void)setFont:(NSString *)name size:(float)size{
    if([self class] == [UIButton class]){
        UIButton *btn = (UIButton *)self;
        [btn.titleLabel setFont:[UIFont fontWithName:name size:size]];
    }
    else if([self class] == [UILabel class]){
        UILabel *label = (UILabel *)self;
        [label setFont:[UIFont fontWithName:name size:size]];
    }
    else if([self class] == [UITextField class]){
        UITextField *tf = (UITextField *)self;
        [tf setFont:[UIFont fontWithName:name size:size]];
    }

}
-(void) setFontWithName:(NSString *)name
{
    if([self class] == [UIButton class]){
        UIButton *btn = (UIButton *)self;
        [btn.titleLabel setFont:[UIFont fontWithName:name size:btn.titleLabel.font.pointSize]];
    }
    else if([self class] == [UILabel class]){
        UILabel *label = (UILabel *)self;
        [label setFont:[UIFont fontWithName:name size:label.font.pointSize]];
    }
    else if([self class] == [UITextField class]){
        UITextField *tf = (UITextField *)self;
        [tf setFont:[UIFont fontWithName:name size:tf.font.pointSize]];
    }

    else if([self class] == [UISearchBar class]){
        UISearchBar *sb = (UISearchBar *)self;
        UITextField *textField = [[sb subviews] objectAtIndex:1];
        [textField setFontWithName:name];
    }
}
-(void) roundCorner:(CGFloat)radius
{
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 0;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)newOrigin {
    CGRect newFrame = self.frame;
    newFrame.origin = newOrigin;
    self.frame = newFrame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)newSize {
    CGRect newFrame = self.frame;
    newFrame.size = newSize;
    self.frame = newFrame;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)newX {
    CGRect newFrame = self.frame;
    newFrame.origin.x = newX;
    self.frame = newFrame;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)newY {
    CGRect newFrame = self.frame;
    newFrame.origin.y = newY;
    self.frame = newFrame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)newHeight {
    CGRect newFrame = self.frame;
    newFrame.size.height = newHeight;
    self.frame = newFrame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)newWidth {
    CGRect newFrame = self.frame;
    newFrame.size.width = newWidth;
    self.frame = newFrame;
}


-(void)scrollToY:(float)y
{
    
    [UIView beginAnimations:@"registerScroll" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4];
    self.transform = CGAffineTransformMakeTranslation(0, y);
    [UIView commitAnimations];
    
}

-(void)scrollToView:(UIView *)view
{
    CGRect theFrame = view.frame;
    float y = theFrame.origin.y - 15;
    y -= (y/1.7);
    [self scrollToY:-y];
}


-(void)scrollElement:(UIView *)view toPoint:(float)y
{
    CGRect theFrame = view.frame;
    float orig_y = theFrame.origin.y;
    float diff = y - orig_y;
    if (diff < 0) {
        [self scrollToY:diff];
    }
    else {
        [self scrollToY:0];
    }
    
}
@end
