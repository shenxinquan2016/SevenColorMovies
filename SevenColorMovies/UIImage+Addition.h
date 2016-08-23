//
//  UIImage+Addition.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/18.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Addition)
/*
 * 返回纯色图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/*
 * 通过绘图设置图片圆形
 */
- (UIImage *)cutCircleImage;

/*
 * 通过图片Data数据第一个字节 来获取图片扩展名 如:png / jpeg / gif / tiff / webp
 */
+ (NSString *)contentTypeForImageData:(NSData *)imageData;

@end
