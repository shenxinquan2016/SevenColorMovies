//
//  SCSlideHeaderLabel.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/21.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCSlideHeaderLabel.h"

@implementation SCSlideHeaderLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:19];
        
        self.scale = 0.0;
        
    }
    return self;
}

/** 通过scale的改变改变多种参数 */
- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    
    self.textColor = [UIColor colorWithRed:scale*81.f/255.f green:scale*132.f/255.f blue:scale*255.f/255.f alpha:1];
    CGFloat minScale = 1.0;
    CGFloat trueScale = minScale + (1-minScale)*scale;
    self.transform = CGAffineTransformMakeScale(trueScale, trueScale);//label的size大小变换
}

@end
