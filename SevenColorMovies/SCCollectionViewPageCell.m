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
    
    NSString *imageUrl;
    if (model._ImgUrl) {
        imageUrl = model._ImgUrl;
    }else if (model.smallposterurl){
        imageUrl = model.smallposterurl;
    }
    
    NSURL *imgUrl = [NSURL URLWithString:imageUrl];
    [_filmImage sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"假数据"]];
    
    NSString *filmName;
    if (model.FilmName) {
        filmName = model.FilmName;
    }else if (model.cnname){
        filmName = model.cnname;
    }
    _filmName.text = filmName;
}

- (void)setFilmClassModel:(SCFilmClassModel *)filmClassModel{
    
    NSURL *imgUrl = [NSURL URLWithString:filmClassModel._BigImgUrl];
    [_filmImage sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"假数据"]];

    _filmName.text = filmClassModel._FilmClassName;
    
}


@end
