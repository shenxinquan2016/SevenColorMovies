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
    
    if (indexPath.row == 7) {
        
        _channelImg.image = [UIImage imageNamed:@"GeneralChannel"];
        _channelNameLabel.text =  @"更多";
        
    } else {
        
        NSString *title = array[indexPath.row];
        SCFilmClassModel *filmClassModel = [_filmClassModelDictionary objectForKey:title];
        [_channelImg sd_setImageWithURL:[NSURL URLWithString:filmClassModel._IconUrl] placeholderImage:[UIImage imageNamed:@"GeneralChannel"]];
        _channelNameLabel.text =  title;
    }
}

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath
{
    static NSString *ID;
    ID = @"SCDemandChannelItemCell";
    
    SCDemandChannelItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (cell == nil) cell = [[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil][0];
    return cell;
}

@end
