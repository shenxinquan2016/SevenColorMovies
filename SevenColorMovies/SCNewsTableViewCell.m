//
//  SCNewsTableViewCell.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/2/9.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import "SCNewsTableViewCell.h"

@interface SCNewsTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

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

- (void)setMenuModel:(SCNewsMenuModel *)menuModel
{
    _nameLabel.text = menuModel.name;
    //NSURL *imgUrl = [NSURL URLWithString:menuModel.icon];
    NSURL *imgUrl = [NSURL URLWithString:@"http://10.10.5.5:8085/load/file/111.png"];
    
    [_iconImage sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"Back"]];
}

@end
