//
//  SCNewsTableViewCell.h
//  SevenColorMovies
//
//  Created by yesdgq on 2017/2/9.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCNewsTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setModel:(nonnull id)model IndexPath:(nullable NSIndexPath *)indexPath;

@end
