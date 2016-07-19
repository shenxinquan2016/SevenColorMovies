//
//  UIImage+Addition.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/18.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "UIImage+Addition.h"

const char kRadius;
const char kRoundingCorners;
const char kIsRounding;
const char kHadAddObserver;
const char kProcessedImage;

const char kBorderWidth;
const char kBorderColor;

@interface UIImageView ()

@property (assign, nonatomic) CGFloat radius;
@property (assign, nonatomic) UIRectCorner roundingCorners;
@property (assign, nonatomic) CGFloat borderWidth;
@property (strong, nonatomic) UIColor *borderColor;
@property (assign, nonatomic) BOOL hadAddObserver;
@property (assign, nonatomic) BOOL isRounding;

@end

@implementation UIImage (Addition)

/*
 * 返回纯色图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/*
 * 图片圆角处理
 */



@end
