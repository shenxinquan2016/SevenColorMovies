//
//  SCLivePageCell.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/22.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCFilmModel.h"

@interface SCLivePageCell : UICollectionViewCell

@property (nonatomic, strong) SCFilmModel *filmModel;

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView identifier:(NSString *)identifier indexPath:(NSIndexPath *)indexPath;

@end
