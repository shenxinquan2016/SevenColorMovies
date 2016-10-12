//
//  SCPastVideoTableView.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/21.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  回看筛选

#import <UIKit/UIKit.h>

typedef void(^CallBack)(id obj);//回传值block

@interface SCPastVideoTableView : UITableViewController

@property (nonatomic, strong) NSMutableArray *dataSource;/** tableView数据数组 */
@property (nonatomic, assign) NSInteger page;/** 分页标签 */

- (void)getSearchResultAndChannelLogoWithFilmName:(NSString *)keyword Page:(NSInteger)pageNumber CallBack:(CallBack)callBack;

- (void)getProgramHavePastSearchResultWithFilmName:(NSString *)keyword  Page:(NSInteger)pageNumber CallBack:(CallBack)callBack;

@end
