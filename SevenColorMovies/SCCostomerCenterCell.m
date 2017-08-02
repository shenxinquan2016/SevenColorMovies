//
//  SCCostomerCenterCell.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/8/1.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import "SCCostomerCenterCell.h"

@interface SCCostomerCenterCell ()

@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation SCCostomerCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"SCCostomerCenterCell";
    SCCostomerCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) cell = [[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil][0];
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

- (void)setModel:(nonnull id)model IndexPath:(nullable NSIndexPath *)indexPath
{
    if (model && [model isKindOfClass:[NSArray class]]) {
        NSArray *dataArray = (NSArray *)model;
        NSDictionary *dict = [dataArray objectAtIndex:indexPath.row];
        [_leftImageView setImage:[UIImage imageNamed:dict.allKeys.firstObject]];
        _titleLabel.text = [dict objectForKey:dict.allKeys.firstObject];
    }
}

@end
