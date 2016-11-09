//
//  SCMyDownLoadManagerCell.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/10/18.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  下载cell

#import <UIKit/UIKit.h>
#import "SCFilmModel.h"

@class Dong_DownloadModel;

typedef void(^DownloadBlock)(void);

@interface SCMyDownLoadManagerCell : UITableViewCell

@property (nonatomic, strong) Dong_DownloadModel *downloadModel;

@property (weak, nonatomic) IBOutlet UIImageView *deleteBtn;
@property (nonatomic, strong) SCFilmModel *filmModel;
@property (nonatomic, copy) DownloadBlock downloadBlock;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
