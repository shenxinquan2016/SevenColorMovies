//
//  ChannelCatalogueVC.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/21.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  点播栏 —— 更多

#import <UIKit/UIKit.h>
#import "SCOtherBaseViewController.h"

@interface SCChannelCatalogueVC : SCOtherBaseViewController

@property (nonatomic, strong) NSMutableArray *filmClassArray;/** 存储filmList中的filmClass模型（第二层数据）*/
@property (nonatomic, strong) NSMutableArray *filmClassTitleArray;/** 每个cell的title */
@property (nonatomic, strong) NSMutableArray *allItemsArr;/** 所有选项数组 */

@end
