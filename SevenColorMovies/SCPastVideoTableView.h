//
//  SCPastVideoTableView.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/21.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CallBack)(id obj);//回传值block

@interface SCPastVideoTableView : UITableViewController

- (void)getSearchResultAndChannelLogoWithFilmName:(NSString *)keyword Page:(NSInteger)pageNumbe CallBack:(CallBack)callBack;

- (void)getProgramHavePastSearchResultWithFilmName:(NSString *)keyword  Page:(NSInteger)pageNumbe CallBack:(CallBack)callBack;

@end
