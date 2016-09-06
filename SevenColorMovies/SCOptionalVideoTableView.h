//
//  SCSearchTableViewController.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/21.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CallBack)(id obj);//回传值block

@interface SCOptionalVideoTableView : UITableViewController

+ (instancetype)initTableViewWithIdentifier:(NSString *)tag;

- (void)getVODSearchResultDataWithFilmName:(NSString *)keyword Page:(NSInteger)pageNumber CallBack:(CallBack)callBack;

@end
