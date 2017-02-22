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

- (void)setModel:(nonnull id)model IndexPath:(nullable NSIndexPath *)indexPath{
    if (model && [model isKindOfClass:[NSArray class]]) {
        
        if (indexPath.row == 0) {
            _channelNameLabel.text = @"直播";
            _channelImg.image = [UIImage imageNamed:@"直播"];
            
        } else if (indexPath.row == 4) {
            
            _channelNameLabel.text = @"掌厅";
            _channelImg.image = [UIImage imageNamed:@"掌厅"];
            
        } else if (indexPath.row > 0 && indexPath.row < 4){
            
            NSArray *filmClassTitleArray = model;
            _channelNameLabel.text = filmClassTitleArray[indexPath.row-1];
            _channelImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",filmClassTitleArray[indexPath.row-1]]];
            
            if (_channelImg.image == nil) {
                _channelImg.image = [UIImage imageNamed:@"GeneralChannel"];
            }
            
        } else {
            
            NSArray *filmClassTitleArray = model;
            _channelNameLabel.text = filmClassTitleArray[indexPath.row-2];
            _channelImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",filmClassTitleArray[indexPath.row-2]]];
            
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
