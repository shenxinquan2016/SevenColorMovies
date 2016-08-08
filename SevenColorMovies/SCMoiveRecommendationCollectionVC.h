//
//  SCMoiveRecommendationCollectionVC.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/8.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCMoiveRecommendationCollectionVC : UICollectionViewController

/** url端口 */
@property(nonatomic,copy) NSString *urlString;

@property (nonatomic,assign) NSInteger index;

@end
