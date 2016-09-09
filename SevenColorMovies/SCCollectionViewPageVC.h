//
//  SCCollectionViewPageVC.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/2.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCFilmClassModel.h"

typedef void(^GetMtypeBlock)(NSString *mType);/** 将mTye回传给上一级控制器 */

@interface SCCollectionViewPageVC : UICollectionViewController

@property(nonatomic,copy) NSString *urlString;/** url端口 */
@property (nonatomic,assign) NSInteger index;
@property (nonatomic, strong) SCFilmClassModel *FilmClassModel;/** 用于区别cell的显示类型 */
@property (nonatomic, copy) GetMtypeBlock getMtype;

@end
