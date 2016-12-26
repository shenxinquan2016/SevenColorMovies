//
//  Dong_NullDataView.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/12/26.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dong_NullDataView : NSObject

+ (void)addImage:(UIImage *)image text:(NSString *)text view:(UIView*)view;
+ (void)addTapAction:(id)target action:(SEL)selector view:(UIView*)view;
+ (void)removeViewFromView:(UIView*)view;


@end
