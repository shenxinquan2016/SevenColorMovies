//
//  SCLovelyBabyCell.h
//  SevenColorMovies
//
//  Created by yesdgq on 2017/6/15.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCLovelyBabyModel.h"

@interface SCLovelyBabyCell : UICollectionViewCell

@property (nonatomic, strong) SCLovelyBabyModel *babyModel;

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;

@end
