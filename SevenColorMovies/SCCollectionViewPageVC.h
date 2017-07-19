//
//  SCCollectionViewPageVC.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/2.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  film展示页 重复利用率非常高

#import <UIKit/UIKit.h>
#import "SCFilmClassModel.h"

/** 将mTye回传给上一级控制器 */
typedef void(^GetMtypeBlock)(NSString *mType);

@interface SCCollectionViewPageVC : UICollectionViewController

/** url端口 */
@property(nonatomic,copy) NSString *urlString;
@property (nonatomic,assign) NSInteger index;
/** 用于区别cell的显示类型 */
@property (nonatomic, strong) SCFilmClassModel *FilmClassModel;
@property (nonatomic, copy) GetMtypeBlock getMtype;
/** 当精彩推荐没有推荐数据时显示banner内容 */
@property (nonatomic, copy) NSArray *bannerFilmModelArray;

@end
