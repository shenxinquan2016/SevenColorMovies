//
//  SCDemandVideoCell.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/19.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCDemandChannelItemCell.h"

@implementation SCDemandChannelItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    [self.channelImage zy_cornerRadiusRoundingRect];
    [_channelImage setImage:[UIImage imageNamed:@"BusinessLogo"]];
    _channelName.text = @"电影";
}



//- (void)setModel:(GeniusManModel *)model {
//    _model = model;
//
//    if (model) {
//        //1.1头像
//
//
//        //        NSLog(@"1111111 == %@",model.avatar);
//
//        [IMB_DownImageHelper downImageWithURL:[NSURL URLWithString:model.avatar] imageView:self.imageView placeHolder:TL_IMAGE(@"头像未加载出来")];
//        //        NSLog(@"11111 == %@",model.avatar);
//
//        //2.显示不显示V
//        if ([model.isV isEqualToString:@"1"]) {  //显示V
//            self.isVImageView.hidden = NO;
//            if (model.type.integerValue == 0) {
//                self.isVImageView.image = TL_IMAGE(@"黄V");
//            } else {
//                self.isVImageView.image = TL_IMAGE(@"蓝V");
//            }
//        }else if ([model.isV isEqualToString:@"0"]) { //不显示V
//            self.isVImageView.hidden = YES;
//        }
//
//
//        //3.昵称
//        self.nickNameLabel.text = model.nickName;
//        self.nickNameLabel.hidden = NO;
//
//
//
//        //4.近10中x
//        //        NSLog(@"1111111 == %@",model.recentVS);
//        self.winRateLabel.text = [[[[@"" stringByAppendingString:model.recent] stringByAppendingString:@"中"] stringByAppendingString:model.recentVS] stringByAppendingString:@"  "];
//        self.winRateLabel.hidden = NO;
//    }
//
//
//}

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID;
    ID = @"SCDemandChannelItemCell";
    
    SCDemandChannelItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (cell == nil) cell = [[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil][0];
    return cell;
}
@end
