//
//  UILabel+Addition.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/9/2.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Addition)

- (void)alignTop;
- (void)alignBottom;

/* 根据label文字的字体多少计算label的frame */
- (CGSize)boundingRectWithSize:(CGSize)size;
@end
