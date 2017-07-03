//
//  UIImage+IMB.h
//  ArtPraise
//
//  Created by gcz on 14-7-9.
//  Copyright (c) 2014年 闫建刚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (IMB)

-(UIImage *)imageAtRect:(CGRect)rect;
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;

- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
// 弧度
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
// 角度
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;


// 等比压缩
- (UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;


@end
