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
    // Initialization code
}

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"SCChannelCatalogueCell";
    
    SCChannelCatalogueCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (cell == nil) cell = [[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil][0];
    return cell;
}

- (void)setModel:(nonnull id)model IndexPath:(nullable NSIndexPath *)indexPath{
    if (model && [model isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)model;
        NSString *keyStr = [dict.allKeys objectAtIndex:0];
        
        _channelImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",keyStr]];
        _channelNameLabel.text =  [dict.allValues objectAtIndex:0];
        
        
        
    }
    
}


@end
