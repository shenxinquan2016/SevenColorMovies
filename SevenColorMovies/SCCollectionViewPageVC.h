//
//  SCCollectionViewPageVC.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/2.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCFilmClassModel.h"
@interface SCCollectionViewPageVC : UICollectionViewController

/** url端口 */
@property(nonatomic,copy) NSString *urlString;

@property (nonatomic,assign) NSInteger index;

/** 用于区别cell的显示类型 */
@property (nonatomic, strong) SCFilmClassModel *FilmClassModel;

@end
