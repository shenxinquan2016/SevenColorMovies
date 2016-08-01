//
//  SCRankTopRowCollectionViewCell.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/24.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCFilmModel.h"

@interface SCRankTopRowCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) SCFilmModel *model;

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;
@end
