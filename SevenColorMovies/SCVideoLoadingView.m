//
//  SCVideoLoadingView.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/29.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCVideoLoadingView.h"

@implementation SCVideoLoadingView

- (void)startAnimating
{
    self.hidden = NO;
    if (!_loadingImageView.isAnimating) {
        _loadingImageView.animationRepeatCount = 0;
        NSArray *gifArray = [NSArray arrayWithObjects:
                             [UIImage imageNamed:@"loading_1"],
                             [UIImage imageNamed:@"loading_2"],
                             [UIImage imageNamed:@"loading_3"],
                             [UIImage imageNamed:@"loading_4"],
                             [UIImage imageNamed:@"loading_5"],
                             [UIImage imageNamed:@"loading_6"],
                             [UIImage imageNamed:@"loading_7"],
                             [UIImage imageNamed:@"loading_8"],
                             nil];
         _loadingImageView.animationImages = gifArray; //动画图片数组
        _loadingImageView.animationDuration = 1; //执行一次完整动画所需的时长
        _loadingImageView.animationRepeatCount = 0;  //动画重复次数
        [_loadingImageView startAnimating];
    }
}

- (void)endAnimating
{
    [_loadingImageView stopAnimating];
    self.hidden = YES;
}


@end
