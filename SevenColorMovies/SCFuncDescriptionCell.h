//
//  SCFuncDescriptionCell.h
//  SevenColorMovies
//
//  Created by yesdgq on 2017/5/16.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCFuncDescriptionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *contentIV;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
