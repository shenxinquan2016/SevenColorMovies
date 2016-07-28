//
//  DONG_RefreshGifHeader.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/28.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "DONG_RefreshGifHeader.h"

@implementation DONG_RefreshGifHeader

#pragma mark - 重写方法
#pragma mark 基本设置
- (void)prepare
{
    [super prepare];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (int i=0; i<8; i++) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_%zd",i+1]];//TL_IMAGE([NSString stringWithFormat:@"refresh_%zd",i+1]);
        [refreshingImages addObject:img];
    }
    [self setImages:refreshingImages forState:MJRefreshStateIdle];
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
    
    //    NSMutableArray *idleImages = [NSMutableArray array];
    //    for (NSUInteger i = 1; i<=60; i++) {
    //        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%zd", i]];
    //        [idleImages addObject:image];
    //    }
    //    [self setImages:idleImages forState:MJRefreshStateIdle];
    //
    //    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    //    NSMutableArray *refreshingImages = [NSMutableArray array];
    //    for (NSUInteger i = 1; i<=3; i++) {
    //        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
    //        [refreshingImages addObject:image];
    //    }
    //    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    //
    //    // 设置正在刷新状态的动画图片
    //    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
}


@end
