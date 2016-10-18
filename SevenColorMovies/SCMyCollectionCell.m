//
//  SCMyCollectionCell.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/10/18.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCMyCollectionCell.h"

@implementation SCMyCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.deleteBtn.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"SCMyCollectionCell";
    SCMyCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) cell = [[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil][0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithHex:@"f3f3f3"];
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

- (void)setFilmModel:(SCFilmModel *)filmModel{
    if (filmModel.isShowDeleteBtn) {
        _deleteBtn.hidden = NO;
        
        if (filmModel.isSelecting) {
            [_deleteBtn setImage:[UIImage imageNamed:@"OK"]];
        }else{
            [_deleteBtn setImage:[UIImage imageNamed:@"RemoteControl"]];
            
        }
        
    }else{
        _deleteBtn.hidden = YES;
    }
}

@end
