//
//  SCWatchingHistoryCell.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/10/17.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCFilmModel.h"
#import "SCWatchHistoryModel.h"

@interface SCWatchingHistoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *deleteBtn;
@property (nonatomic, strong) SCWatchHistoryModel *watchHistoryModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
