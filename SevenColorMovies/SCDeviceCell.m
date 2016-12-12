//
//  SCDeviceCell.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/12/10.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCDeviceCell.h"

@interface SCDeviceCell ()

@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;


@end

@implementation SCDeviceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        [self.selectedImageView setImage:[UIImage imageNamed:@"Select_Device"]];
    } else {
        [self.selectedImageView setImage:[UIImage imageNamed:@"Unselected"]];
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"SCDeviceCell";
    SCDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) cell = [[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil][0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)setDeviceModel:(SCDeviceModel *)deviceModel {

    
}


@end
