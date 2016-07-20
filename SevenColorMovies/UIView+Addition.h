//
//  UIView+Addition.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/20.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Addition)
/**
 *  圆形化
 *
 *  @return self
 */
- (id)cornerView;

/**
 *  圆角化
 *
 *  @param radius 圆角半径
 *
 *  @return self
 */
- (id)cornerViewWithRadius:(CGFloat)radius;

// 圆化指定角
// 注意最好固定好宽高后，在调用此方法，才会完美奏效
- (id)cornerViewWithRadius:(CGFloat)radius rectCorner:(UIRectCorner)rectCorner;

/**
 *  添加边界
 *
 *  @param width   边界宽度
 *  @param color   边界颜色
 *
 *  @return self
 */
- (id)addBorderWithWidth:(CGFloat)width color:(UIColor *)color;

/**
 *  添加阴影
 *
 *  @param radius  阴影半径
 *  @param color   阴影颜色
 *  @param offSet  阴影相对偏移量 (CGSize)
 *  @param opacity 阴影透明度
 *
 *  @return self
 */
- (id)addShadowWithRadius:(CGFloat)radius color:(UIColor *)color offset:(CGSize)offSet  opacity:(CGFloat)opacity;

// 获取view所在的controller
- (UIViewController *)respondController;

// 动画
- (void)showBounceAnimation;
// 自定义动画路线
- (void)showBounceAnimationWithValues:(NSArray *)arr;


@end
