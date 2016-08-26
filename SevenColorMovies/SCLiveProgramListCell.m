//
//  SCLiveProgramListCell.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/24.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCLiveProgramListCell.h"

@interface SCLiveProgramListCell ()




@end

@implementation SCLiveProgramListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    self.selectedBackgroundView = [[UIView alloc]initWithFrame:self.frame];
//    self.selectedBackgroundView.backgroundColor = [UIColor cyanColor];
    
}

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView identifier:(NSString *)identifier indexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"SCLiveProgramListCell";
    
    SCLiveProgramListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (cell == nil) cell = [[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil][0];
    cell.backgroundColor = [UIColor whiteColor];
    //蓝色
    
    
    return cell;
}

- (void)setModel:(SCLiveProgramModel *)model{
    
    _liveProgramTimeLabel.text = model.programTime;
    _liveProgramNameLabel.text = model.programName;
    
    if (model.programState == HavePast) {
        _liveProgramStateLabel.text = @"回看";
        //此处若不设置label的默认颜色，cell复用时label的颜色会混乱
        _liveProgramTimeLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _liveProgramNameLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _liveProgramStateLabel.textColor = [UIColor colorWithHex:@"#333333"];

    }else if (model.programState == NowPlaying){
        _liveProgramStateLabel.text = @"播放";
        _liveProgramTimeLabel.textColor = [UIColor colorWithHex:@"#78A1FF"];
        _liveProgramNameLabel.textColor = [UIColor colorWithHex:@"#78A1FF"];
        _liveProgramStateLabel.textColor = [UIColor colorWithHex:@"#78A1FF"];
        
    }else if (model.programState == WillPlay){
        _liveProgramStateLabel.text = @"预约";
        //此处若不设置label颜色，cell复用是label的颜色会混乱
        _liveProgramTimeLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _liveProgramNameLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _liveProgramStateLabel.textColor = [UIColor colorWithHex:@"#333333"];

    }
}

@end
