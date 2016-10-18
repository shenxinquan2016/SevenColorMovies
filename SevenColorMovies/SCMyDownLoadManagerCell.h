//
//  SCMyDownLoadManagerCell.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/10/18.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCFilmModel.h"

typedef void(^DownloadBlock)(void);

@interface SCMyDownLoadManagerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *deleteBtn;
@property (nonatomic, strong) SCFilmModel *filmModel;
@property (nonatomic, copy) DownloadBlock downloadBlock;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
