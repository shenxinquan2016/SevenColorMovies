//
//  SCCollectionViewPageCell.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/24.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCFilmModel.h"
#import "SCFilmClassModel.h"

@interface SCCollectionViewPageCell : UICollectionViewCell

@property (nonatomic, strong) SCFilmModel *model;
@property (nonatomic, strong) SCFilmClassModel *filmClassModel;

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;
@end
