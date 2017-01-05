//
//  SCChangeBrightnessAndVolumeTool.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/18.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  手势调节声音 & 屏幕亮度 & 播放器播放进度

#import <Foundation/Foundation.h>
#import "IJKMediaControl.h"//播控面板

/** 直播时移回调 */
typedef void(^TouchMovedTimeShiftBlock)(NSString *liveState);

// 枚举值，包含水平移动方向和垂直移动方向
typedef NS_ENUM(NSInteger, PanDirection){
    PanDirectionHorizontalMoved,//水平移动
    PanDirectionVerticalMoved//垂直移动
};

@interface SCChangeBrightnessAndVolumeTool : NSObject

@property (nonatomic, strong) UIView *panView;
/** 用来保存快进的总时长 */
@property (nonatomic, assign) CGFloat sumTime;
@property (nonatomic, strong) IJKMediaControl *mediaControlView;
@property (nonatomic, copy) TouchMovedTimeShiftBlock touchMovedTimeShiftBlock;

- (void)setVolumeView:(IJKMediaControl *)vc;
- (void)panDirection:(UIPanGestureRecognizer *)pan;

@end
