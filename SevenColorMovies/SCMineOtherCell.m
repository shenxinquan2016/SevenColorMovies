//
//  SCMineOtherCell.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/25.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCMineOtherCell.h"

@interface SCMineOtherCell ()

@property (weak, nonatomic) IBOutlet UIImageView *leftImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLine;

@end


@implementation SCMineOtherCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"SCMineOtherCell";
    SCMineOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) cell = [[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil][0];
    cell.backgroundColor = [UIColor whiteColor];
    cell.bottomLine.hidden = YES;
    
    return cell;
}

- (void)setModel:(nonnull id)model IndexPath:(nullable NSIndexPath *)indexPath{
    
    if (model && [model isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)model;
        NSString *keyStr = [dict.allKeys objectAtIndex:0];
        
        _leftImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",keyStr]];
        _titleLabel.text =  [dict.allValues objectAtIndex:0];

        if (indexPath.section == 0 && (indexPath.row == 0 || indexPath.row == 1)) {
            _bottomLine.hidden = NO;
        }
    }
    
}

@end
