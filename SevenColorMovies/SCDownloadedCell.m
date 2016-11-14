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
    self.filmNameLabel.text = fileInfo.fileName;
    
    
}

@end
