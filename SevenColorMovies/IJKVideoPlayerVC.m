//
//  IJKVideoPlayerVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/15.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  IJKPlayer控制器

#import "IJKVideoPlayerVC.h"
#import "IJKMediaControl.h"
#import "PlayerViewRotate.h"//横竖屏强制转换
#import "SCVideoLoadingView.h"
#import "SCChannelCategoryVC.h"
#import "SCFilterViewController.h"
#import "SCSearchViewController.h"
#import "SCFilterViewController.h"
#import "SCMyProgramListVC.h"
#import "SCLiveViewController.h"
#import "SCMyCollectionVC.h"
#import "SCMyDownloadManagerVC.h"
#import "SCMyWatchingHistoryVC.h"
#import "SCRemoteControlVC.h"
#import "SCXMPPManager.h"

@interface IJKVideoPlayerVC ()

@property (nonatomic, assign) BOOL isLockFullScreen;

@end

@implementation IJKVideoPlayerVC

{
    UIInterfaceOrientation _lastOrientaion;
    SCVideoLoadingView *_loadView;
    NSTimeInterval _touchBeginTime;
    NSTimeInterval _touchEndTime;
}

#pragma mark- Initialize

+ (void)presentFromViewController:(UIViewController *)viewController withTitle:(NSString *)title URL:(NSURL *)url completion:(void (^)())completion {
    
    [viewController presentViewController:[[IJKVideoPlayerVC alloc] initWithURL:url] animated:YES completion:completion];
}

+ (instancetype)initIJKPlayerWithURL:(NSURL *)url{
    IJKVideoPlayerVC *IJKPlayer = [[IJKVideoPlayerVC alloc] initWithURL:url];
    
    return IJKPlayer;
}

- (instancetype)initWithURL:(NSURL *)url{
    self = [self initWithNibName:@"IJKVideoPlayerVC" bundle:nil];
    if (self) {
        self.url = url;
    }
    return self;
}


#pragma mark-  ViewLife Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //对UIViewAutoresizingNone进行清空，否则从xib加载View时显示出来的效果不一样(比如尺寸变大了)，autoresizingMask自动伸缩属性在搞鬼!
    self.view.autoresizingMask = UIViewAutoresizingNone;
    
    self.isFullScreen = NO;
    
    //1.初始化播放器
    [self setupIJKPlayer];
    
    //2.本应写在viewWillAppear中，但viewWillAppear不被执行
    [self installMovieNotificationObservers];
    
    [self.player prepareToPlay];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.player shutdown];
    [self removeMovieNotificationObservers];
    //注销全屏通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:SwitchToFullScreen object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:SwitchToSmallScreen object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    
}

//xib的awakeFromNib方法中设置UIViewAutoresizingNone进行清空
- (void)awakeFromNib {
    [super awakeFromNib];
    
}


#pragma mark - 初始化播放器

- (void) setupIJKPlayer
{
    // 1.根据当前环境设置日志信息
    // 1.1如果是Debug状态的
#ifdef DEBUG
    // 设置报告日志
    [IJKFFMoviePlayerController setLogReport:YES];
    //  设置日志的级别为Debug
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_DEBUG];
    // 1.2否则(如果不是debug状态的)
#else
    // 设置不报告日志
    [IJKFFMoviePlayerController setLogReport:NO];
    // 设置日志级别为信息
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_INFO];
#endif
    
    // 后加，还不知道有什么作用
    [IJKMediaModule sharedModule].appIdleTimerDisabled = YES;
    
    // 2.检查版本是否匹配
    [IJKFFMoviePlayerController checkIfFFmpegVersionMatch:YES];
    // [IJKFFMoviePlayerController checkIfPlayerVersionMatch:YES major:1 minor:0 micro:0];
    
    // 3.创建IJKFFMoviePlayerController
    // 3.1 默认选项配置
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    
    [options setPlayerOptionIntValue:1 forKey:@"videotoolbox"];// 开启硬解码
    // 3.2 创建播放控制器
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:self.url withOptions:options];
    
    // 4.屏幕适配
    // 4.1 设置播放视频视图的frame与控制器的View的bounds一致
    self.player.view.frame = self.view.bounds;
    // 4.2 设置适配横竖屏(设置四边固定,长宽灵活)
    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    // 4.3 设置播放视图的缩放模式
    self.player.scalingMode = IJKMPMovieScalingModeAspectFit;
    // 4.4 设置自动播放
    self.player.shouldAutoplay = YES;
    // 4.5 自动更新子视图的大小
    self.view.autoresizesSubviews = YES;
    //  4.6 添加播放视图到控制器的View
    [self.view addSubview:self.player.view];
    
    // 5.添加播放控件到控制器的View
    [self.player.view addSubview:self.mediaControl];
    self.mediaControl.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenWidth * 9 / 16);
    // 5.1 代理设置
    self.mediaControl.delegatePlayer = self.player;
    // 5.2 手势滑动时进入时移的回调
    DONG_WeakSelf(self);
    self.mediaControl.timeShiftBlock = ^(NSString *liveState, int positionTime) {
        if (weakself.timeShiftBlock) {
            weakself.timeShiftBlock(liveState, positionTime);
        }
    };
    
    // 6.添加加载视频时进度动画
    _loadView = [[NSBundle mainBundle] loadNibNamed:@"SCVideoLoadingView" owner:nil options:nil][0];
    //_loadView.backgroundColor = [UIColor colorWithHex:@"#000000" alpha:0.4];
    _loadView.backgroundColor = [UIColor clearColor];
    _loadView.frame = CGRectMake(0, 0, 64, 64);
    // 6.1 开始动画
    [_loadView startAnimating];
    [self.view addSubview:_loadView];
    [_loadView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(64, 64));
        
    }];
    
}

/** 暂停 */
-(void)pause
{
    if (self.player) {
        if ([self.player isPlaying]) {
            [self.player pause];
        }
    }
    
}

/** 播放 */
-(void)play
{
    if (self.player) {
        if (![self.player isPlaying]) {
            [self.player play];
        }
    }
    
}

-(void)closePlayer
{
    if (self.player) {
        // 先关闭播放代理
        libagent_finish();
        [self.player shutdown];
        [self.player.view removeFromSuperview];
        [self.mediaControl removeFromSuperview];
        [_loadView removeFromSuperview];
        [self.view removeFromSuperview];
        _player = nil;
    }
}

#pragma mark - IBAction

/** 控制面板底层 */
- (IBAction)onClickMediaControl:(id)sender
{
    [self.mediaControl showAndFade];
}

/** 控制面板 */
- (IBAction)onClickOverlay:(id)sender
{
    [self.mediaControl hide];
}

/** 返回 */
- (IBAction)onClickBack:(id)sender
{
    // 1.返回时添加观看记录
    if (self.addWatchHistoryBlock) {
        self.addWatchHistoryBlock();
    }
    
    // 2.如果是单独的播放器窗口(比如从我的下载、我的收藏等进入播放)，需要单独处理返回事物
    if (self.isSinglePlayerView) {
        // 先回调使父视图支持旋转才能旋转
        if (self.supportRotationBlock) {
            self.supportRotationBlock(NO);
        }
        
        self.isFullScreen = NO;
        [PlayerViewRotate forceOrientation:UIInterfaceOrientationPortrait];
        
        // 取出当前的导航控制器
        UITabBarController *tabBarVC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        // 当前选择的导航控制器
        UINavigationController *navController = (UINavigationController *)tabBarVC.selectedViewController;
        // pop到指定页面
        // 因为是出栈，所以要倒叙遍历navController.viewControllers 从栈顶到栈底遍历
        
        if (_isFeiPing) {
            // 如果是飞屏 直接返回到根目录
            [navController popViewControllerAnimated:NO];
        }
        
        for (int i = 0; i < navController.viewControllers.count ; i++) {
            unsigned long index = navController.viewControllers.count - i;
            UIViewController* controller = navController.viewControllers[index-1];
            
            DONG_Log(@"controller:%@", controller);
            
            if ([controller isKindOfClass:[SCMyProgramListVC class]]) {//我的节目单
                
                [navController popToViewController:controller animated:YES];
                return;
                
            } else if ([controller isKindOfClass:[SCMyCollectionVC class]]) {//我的收藏
                
                [navController popToViewController:controller animated:YES];
                return;
                
            } else if ([controller isKindOfClass:[SCMyDownloadManagerVC class]]) {//我的下载
                
                [navController popToViewController:controller animated:YES];
                return;
                
            } else if ([controller isKindOfClass:[SCSearchViewController class]]){//搜索控制器
                
                [navController popToViewController:controller animated:YES];
                return;
                
            } else if ([controller isKindOfClass:[SCRemoteControlVC class]]){//遥控器
                
                [navController popToViewController:controller animated:YES];
                return;
                
            } else if ([controller isKindOfClass:[SCXMPPManager class]]) {
                
                [navController popToViewController:controller animated:YES];
                return;
                
            }
            
        }
        [navController popViewControllerAnimated:YES];
        
    } else {
        
        // 如果正在全屏，先只返回小屏 返回小屏时需要旋转 如果此时处于全屏锁定状态，控制器不支持屏幕旋转，要先回调block使控制器支持屏幕旋转
        self.isLockFullScreen = NO;
        if ([PlayerViewRotate isOrientationLandscape]) {//全屏
            // 解锁fullScreenLock 先回调block使控制器页面支持旋转
            if (self.fullScreenLockBlock) {
                self.fullScreenLockBlock(NO);
            }
            [self.mediaControl.fullScreenLockButton setImage:[UIImage imageNamed:@"FullScreenUnlock"] forState:UIControlStateNormal];
            
            self.isFullScreen = NO;
            [PlayerViewRotate forceOrientation:UIInterfaceOrientationPortrait];
            
        } else {// 小屏
            
            // 取出当前的导航控制器
            UITabBarController *tabBarVC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            // 当前选择的导航控制器
            UINavigationController *navController = (UINavigationController *)tabBarVC.selectedViewController;
            
            // DONG_Log(@"%@",navController.viewControllers);
            
            // pop到指定页面
            // 因为是出栈，所以要倒叙遍历navController.viewControllers 从栈顶到栈底遍历
            for (int i = 0; i < navController.viewControllers.count ; i++) {
                unsigned long index = navController.viewControllers.count - i;
                UIViewController* controller = navController.viewControllers[index-1];
                
                if ([controller isKindOfClass:[SCMyProgramListVC class]]) {//我的节目单
                    
                    [navController popToViewController:controller animated:YES];
                    return;
                    
                } else if ([controller isKindOfClass:[SCMyCollectionVC class]]) {//我的收藏
                    
                    [navController popToViewController:controller animated:YES];
                    return;
                    
                } else if ([controller isKindOfClass:[SCMyDownloadManagerVC class]]) {//我的下载
                    
                    [navController popToViewController:controller animated:YES];
                    return;
                    
                } else if ([controller isKindOfClass:[SCMyWatchingHistoryVC class]]) {//观看记录页
                    
                    [navController popToViewController:controller animated:YES];
                    return;
                    
                } else if ([controller isKindOfClass:[SCRemoteControlVC class]]){//遥控器
                    
                    [navController popToViewController:controller animated:YES];
                    return;
                    
                } else if ([controller isKindOfClass:[SCLiveViewController class]]) {//直播频道列表页
                    
                    [navController popToViewController:controller animated:YES];
                    return;
                    
                } else if ([controller isKindOfClass:[SCFilterViewController class]]) {//筛选
                    
                    [navController popToViewController:controller animated:YES];
                    return;
                    
                } else if ([controller isKindOfClass:[SCChannelCategoryVC class]]){//点播节目频道分类
                    
                    [navController popToViewController:controller animated:YES];
                    return;
                    
                } else if ([controller isKindOfClass:[SCSearchViewController class]]){//搜索控制器
                    
                    [navController popToViewController:controller animated:YES];
                    return;
                }
            }
            
            [navController popToRootViewControllerAnimated:YES];
        }
        
    }
    
}

/** 播放&暂停 */
- (IBAction)onClickPlay:(id)sender
{
    if ([self.player isPlaying]) {
        [self.player pause];
        // 暂停时显示广告层
        self.mediaControl.advertisementIV.hidden = NO;
        [self.mediaControl.playButton setImage:[UIImage imageNamed:@"Play"] forState:UIControlStateNormal];
        [self.mediaControl refreshMediaControl];
        
    } else if (![self.player isPlaying]){
        [self.player play];
        // 播放时隐藏广告层
        self.mediaControl.advertisementIV.hidden = YES;
        [self.mediaControl.playButton setImage:[UIImage imageNamed:@"Pause"] forState:UIControlStateNormal];
        [self.mediaControl refreshMediaControl];
        
    }
}

/** 全屏 */
- (IBAction)onClickFullScreenButton:(id)sender
{
    //全屏锁定时控制器不支持屏幕旋转 如需旋转，要先使控制器支持屏幕旋转
    if ([PlayerViewRotate isOrientationLandscape]) {//全屏
        self.isLockFullScreen = NO;
        //解锁fullScreenLock 先回调block使控制器页面支持旋转
        if (self.fullScreenLockBlock) {
            self.fullScreenLockBlock(NO);
        }
        [self.mediaControl.fullScreenLockButton setImage:[UIImage imageNamed:@"FullScreenUnlock"] forState:UIControlStateNormal];
        
        self.isFullScreen = NO;
        [PlayerViewRotate forceOrientation:UIInterfaceOrientationPortrait];
        
    }else {
        
        self.isFullScreen = YES;
        [PlayerViewRotate forceOrientation:UIInterfaceOrientationLandscapeRight];
        
    }
}

/** 进度条 */
- (IBAction)didSliderTouchDown:(id)sender
{
    // 2
    _touchBeginTime = self.mediaControl.progressSlider.value;
    
    [self.mediaControl beginDragMediaSlider];
}

- (IBAction)didSliderTouchCancel:(id)sender
{
    [self.mediaControl endDragMediaSlider];
    [self.mediaControl showAndFade];
}

- (IBAction)didSliderTouchUpOutside:(id)sender
{
    [self.mediaControl endDragMediaSlider];
    [self.mediaControl showAndFade];
}

- (IBAction)didSliderTouchUpInside:(id)sender
{
    // 4
    // player.currentPlaybackTime 和 progressSlider.value 的值都为秒（S）
    self.player.currentPlaybackTime = self.mediaControl.progressSlider.value;
    [self.mediaControl endDragMediaSlider];
    [self.mediaControl showAndFade];
    
    DONG_WeakSelf(self);
    if (_mediaControl.isLive) {
        NSInteger duration = 6 * 3600;
        NSInteger minus = duration - _touchEndTime;
        if (minus > 5) {
            // 进入时移
            NSString *liveState = @"timeShift";
            if (weakself.timeShiftBlock) {
                weakself.timeShiftBlock(liveState, _touchEndTime);
            }
            
        } else {
            // 进入直播
            NSString *liveState = @"live";
            if (weakself.timeShiftBlock) {
                weakself.timeShiftBlock(liveState, _touchEndTime);
            }
        }
        DONG_Log(@"minus:%ld",(long)minus);
    }
    
}

- (IBAction)didSliderValueChanged:(id)sender
{
    // 1  3
    _touchEndTime = self.mediaControl.progressSlider.value;
    [self.mediaControl cancelDelayedHide];
    [self.mediaControl continueDragMediaSlider];
    
}

/** 全屏锁定 */
- (IBAction)fullScreenLock:(id)sender
{
    //通过block回调，通知父视图支持旋转与否来实现锁定全屏的功能
    if (!self.isLockFullScreen) {
        //do锁定
        self.isLockFullScreen = YES;
        [self.mediaControl.fullScreenLockButton setImage:[UIImage imageNamed:@"FullScreenLock"] forState:UIControlStateNormal];
        //♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫
        if (self.fullScreenLockBlock) {
            self.fullScreenLockBlock(YES);
        }
        
    } else {
        //do解锁
        self.isLockFullScreen = NO;
        [self.mediaControl.fullScreenLockButton setImage:[UIImage imageNamed:@"FullScreenUnlock"] forState:UIControlStateNormal];
        //♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫
        if (self.fullScreenLockBlock) {
            self.fullScreenLockBlock(NO);
        }
    }
}

/** 推屏 */
- (IBAction)pushScreen:(id)sender
{
    if (self.pushScreenBlock) {
        self.pushScreenBlock();
    }
}


#pragma mark - IJK通知响应事件
- (void)loadStateDidChange:(NSNotification*)notification
{
    IJKMPMovieLoadState loadState = _player.loadState;
    
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStatePlaythroughOK: %d\n", (int)loadState);
        //结束加载 取消隐藏播放按钮
        [_loadView endAnimating];
        self.mediaControl.playButton.hidden = NO;
        
    } else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
        //开始加载 隐藏播放按钮
        [_loadView startAnimating];
        self.mediaControl.playButton.hidden = YES;
    } else {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}

- (void)moviePlayBackDidFinish:(NSNotification*)notification
{
    //    MPMovieFinishReasonPlaybackEnded,
    //    MPMovieFinishReasonPlaybackError,
    //    MPMovieFinishReasonUserExited
    int reason = [[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    
    switch (reason)
    {
        case IJKMPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
            
            [self.mediaControl.playButton setImage:[UIImage imageNamed:@"Play"] forState:UIControlStateNormal];
            //当前节目播放结束，播放下一个节目
            break;
            
        case IJKMPMovieFinishReasonUserExited:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
            break;
            
        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification
{
    NSLog(@"mediaIsPreparedToPlayDidChange\n");
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification
{
    //    MPMoviePlaybackStateStopped,
    //    MPMoviePlaybackStatePlaying,
    //    MPMoviePlaybackStatePaused,
    //    MPMoviePlaybackStateInterrupted,
    //    MPMoviePlaybackStateSeekingForward,
    //    MPMoviePlaybackStateSeekingBackward
    
    switch (_player.playbackState)
    {
        case IJKMPMoviePlaybackStateStopped: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStatePlaying: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStatePaused: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
            
            break;
        }
        case IJKMPMoviePlaybackStateInterrupted: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateSeekingForward:
            
        case IJKMPMoviePlaybackStateSeekingBackward: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_player.playbackState);
            break;
        }
        default: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
            break;
        }
    }
}

#pragma mark - Notifications
-(void)installMovieNotificationObservers
{
    //加载状态改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_player];
    //播放结束通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
    //第一次加载成功准备播放
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_player];
    //播放状态改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];
}

-(void)removeMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerLoadStateDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:_player];
}

#pragma mark - 屏幕旋转  该段代码该工程不使用
- (void)prepareForFullScreen {
    
    [_player setScalingMode:IJKMPMovieScalingModeAspectFit];
    
    self.view.frame = [[UIScreen mainScreen] bounds];
    self.player.view.frame = self.view.bounds;
    self.mediaControl.frame = self.view.bounds;
    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth & UIViewAutoresizingFlexibleHeight;
    self.mediaControl.autoresizingMask = UIViewAutoresizingFlexibleWidth & UIViewAutoresizingFlexibleHeight;
    
}

- (void)prepareForSmallScreen {
    [_player setScalingMode:IJKMPMovieScalingModeAspectFit];
    self.view.frame = CGRectMake(0, 20, kMainScreenWidth, kMainScreenWidth * 9 / 16);
    self.player.view.frame = self.view.bounds;
    self.mediaControl.frame = self.view.bounds;
}


@end
