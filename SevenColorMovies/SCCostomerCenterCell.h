//
//  SCCostomerCenterCell.h
//  SevenColorMovies
//
//  Created by yesdgq on 2017/8/1.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCCostomerCenterCell : UITableViewCell

+ (instancetype _Nullable )cellWithTableView:(UITableView *_Nullable)tableView;

- (void)setModel:(nonnull id)model IndexPath:(nullable NSIndexPath *)indexPath;

@end
