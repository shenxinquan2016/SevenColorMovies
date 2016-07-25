//
//  SCDiscoveryTableViewCell.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/25.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCDiscoveryTableViewCell.h"


@interface SCDiscoveryTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *leftImg;

@property (weak, nonatomic) IBOutlet UILabel *titileLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLine;

@end

@implementation SCDiscoveryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"SCDiscoveryTableViewCell";
    SCDiscoveryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) cell = [[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil][0];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)setModel:(SCDiscoveryCellModel *)model{
    [_leftImg setImage:[UIImage imageNamed:model.leftImg]];
    _titileLabel.text = model.title;
    _bottomLine.hidden = model.isShowBottmLine;
    
    
    
    
}
@end
