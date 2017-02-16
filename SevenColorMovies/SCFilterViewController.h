//
//  SCFilterViewController.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/29.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  筛选控制器

#import <UIKit/UIKit.h>
#import "SCOtherBaseViewController.h"
#import "SCFilmClassModel.h"

@interface SCFilterViewController : SCOtherBaseViewController

@property (nonatomic, strong) SCFilmClassModel *filmClassModel;
/** mtype筛选参数之一 */
@property (nonatomic, copy) NSString *mtype;
/** 当精彩推荐没有推荐数据时显示banner内容 */
@property (nonatomic, copy) NSArray *bannerFilmModelArray;

@end
