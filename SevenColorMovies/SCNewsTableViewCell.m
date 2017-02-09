//
//  SCNewsTableViewCell.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/2/9.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import "SCNewsTableViewCell.h"

@implementation SCNewsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"SCNewsTableViewCell";
    SCNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) cell = [[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil][0];
    cell.backgroundColor = [UIColor whiteColor];
    
    
    return cell;
}

- (void)setModel:(nonnull id)model IndexPath:(nullable NSIndexPath *)indexPath{
    
    
}


@end
