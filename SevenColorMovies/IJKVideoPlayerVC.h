//
//  IJKMoviePlayerVC.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/15.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  IJKPlayer控制器

#import <UIKit/UIKit.h>
#import <IJKMediaFramework/IJKMediaFramework.h>

@class IJKMediaControl;

typedef void(^FullScreenLockBlock)(BOOL lock); // 全屏锁定btn点击回调
typedef void(^WhetherToSupportRotationBlock)(BOOL lock); // 改变父视图是否支持旋转回调
typedef void(^AddWatchHistoryBlock)(void); // 添加观看记录回调
typedef void(^PushScreenBlock)(void); // 推屏回调
typedef void(^TimeShiftBlock)(NSString *liveState, int positionTime); // 直播时移回调

@interface IJKVideoPlayerVC : UIViewController

@property (atomic, strong) NSURL *url;
@property (atomic, retain) id<IJKMediaPlayback> player; // 播放器实体
@property (nonatomic, assign) BOOL isFullScreen; // 是否正处于全屏状态
@property (nonatomic, copy) FullScreenLockBlock fullScreenLockBlock; // 全屏锁定的回调
@property (nonatomic, copy) WhetherToSupportRotationBlock supportRotationBlock; // 改变父视图是否支持旋转的回调
@property (nonatomic, copy) AddWatchHistoryBlock addWatchHistoryBlock; // 返回时添加观看记录回调
@property (nonatomic, copy) PushScreenBlock pushScreenBlock; // 推屏回调
@property (nonatomic, copy) TimeShiftBlock timeShiftBlock; // 拖动进度条回调
@property (nonatomic, assign) BOOL isSinglePlayerView; // 标记是否是单独播放器页面
@property (strong, nonatomic) IBOutlet IJKMediaControl *mediaControl;
@property (nonatomic, assign) BOOL isFeiPing; // 是否是飞屏（用于控制播放器返回动作）

- (id)initWithURL:(NSURL *)url;
+ (void)presentFromViewController:(UIViewController *)viewController withTitle:(NSString *)title URL:(NSURL *)url completion:(void(^)())completion;
+ (instancetype)initIJKPlayerWithURL:(NSURL *)url;

/** 暂停 */
-(void)pause;
/** 播放 */
-(void)play;
/** 关闭播放器 */
-(void)closePlayer;

/** 返回 */
- (IBAction)onClickBack:(id)sender;
/** 控制面板底层 */
- (IBAction)onClickMediaControl:(id)sender;
/** 控制面板 */
- (IBAction)onClickOverlay:(id)sender;
/** 播放&暂停 */
- (IBAction)onClickPlay:(id)sender;
/** 全屏 */
- (IBAction)onClickFullScreenButton:(id)sender;
/** 播控进度条 */
- (IBAction)didSliderTouchDown:(id)sender;
- (IBAction)didSliderTouchCancel:(id)sender;
- (IBAction)didSliderTouchUpOutside:(id)sender;
- (IBAction)didSliderTouchUpInside:(id)sender;
- (IBAction)didSliderValueChanged:(id)sender;

@end
