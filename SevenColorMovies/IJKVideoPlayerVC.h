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

typedef void(^FullScreenLockBlock)(BOOL lock);
typedef void(^WhetherToSupportRotationBlock)(BOOL lock);

@interface IJKVideoPlayerVC : UIViewController

@property (atomic,strong) NSURL *url;
@property (atomic, retain) id<IJKMediaPlayback> player;
@property (nonatomic, assign) BOOL isFullScreen;//是否正处于全屏状态
@property (nonatomic, copy) FullScreenLockBlock fullScreenLockBlock;//全屏锁定的回调
@property (nonatomic, copy) WhetherToSupportRotationBlock supportRotationBlock;//改变父视图是否支持旋转的回调
@property (nonatomic, assign) BOOL isSinglePlayerView;

- (id)initWithURL:(NSURL *)url;
+ (void)presentFromViewController:(UIViewController *)viewController withTitle:(NSString *)title URL:(NSURL *)url completion:(void(^)())completion;
+ (instancetype)initIJKPlayerWithURL:(NSURL *)url;
-(void)closePlayer;/** 关闭播放器 */

- (IBAction)onClickBack:(id)sender;/** 返回 */
- (IBAction)onClickMediaControl:(id)sender;/** 控制面板底层 */
- (IBAction)onClickOverlay:(id)sender;/** 控制面板 */
- (IBAction)onClickPlay:(id)sender;/** 播放&暂停 */
- (IBAction)onClickFullScreenButton:(id)sender;/** 全屏 */

- (IBAction)didSliderTouchDown:(id)sender;/** 进度条 */
- (IBAction)didSliderTouchCancel:(id)sender;
- (IBAction)didSliderTouchUpOutside:(id)sender;
- (IBAction)didSliderTouchUpInside:(id)sender;
- (IBAction)didSliderValueChanged:(id)sender;


@property (strong, nonatomic) IBOutlet IJKMediaControl *mediaControl;






@end
