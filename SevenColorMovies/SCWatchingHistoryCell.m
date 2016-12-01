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

- (void)setWatchHistoryModel:(SCWatchHistoryModel *)watchHistoryModel
{
    // 名称
    _filmNameLabel.text = watchHistoryModel.title;
    
    // 第几集
    // 私人影院 电影 海外片场
    if ([watchHistoryModel.mtype isEqualToString:@"0"] ||
        [watchHistoryModel.mtype isEqualToString:@"2"] ||
        [watchHistoryModel.mtype isEqualToString:@"13"])
    {
        _filmEpisodeLabel.text = @"";
        
    }else if // 综艺 生活
        ([watchHistoryModel.mtype isEqualToString:@"7"] ||
         [watchHistoryModel.mtype isEqualToString:@"9"])
    {
        _filmEpisodeLabel.text = @"";
        
    }else{
        //电视剧 少儿 少儿剧场 动漫 纪录片 游戏 专题
        _filmEpisodeLabel.text = [NSString stringWithFormat:@"第%@集", watchHistoryModel.sid];
    }
    
    // 已播放时间
    NSInteger palyTime = watchHistoryModel.playtime;
    _watchTimeLabel.text = [NSString stringWithFormat:@"已播放%02ld:%02ld:%02ld", palyTime / 3600, (palyTime % 3600) / 60, palyTime % 60];
    
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
