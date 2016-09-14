//
//  SCMoiveAllEpisodesCollectionVC.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/8.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCMoiveAllEpisodesCollectionVC : UICollectionViewController

@property (nonatomic, strong) NSArray *dataSource;/** sets数据 */
@property (nonatomic, assign) NSInteger viewIdentifier;

@end
