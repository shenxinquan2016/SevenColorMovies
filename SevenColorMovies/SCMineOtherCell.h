//
//  SCMineOtherCell.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/25.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  我的cell

#import <UIKit/UIKit.h>

@interface SCMineOtherCell : UITableViewCell

+ (nonnull instancetype)cellWithTableView:(nonnull UITableView *)tableView;

- (void)setModel:(nonnull id)model IndexPath:(nullable NSIndexPath *)indexPath;

@end

