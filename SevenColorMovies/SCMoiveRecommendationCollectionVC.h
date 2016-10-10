//
//  SCMoiveRecommendationCollectionVC.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/8.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCFilmModel.h"


@interface SCMoiveRecommendationCollectionVC : UICollectionViewController

@property (nonatomic, strong) SCFilmModel *filmModel;
@property (nonatomic, copy) NSArray *bannerFilmModelArray;/** 当精彩推荐没有推荐数据时显示banner内容 */
@end
