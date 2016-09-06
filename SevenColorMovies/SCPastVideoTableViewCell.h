//
//  SCPastVideoTableViewCell.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/21.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCLiveProgramModel.h"

@interface SCPastVideoTableViewCell : UITableViewCell

@property (nonatomic, strong) SCLiveProgramModel *programModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
