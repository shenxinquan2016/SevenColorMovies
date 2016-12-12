//
//  SCDeviceCell.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/12/10.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCDeviceModel.h"

@interface SCDeviceCell : UITableViewCell

@property (nonatomic, strong) SCDeviceModel *deviceModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
