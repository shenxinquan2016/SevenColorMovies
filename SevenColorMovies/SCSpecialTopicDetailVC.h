//
//  SCSpecialTopicDetailVC.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/11.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCOtherBaseViewController.h"

@interface SCSpecialTopicDetailVC : SCOtherBaseViewController

/** url端口 */
@property(nonatomic,copy) NSString *urlString;
@property (nonatomic, copy) NSArray *bannerFilmModelArray;/** 当精彩推荐没有推荐数据时显示banner内容 */

@end
