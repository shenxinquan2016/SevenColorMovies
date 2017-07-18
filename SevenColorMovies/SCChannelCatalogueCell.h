//
//  SCChannelCatalogueCell.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/21.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCFilmClassModel.h"

@interface SCChannelCatalogueCell : UICollectionViewCell

@property (nonatomic, strong, nonnull) SCFilmClassModel *filmClassModel;

@property (nonatomic, strong) NSMutableDictionary * _Nullable filmClassModelDictionary; // 标题&filmClassModel字典

+ (nonnull instancetype)cellWithCollectionView:(nonnull UICollectionView *)collectionView indexPath:(nonnull NSIndexPath *)indexPath;

- (void)setModel:(nonnull id)model IndexPath:(nullable NSIndexPath *)indexPath;

@end
