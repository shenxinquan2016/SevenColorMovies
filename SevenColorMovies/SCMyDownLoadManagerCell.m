//
//  SCMyDownLoadManagerCell.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/10/18.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  下载cell

#import "SCMyDownLoadManagerCell.h"

@interface SCMyDownLoadManagerCell ()

@property (weak, nonatomic) IBOutlet UIButton *downLoadBtn;
@property (weak, nonatomic) IBOutlet UILabel *fimlNameLabel;/** 影片名称 */
@property (weak, nonatomic) IBOutlet UILabel *filmEpisodeLabel;/** 第几集 */
@property (weak, nonatomic) IBOutlet UILabel *downLoadProgressLabel;/** 数字进度 */
@property (weak, nonatomic) IBOutlet UILabel *downLoadStateLabel;/** 下载状态 */
@property (weak, nonatomic) IBOutlet UIProgressView *downLoadProgressView;/** 进度条 */

@end

@implementation SCMyDownLoadManagerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.deleteBtn.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"SCMyDownLoadManagerCell";
    SCMyDownLoadManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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
    _fimlNameLabel.text = filmModel.FilmName;
    
    if (filmModel.isShowDeleteBtn) {
        _deleteBtn.hidden = NO;
        _downLoadBtn.hidden = YES;
        if (filmModel.isSelecting) {
            [_deleteBtn setImage:[UIImage imageNamed:@"Select"]];
        }else{
            [_deleteBtn setImage:[UIImage imageNamed:@"Unselected"]];
            
        }
        
    }else{
        _deleteBtn.hidden = YES;
        _downLoadBtn.hidden = NO;
        
        if (filmModel.isDownLoading) {
            [_downLoadBtn setImage:[UIImage imageNamed:@"PauseDownload"] forState:UIControlStateNormal];
        }else{
            [_downLoadBtn setImage:[UIImage imageNamed:@"DownLoadIMG"] forState:UIControlStateNormal];
            
        }
        
    }
}

- (IBAction)startOrPauseDownLoad:(UIButton *)sender {
    if (self.downloadBlock) {
        self.downloadBlock();

    }
    
//    self.filmModel.isDownLoading = YES;
//    DONG_Log(@"_filmModel.isDownLoading:%d",self.filmModel.isDownLoading);
    
//    _filmModel.isDownLoading = !_filmModel.isDownLoading;
//    
//    
//    DONG_Log(@"_filmModel.isDownLoading:%d",_filmModel.isDownLoading);
    
    
}

@end
