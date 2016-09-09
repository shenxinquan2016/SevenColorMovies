//
//  SCFliterOptionView.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/9/7.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  筛选项视图

#import <UIKit/UIKit.h>

typedef void(^DoBackBlock)(NSInteger tag, NSString *tabText);

@interface SCFliterOptionView : UIView

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) SCFilterOptionType type;/* 筛选卡的type 类型/地区/时间 */

+ (instancetype)viewWithType:(NSString *)type;

@end
