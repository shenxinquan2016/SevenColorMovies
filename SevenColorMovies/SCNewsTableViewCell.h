//
//  SCNewsTableViewCell.h
//  SevenColorMovies
//
//  Created by yesdgq on 2017/2/9.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCNewsMenuModel.h"

@interface SCNewsTableViewCell : UITableViewCell

@property (nonatomic, strong) SCNewsMenuModel *menuModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
