//
//  SCRankOtherCell.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/20.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCRankOtherCell.h"

@implementation SCRankOtherCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"SCRankOtherCell";
    SCRankOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) cell = [[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil][0];
    
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
        self.frame = frame;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

@end
