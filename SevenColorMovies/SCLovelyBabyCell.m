//
//  SCLovelyBabyCell.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/6/15.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import "SCLovelyBabyCell.h"

@interface SCLovelyBabyCell ()

@property (weak, nonatomic) IBOutlet UIImageView *coverIV;
@property (weak, nonatomic) IBOutlet UILabel *personalNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalVoteLabel;


@end

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
    
    _personalNoLabel.text = [NSString stringWithFormat:@"编号:%@",babyModel.serialNumber];
    _nameLabel.text = babyModel.mzName;
    _totalVoteLabel.text = [NSString stringWithFormat:@"%@票", babyModel.voteNum];
    [_coverIV sd_setImageWithURL:[NSURL URLWithString:babyModel.showUrl] placeholderImage:[UIImage imageNamed:@"Image-8"]];
}

@end
