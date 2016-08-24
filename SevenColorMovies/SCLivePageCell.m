//
//  SCLivePageCell.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/22.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCLivePageCell.h"

@interface SCLivePageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *channelImageView;
@property (weak, nonatomic) IBOutlet UILabel *nowPlayingLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextPlayingLabel;

@end

@implementation SCLivePageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView identifier:(NSString *)identifier indexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"SCLivePageCell";
    
    SCLivePageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (cell == nil) cell = [[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil][0];
    return cell;
}

- (void)setFilmModel:(SCFilmModel *)filmModel{
    
    [_channelImageView sd_setImageWithURL:[NSURL URLWithString:filmModel._ImgUrl] placeholderImage:[UIImage imageNamed:@"NoImage"]];
    _nowPlayingLabel.text = [filmModel.nowPlaying isBlank] ? @"-" : filmModel.nowPlaying;
    _nextPlayingLabel.text = [filmModel.nextPlay isBlank] ? @"-" : filmModel.nextPlay;
    
}

@end
