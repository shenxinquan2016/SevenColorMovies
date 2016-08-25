//
//  SCLiveProgramListCell.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/24.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCLiveProgramListCell.h"

@interface SCLiveProgramListCell ()

@property (weak, nonatomic) IBOutlet UILabel *liveProgramTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *liveProgramNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *liveProgramStateLabel;


@end

@implementation SCLiveProgramListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView identifier:(NSString *)identifier indexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"SCLiveProgramListCell";
    
    SCLiveProgramListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (cell == nil) cell = [[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil][0];
    if (indexPath.item == 0) {
        cell.topSeparateline.hidden = NO;
    }else{
        cell.topSeparateline.hidden = YES;
    }
    return cell;
}

- (void)setModel:(SCLiveProgramModel *)model{
    
    _liveProgramTimeLabel.text = model.programTime;
    _liveProgramNameLabel.text = model.programName;
    
    if (model.programState == HavePast) {
        _liveProgramStateLabel.text = @"回看";
    }else if (model.programState == NowPlaying){
        _liveProgramStateLabel.text = @"播放";
    }else if (model.programState == WillPlay){
        _liveProgramStateLabel.text = @"预约";
    }
}

@end
