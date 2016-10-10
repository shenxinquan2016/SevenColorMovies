//
//  SCCollectionViewPageVC.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/2.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  film展示页 重复利用率非常高

#import <UIKit/UIKit.h>
#import "SCFilmClassModel.h"

typedef void(^GetMtypeBlock)(NSString *mType);/** 将mTye回传给上一级控制器 */

@interface SCCollectionViewPageVC : UICollectionViewController

@property(nonatomic,copy) NSString *urlString;/** url端口 */
@property (nonatomic,assign) NSInteger index;
@property (nonatomic, strong) SCFilmClassModel *FilmClassModel;/** 用于区别cell的显示类型 */
@property (nonatomic, copy) GetMtypeBlock getMtype;
@property (nonatomic, copy) NSArray *bannerFilmModelArray;/** 当精彩推荐没有推荐数据时显示banner内容 */

@end
