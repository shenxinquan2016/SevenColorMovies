//
//  SCLovelyBabyCell.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/6/15.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import "SCLovelyBabyCell.h"

@implementation SCLovelyBabyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath
{
    static NSString *ID;
    ID = @"SCLovelyBabyCell";
    
    SCLovelyBabyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (cell == nil) cell = [[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil][0];
    return cell;
}

- (void)setBabyModel:(SCLovelyBabyModel *)babyModel
{
    _babyModel = babyModel;
    
    DONG_Log(@"serialNumber-->%lu  id-->%@", babyModel.serialNumber, babyModel.id);
}

@end
