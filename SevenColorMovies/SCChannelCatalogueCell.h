//
//  SCChannelCatalogueCell.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/21.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCChannelCatalogueCell : UICollectionViewCell

+ (nonnull instancetype)cellWithCollectionView:(nonnull UICollectionView *)collectionView indexPath:(nonnull NSIndexPath *)indexPath;
- (void)setModel:(nonnull id)model IndexPath:(nullable NSIndexPath *)indexPath;
@end
