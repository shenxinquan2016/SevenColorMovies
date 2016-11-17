//
//  SCDownloadedCell.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/11/14.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  下载完成时的cell

#import "SCDownloadedCell.h"

@interface SCDownloadedCell ()

@property (weak, nonatomic) IBOutlet UILabel *filmNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrowImageView;
@property (weak, nonatomic) IBOutlet UIImageView *deleteImageView;
@property (weak, nonatomic) IBOutlet UIImageView *playImageView;

@end


@implementation SCDownloadedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"SCDownloadedCell";
    SCDownloadedCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) cell = [[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil][0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithHex:@"f3f3f3"];
    return cell;
}

- (void)setFileInfo:(ZFFileModel *)fileInfo {
    
    _fileInfo = fileInfo;
    if (fileInfo.isShowDeleteBtn) {
        _deleteImageView.hidden = NO;
        _rightArrowImageView.hidden = YES;
        _playImageView.hidden = YES;
        if (fileInfo.isSelecting) {
            [_deleteImageView setImage:[UIImage imageNamed:@"Select"]];
        }else{
            [_deleteImageView setImage:[UIImage imageNamed:@"Unselected"]];
        }
    }else{
        _deleteImageView.hidden = YES;
        _rightArrowImageView.hidden = NO;
        _playImageView.hidden = NO;
    }
    self.filmNameLabel.text = fileInfo.fileName;
}

@end
