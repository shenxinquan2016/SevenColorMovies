//
//  SCMyCollectionCell.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/10/18.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCMyCollectionCell.h"

@interface SCMyCollectionCell ()

@property (weak, nonatomic) IBOutlet UILabel *filmNameLabel;/** 影片名称 */
@property (weak, nonatomic) IBOutlet UILabel *filmEpisodeLabel;/** 第几集 */

@end

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
    
    // 名称
    _filmNameLabel.text = filmModel.FilmName;
    // 第几集
    if (filmModel.filmSetModel) {
        _filmEpisodeLabel.text = filmModel.filmSetModel._ContentIndex;
    }
    // 通过filmModel的属性变化改变对应的视图UI更新
    if (filmModel.isShowDeleteBtn) {
        _deleteBtn.hidden = NO;
        
        if (filmModel.isSelecting) {
            [_deleteBtn setImage:[UIImage imageNamed:@"Select"]];
        }else{
            [_deleteBtn setImage:[UIImage imageNamed:@"Unselected"]];
            
        }
        
    }else{
        _deleteBtn.hidden = YES;
    }
}

@end
