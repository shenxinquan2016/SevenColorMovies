//
//  SCSycleBanner.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/18.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCSycleBanner.h"

@implementation SCSycleBanner

- (instancetype)initWithView:(UIView *)view {
    if (self = [super init]) {
        self = [SCSycleBanner cycleScrollViewWithFrame:CGRectMake(0, -157, kMainScreenWidth, 157) delegate:nil placeholderImage:[UIImage imageNamed:@"BannerLoading"]];
        
        self.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        self.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
        [view addSubview:self];
        
    }
    
    return self;
}

@end
