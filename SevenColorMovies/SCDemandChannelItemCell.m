//
//  SCDemandVideoCell.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/19.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCDemandChannelItemCell.h"
#import "SCFilmClassModel.h"

@interface SCDemandChannelItemCell()

@property (weak, nonatomic) IBOutlet UIImageView *channelImg;
@property (weak, nonatomic) IBOutlet UILabel *channelNameLabel;
@end

@implementation SCDemandChannelItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}



- (void)setModel:(nonnull id)model IndexPath:(nullable NSIndexPath *)indexPath
{
    NSArray *array = model;
    if (indexPath.row == 0) {
        _channelImg.image = [UIImage imageNamed:@"直播"];
        _channelNameLabel.text =  @"直播";
    } else if (indexPath.row == 7){
        _channelImg.image = [UIImage imageNamed:@"GeneralChannel"];
        _channelNameLabel.text =  @"更多";

    } else {
        
        
        SCFilmClassModel *filmClassModel = array[indexPath.row-1];
        
//        _channelImg.image = [UIImage imageNamed:array[indexPath.row-1]];
        
        NSURL *imgUrl = [NSURL URLWithString:@"http://10.10.5.5:8085/load/file/111.png"];
        [_channelImg sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"Back"]];
        
        if (_channelImg.image == nil) {
            _channelImg.image = [UIImage imageNamed:@"GeneralChannel"];
        }
//        _channelNameLabel.text =  filmClassModel._FilmClassName;

    } 
}

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID;
    ID = @"SCDemandChannelItemCell";
    
    SCDemandChannelItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (cell == nil) cell = [[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil][0];
    return cell;
}
@end
