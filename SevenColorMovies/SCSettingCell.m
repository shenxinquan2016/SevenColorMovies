//
//  SCSettingCell.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/2/25.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import "SCSettingCell.h"

@implementation SCSettingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"SCSettingCell";
    SCSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) cell = [[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil][0];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}


@end
