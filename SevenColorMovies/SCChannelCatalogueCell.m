//
//  SCChannelCatalogueCell.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/21.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCChannelCatalogueCell.h"

@interface SCChannelCatalogueCell()

@property (weak, nonatomic) IBOutlet UIImageView *channelImg;

@property (weak, nonatomic) IBOutlet UILabel *channelNameLabel;

@end

@implementation SCChannelCatalogueCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    
}

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"SCChannelCatalogueCell";
    
    SCChannelCatalogueCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (cell == nil) cell = [[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil][0];
    return cell;
}

- (void)setModel:(nonnull id)model IndexPath:(nullable NSIndexPath *)indexPath
{
    NSArray *filmClassTitleArray = model;
    if (model && [model isKindOfClass:[NSArray class]]) {
        if (indexPath.row == 0) {
            _channelNameLabel.text = @"政府";
            _channelImg.image = [UIImage imageNamed:@"Government"];
        } else if (indexPath.row == 1) {
            _channelNameLabel.text = @"先锋网";
            _channelImg.image = [UIImage imageNamed:@"PioneerNet"];
        } else if (indexPath.row == 2) {
            _channelNameLabel.text = @"直播";
            _channelImg.image = [UIImage imageNamed:@"直播"];
        } else if (indexPath.row == 3) {
            _channelNameLabel.text = @"营业厅";
            _channelImg.image = [UIImage imageNamed:@"营业厅"];
        } else if (indexPath.row == filmClassTitleArray.count+4) {
            _channelNameLabel.text = @"萌娃";
            _channelImg.image = [UIImage imageNamed:@"LovelyBaby"];
        } else {
            _channelNameLabel.text = filmClassTitleArray[indexPath.row-4];
            _channelImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",filmClassTitleArray[indexPath.row-4]]];
            
            if (_channelImg.image == nil) {
                _channelImg.image = [UIImage imageNamed:@"GeneralChannel"];
            }
        }
    }
}

- (void)setFilmClassModel:(SCFilmClassModel *)filmClassModel{
    
    _channelNameLabel.text = filmClassModel._FilmClassName;
    _channelImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",filmClassModel._FilmClassName]];
    
    if (_channelImg.image == nil) {
        _channelImg.image = [UIImage imageNamed:@"GeneralChannel"];
    }
    
    
    
}



@end
