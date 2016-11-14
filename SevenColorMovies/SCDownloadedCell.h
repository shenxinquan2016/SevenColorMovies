//
//  SCDownloadedCell.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/11/14.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  下载完成时的cell

#import <UIKit/UIKit.h>
#import "ZFDownloadManager.h"

@interface SCDownloadedCell : UITableViewCell

/** 下载信息模型 */
@property (nonatomic, strong) ZFFileModel      *fileInfo;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
