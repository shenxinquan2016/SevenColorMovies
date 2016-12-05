//
//  DONG_BrightnessView.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/12/5.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  亮度调节时的动画图标

#import <UIKit/UIKit.h>

@interface DONG_BrightnessView : UIView

/** 调用单例记录播放状态是否锁定屏幕方向*/
@property (nonatomic, assign) BOOL     isLockScreen;
/** 是否允许横屏,来控制只有竖屏的状态*/
@property (nonatomic, assign) BOOL     isAllowLandscape;

+ (instancetype)sharedBrightnessView;

@end
