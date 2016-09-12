//
//  SCDemandVideoCell.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/19.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMB_DownImageView.h"
#import "SCFilmClassModel.h"

@interface SCDemandChannelItemCell : UICollectionViewCell

@property (nonatomic, strong, nonnull) SCFilmClassModel *filmClassModel;

+ (nonnull instancetype)cellWithCollectionView:(nonnull UICollectionView *)collectionView indexPath:(nonnull NSIndexPath *)indexPath;
- (void)setModel:(nonnull id)model IndexPath:(nullable NSIndexPath *)indexPath;

@end
