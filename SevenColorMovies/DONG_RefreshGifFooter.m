//
//  DONG_RefreshGifFooter.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/28.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "DONG_RefreshGifFooter.h"

@implementation DONG_RefreshGifFooter

#pragma mark - 重写方法
#pragma mark 基本设置
- (void)prepare
{
    [super prepare];
    
    // 设置普通状态的动画图片
    //    NSMutableArray *idleImages = [NSMutableArray array];
    //    for (NSUInteger i = 1; i<=60; i++) {
    //        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%zd", i]];
    //        [idleImages addObject:image];
    //    }
    //    [self setImages:idleImages forState:MJRefreshStateIdle];
    // 根据状态做事情
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    UIImage *img = [UIImage imageNamed:@"狗头晃动gif1.png"];
    [refreshingImages addObject:img];
    [self setImages:refreshingImages forState:MJRefreshStateIdle];
    img = [UIImage imageNamed:@"狗头晃动gif2.png"];
    [refreshingImages addObject:img];
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
}

@end
