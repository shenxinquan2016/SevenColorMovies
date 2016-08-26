//
//  SCLiveProgramListCell.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/24.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCLiveProgramModel.h"

@interface SCLiveProgramListCell : UICollectionViewCell

@property (nonatomic, strong) SCLiveProgramModel *model;
@property (weak, nonatomic) IBOutlet UILabel *topSeparateline;

@property (weak, nonatomic) IBOutlet UILabel *liveProgramTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *liveProgramNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *liveProgramStateLabel;

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView identifier:(NSString *)identifier indexPath:(NSIndexPath *)indexPath;

@end
