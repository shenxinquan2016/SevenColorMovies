//
//  SCSearchTableViewController.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/21.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCOptionalVideoTableView : UITableViewController

@property (nonatomic, strong) NSMutableArray *dataSource;

+ (instancetype)initTableViewWithIdentifier:(NSString *)tag;

@end
