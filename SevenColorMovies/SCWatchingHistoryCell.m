//
//  SCWatchingHistoryCell.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/10/17.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCWatchingHistoryCell.h"

@interface SCWatchingHistoryCell ()

@property (weak, nonatomic) IBOutlet UILabel *filmNameLabel;/** fiml名称 */
@property (weak, nonatomic) IBOutlet UILabel *filmEpisodeLabel;/** 第几集 */
@property (weak, nonatomic) IBOutlet UILabel *watchTimeLabel;/** 已经观看的时间 */

@end

@implementation SCWatchingHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.deleteBtn.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"SCWatchingHistoryCell";
    SCWatchingHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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

- (void)setWatchHistoryModel:(SCWatchHistoryModel *)watchHistoryModel{
    
    // 名称
    _filmNameLabel.text = watchHistoryModel.title;
    // 第几集
    if ([watchHistoryModel.sid isEqualToString:@"-1"]) {
        _filmEpisodeLabel.text = @"";
    } else if ([watchHistoryModel.sid isEqualToString:@"1"]) {
        _filmEpisodeLabel.text = @"第几集";
    }
    // 已播放
    _watchTimeLabel.text = [NSString stringWithFormat:@"已播放%02ld:%02ld:%02ld", watchHistoryModel.playtime / 3600, (watchHistoryModel.playtime % 3600) / 60, watchHistoryModel.playtime % 60];
    
    
    if (watchHistoryModel.isShowDeleteBtn) {
        _deleteBtn.hidden = NO;
        
        if (watchHistoryModel.isSelecting) {
            [_deleteBtn setImage:[UIImage imageNamed:@"Select"]];
        }else{
            [_deleteBtn setImage:[UIImage imageNamed:@"Unselected"]];
            
        }
        
    }else{
        _deleteBtn.hidden = YES;
    }
}


@end
