//
//  SCDiscoveryTableViewCell.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/25.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCDiscoveryCellModel.h"


@interface SCDiscoveryTableViewCell : UITableViewCell

@property (nonatomic, strong) SCDiscoveryCellModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
