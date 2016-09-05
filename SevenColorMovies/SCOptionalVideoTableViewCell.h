//
//  SCOptionalVideoTableViewCell.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/21.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCFilmModel.h"

@interface SCOptionalVideoTableViewCell : UITableViewCell

@property (nonatomic, strong) SCFilmModel *filmModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
