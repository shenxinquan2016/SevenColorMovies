//
//  SCLivePlayerVC.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/24.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  直播播放页控制器

#import <UIKit/UIKit.h>
#import "SCFilmModel.h"


@interface SCLivePlayerVC : UIViewController

@property (nonatomic, strong) SCFilmModel *filmModel;
/** 频道名称label */
@property (weak, nonatomic) IBOutlet UILabel *channelNameLabel;
/** 直播/时移状态 拉屏时判断进入直播还是时移 */
@property (nonatomic, assign) SCLiveState liveState;
/** 时移拉屏时当前播放时间 */
@property (nonatomic, copy) NSString *currentPlayTime;

@end
