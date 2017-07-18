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
    NSString *title = filmClassTitleArray[indexPath.row];
    SCFilmClassModel *filmClassModel = [_filmClassModelDictionary objectForKey:title];
    
    if (model && [model isKindOfClass:[NSArray class]]) {
        
        if (indexPath.row == filmClassTitleArray.count) {
            _channelNameLabel.text = @"萌娃";
            _channelImg.image = [UIImage imageNamed:@"LovelyBaby"];
            
        } else {
            
            _channelNameLabel.text = title;
            [_channelImg sd_setImageWithURL:[NSURL URLWithString:filmClassModel._IconUrl] placeholderImage:[UIImage imageNamed:@"GeneralChannel"]];
       
        }
    }
}

- (void)setFilmClassModel:(SCFilmClassModel *)filmClassModel
{
    _channelNameLabel.text = filmClassModel._FilmClassName;
    _channelImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",filmClassModel._FilmClassName]];
    
    if (_channelImg.image == nil) {
        _channelImg.image = [UIImage imageNamed:@"GeneralChannel"];
    }

}



@end
