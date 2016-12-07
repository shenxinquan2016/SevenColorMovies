//
//  IJKMediaControl.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/15.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dong_RunLabel.h"
@protocol IJKMediaPlayback;

@interface IJKMediaControl : UIControl

@property(nonatomic,weak) id<IJKMediaPlayback> delegatePlayer;

@property (weak, nonatomic) IBOutlet UIView *overlayPanel;//控制层
@property (weak, nonatomic) IBOutlet UIView *bottomPanel;//底部视图
@property (weak, nonatomic) IBOutlet UIView *topPanel;//顶部视图
@property (weak, nonatomic) IBOutlet UILabel *programNameLabel;//播放的节目名称
@property (weak, nonatomic) IBOutlet UIButton *goBackButton;//返回按钮

@property (weak, nonatomic) IBOutlet UIButton *playButton;//播放暂停按钮

@property (weak, nonatomic) IBOutlet UIView *goFastView;//快进总视图
@property (weak, nonatomic) IBOutlet UIImageView *goFastImageView;//快件图标
@property (weak, nonatomic) IBOutlet UILabel *currentLabel;//快进视图当前时间
@property (weak, nonatomic) IBOutlet UILabel *durationTimeLabel;//快进视图总时间
@property (weak, nonatomic) IBOutlet UIButton *fullScreenButton;//全屏按钮

@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;//进度条当前时间
@property (weak, nonatomic) IBOutlet UILabel *totalDurationLabel;//进度条总时间
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;//进度条
@property (weak, nonatomic) IBOutlet UIButton *fullScreenLockButton;
@property (weak, nonatomic) IBOutlet Dong_RunLabel *programNameRunLabel;

- (void)showNoFade;
- (void)showAndFade;
- (void)hide;
- (void)refreshMediaControl;

- (void)beginDragMediaSlider;
- (void)endDragMediaSlider;
- (void)continueDragMediaSlider;


@end
