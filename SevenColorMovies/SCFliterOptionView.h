//
//  SCFliterOptionView.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/9/7.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  筛选项视图

#import <UIKit/UIKit.h>


@interface SCFliterOptionView : UIView

@property (nonatomic, copy) NSArray *dataArray;

+ (instancetype)viewWithType:(NSString *)type;

@end
