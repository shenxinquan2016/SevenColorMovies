//
//  SCMineTopCell.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/25.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCMineTopCell.h"

@interface SCMineTopCell()

@property (weak, nonatomic) IBOutlet UIImageView *leftImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *bottomLine;

@end


@implementation SCMineTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"SCMineTopCell";
    SCMineTopCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) cell = [[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil][0];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

@end
