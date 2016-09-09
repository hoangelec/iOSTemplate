//
//  CircleView.m
//  Trendify
//
//  Created by Tuan Nguyen on 12/25/14.
//  Copyright (c) 2014 Elinext. All rights reserved.
//

#import "CircleView.h"

@implementation CircleView
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.layer.cornerRadius = self.width/2;
}
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.width/2;
}
@end
