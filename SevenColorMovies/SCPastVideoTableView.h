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

- (void)getProgramHavePastSearchResultWithFilmName:(NSString *)keyword StartTime:(NSString *)startTime EndTime:(NSString *)endTime Page:(NSInteger)pageNumbe CallBack:(CallBack)callBack;

@end
