//
//  SCProgramListCell.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/10/14.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCFilmModel.h"

@interface SCProgramListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *deleteBtn;
@property (nonatomic, strong) SCFilmModel *filmModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
