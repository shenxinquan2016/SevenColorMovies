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
    return cell;
}

- (void)setModel:(SCLiveProgramModel *)model{
    
    
    
}

@end
