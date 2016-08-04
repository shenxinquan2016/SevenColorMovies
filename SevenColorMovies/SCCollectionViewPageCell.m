//
//  SCCollectionViewPageCell.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/24.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCCollectionViewPageCell.h"
#import "UIImageView+WebCache.h" 

@interface SCCollectionViewPageCell()

@property (weak, nonatomic) IBOutlet UIImageView *filmImage;

@property (weak, nonatomic) IBOutlet UILabel *filmName;


@end


@implementation SCCollectionViewPageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID;
    ID = @"SCCollectionViewPageCell";
    SCCollectionViewPageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (cell == nil) cell = [[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil][0];
    return cell;
}

- (void)setModel:(SCFilmModel *)model {
    
    _filmName.text = model.FilmName;
    NSURL *imgUrl = [NSURL URLWithString:model._ImgUrl];
    [_filmImage sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"假数据"]];
    
}

@end