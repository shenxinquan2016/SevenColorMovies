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

/** 控制层 */
@property (weak, nonatomic) IBOutlet UIView *overlayPanel;
/** 底部视图 */
@property (weak, nonatomic) IBOutlet UIView *bottomPanel;
/** 顶部视图 */
@property (weak, nonatomic) IBOutlet UIView *topPanel;
/** 播放的节目名称 */
@property (weak, nonatomic) IBOutlet UILabel *programNameLabel;
/** 返回按钮 */
@property (weak, nonatomic) IBOutlet UIButton *goBackButton;
/** 播放暂停按钮 */
@property (weak, nonatomic) IBOutlet UIButton *playButton;
/** 快进总视图 */
@property (weak, nonatomic) IBOutlet UIView *goFastView;
/** 快件图标 */
@property (weak, nonatomic) IBOutlet UIImageView *goFastImageView;
/** 快进视图当前时间 */
@property (weak, nonatomic) IBOutlet UILabel *currentLabel;
/** 快进视图总时间 */
@property (weak, nonatomic) IBOutlet UILabel *durationTimeLabel;
/** 推屏按钮 */
@property (weak, nonatomic) IBOutlet UIButton *pushScreenButton;
/** 全屏按钮 */
@property (weak, nonatomic) IBOutlet UIButton *fullScreenButton;
/** 进度条当前时间 */
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
/** 进度条总时间 */
@property (weak, nonatomic) IBOutlet UILabel *totalDurationLabel;
/** 进度条 */
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
/** 全屏锁定按钮 */
@property (weak, nonatomic) IBOutlet UIButton *fullScreenLockButton;
/** 播放的节目名称-跑马灯 */
@property (weak, nonatomic) IBOutlet Dong_RunLabel *programNameRunLabel;
/** 播控条总时间label右约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalDurationLabelTrailingSpaceConstraint;

- (void)showNoFade;
- (void)showAndFade;
- (void)hide;
- (void)refreshMediaControl;

- (void)beginDragMediaSlider;
- (void)endDragMediaSlider;
- (void)continueDragMediaSlider;


@end
