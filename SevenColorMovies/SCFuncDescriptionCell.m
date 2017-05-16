//
//  SCFuncDescriptionCell.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/5/16.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import "SCFuncDescriptionCell.h"

@implementation SCFuncDescriptionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
  
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"SCFuncDescriptionCell";
    SCFuncDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) cell = [[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil][0];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

@end
