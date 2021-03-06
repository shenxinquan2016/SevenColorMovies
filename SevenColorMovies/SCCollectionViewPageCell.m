//
//  SCCollectionViewPageCell.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/24.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCCollectionViewPageCell.h" 

@interface SCCollectionViewPageCell()

@property (weak, nonatomic) IBOutlet UIImageView *filmImage;
@property (weak, nonatomic) IBOutlet UILabel *filmName;
@property (nonatomic, copy) NSString *identifier;

@end

@implementation SCCollectionViewPageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView identifier:(NSString *)identifier indexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID;
    if ([identifier isEqualToString:@"综艺"] || [identifier isEqualToString:@"潮生活"] || [identifier isEqualToString:@"专题"]) {
        ID = @"SCCollectionViewPageArtsCell";
    } else {
        ID = @"SCCollectionViewPageCell";
    }
    
    SCCollectionViewPageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (cell == nil) cell = [[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil][0];
    cell.identifier = identifier;
    return cell;
}

- (void)setModel:(SCFilmModel *)filmModel
{
    NSString *imageUrl;
   
    if ([_identifier isEqualToString:@"综艺"] || [_identifier isEqualToString:@"潮生活"]) {
        // 横版图片
        imageUrl = filmModel._ImgUrlB;
        NSURL *imgUrl = [NSURL URLWithString:imageUrl];
        
        [_filmImage sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"CellLoading_Horizontal"]];

    } else if ([_identifier isEqualToString:@"专题"]) {
        
        // 横版图片 专题时取图用的字段不一样不一样
        if (filmModel._ImgUrlO) {
            
            imageUrl = filmModel._ImgUrlO;
            
        } else if (filmModel._ImgUrlOriginal) {
            
             imageUrl = filmModel._ImgUrlOriginal;
        }
        
        NSURL *imgUrl = [NSURL URLWithString:imageUrl];
        
        [_filmImage sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"CellLoading_Horizontal"]];
        
    } else {
    
        // 竖版图片
        if (filmModel._ImgUrl) {
            
            imageUrl = filmModel._ImgUrl;
            
        } else if (filmModel.smallposterurl){
            
            imageUrl = filmModel.smallposterurl;
        }
        
//        DONG_Log(@"imageUrl:%@",imageUrl);
        NSURL *imgUrl = [NSURL URLWithString:imageUrl];
        [_filmImage sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"CellLoading"]];
    }
    
    NSString *filmName;
    if (filmModel.FilmName) {
        
        filmName = filmModel.FilmName;
        
    }else if (filmModel.cnname){
        
        filmName = filmModel.cnname;
        
    }
    _filmName.text = filmName;
}

// 专题 更多分类中专题横版（有下一级目录）
- (void)setFilmClassModel:(SCFilmClassModel *)filmClassModel
{
    NSURL *imgUrl = [NSURL URLWithString:filmClassModel._BigImgUrl];
    [_filmImage sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"CellLoading_Horizontal"]];

    _filmName.text = filmClassModel._FilmClassName;
    
}


@end
