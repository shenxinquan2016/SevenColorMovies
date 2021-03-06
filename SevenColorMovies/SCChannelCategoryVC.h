//
//  SCChannelCategoryVC.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/22.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  点播节目频道分类

#import <UIKit/UIKit.h>
#import "SCOtherBaseViewController.h"
@class SCFilmClassModel;

@interface SCChannelCategoryVC : SCOtherBaseViewController

@property (nonatomic, strong) SCFilmClassModel *filmClassModel;
@property (nonatomic, copy) NSArray *bannerFilmModelArray;/** 当精彩推荐没有推荐数据时显示banner内容 */

@end
