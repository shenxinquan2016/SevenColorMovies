//
//  SCDemandVideoCell.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/19.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMB_DownImageView.h"


@interface SCDemandChannelItemCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *channelImage;

@property (weak, nonatomic) IBOutlet UILabel *channelName;

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;
@end
