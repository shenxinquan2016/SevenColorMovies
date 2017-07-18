//
//  ChannelCatalogueVC.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/21.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  点播栏 —— 更多

#import <UIKit/UIKit.h>
#import "SCOtherBaseViewController.h"

typedef void(^RefreshHomePageBlock)();

@interface SCChannelCatalogueVC : SCOtherBaseViewController

@property (nonatomic, strong) NSMutableArray *filmClassTitleArray;/** 每个cell的title */
@property (nonatomic, strong) NSMutableDictionary *filmClassModelDictionary; // 标题&filmClassModel字典

@property (nonatomic, copy) RefreshHomePageBlock refreshHomePageBlock;/** 编辑排序刷新首页对应视图 */
@property (nonatomic, copy) NSArray *bannerFilmModelArray;/** 当精彩推荐没有推荐数据时显示banner内容 */

@end
