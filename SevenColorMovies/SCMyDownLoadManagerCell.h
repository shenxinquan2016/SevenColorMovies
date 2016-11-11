//
//  SCMyDownLoadManagerCell.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/10/18.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  下载cell

#import <UIKit/UIKit.h>
#import "SCFilmModel.h"
#import "ZFDownloadManager.h"

@class Dong_DownloadModel;


typedef void(^DownloadBlock)(void);

@interface SCMyDownLoadManagerCell : UITableViewCell

@property (nonatomic, strong) Dong_DownloadModel *downloadModel;

@property (weak, nonatomic) IBOutlet UIImageView *deleteBtn;
@property (nonatomic, strong) SCFilmModel *filmModel;
@property (nonatomic, copy) DownloadBlock downloadBlock;
/** 下载信息模型 */
@property (nonatomic, strong) ZFFileModel      *fileInfo;
/** 该文件发起的请求 */
@property (nonatomic,retain ) ZFHttpRequest    *request;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
