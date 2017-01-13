//
//  IJKMediaControl.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/15.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dong_RunLabel.h"

/** 直播时移回调 */
typedef void(^MediaControlTimeShiftBlock)(NSString *liveState, int positionTime);

typedef NS_ENUM(NSInteger, SCLiveState) {
    Original = 0,
    Live, //直播
    TimeShift,//时移
};

@protocol IJKMediaPlayback;

@interface IJKMediaControl : UIControl
@property (weak, nonatomic) IBOutlet UIImageView *advertisementIV;

/** 手势滑动时时移回调 */
@property (nonatomic, copy) MediaControlTimeShiftBlock timeShiftBlock;
/** ijkplayer */
@property (nonatomic, weak) id<IJKMediaPlayback> delegatePlayer;
/** 是否在直播频道 */
@property (nonatomic, assign) BOOL isLive;
/** 直播时状态：直播/时移 */
@property (nonatomic, assign) SCLiveState liveState;
/** 直播/时移 初始化位置及手势移动时位置记录 */
@property (nonatomic, assign) NSTimeInterval firmPosition;
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
- (void)cancelDelayedHide;
- (void)refreshMediaControl;
- (void)refreshMediaControlWhenLive;

- (void)beginDragMediaSlider;
- (void)endDragMediaSlider;
- (void)continueDragMediaSlider;



@end
