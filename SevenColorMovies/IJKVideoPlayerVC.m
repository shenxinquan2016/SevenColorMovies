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
#import "SCRotatoUtil.h"
#import "SCVideoLoadingView.h"
#import "SCChannelCategoryVC.h"
#import "SCFilterViewController.h"
#import "SCSearchViewController.h"
#import "SCFilterViewController.h"
#import "SCMyProgramListVC.h"
#import "SCLiveViewController.h"
#import "SCMyCollectionVC.h"
#import "SCMyDownloadManagerVC.h"

@interface IJKVideoPlayerVC ()

@end

@implementation IJKVideoPlayerVC

{
    UIInterfaceOrientation _lastOrientaion;
    
    SCVideoLoadingView *_loadView;
    
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
    
    [self.player shutdown];
    [self removeMovieNotificationObservers];
    //注销全屏通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:SwitchToFullScreen object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:SwitchToSmallScreen object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    
}

//xib的awakeFromNib方法中设置UIViewAutoresizingNone进行清空
- (void)awakeFromNib {
    [super awakeFromNib];
    
}


#pragma mark - 初始化播放器

- (void) setupIJKPlayer
{
    //1. 根据当前环境设置日志信息
    //1.1如果是Debug状态的
#ifdef DEBUG
    //  设置报告日志
    [IJKFFMoviePlayerController setLogReport:YES];
    //  设置日志的级别为Debug
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_DEBUG];
    //1.2否则(如果不是debug状态的)
#else
    //  设置不报告日志
    [IJKFFMoviePlayerController setLogReport:NO];
    //  设置日志级别为信息
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_INFO];
#endif
    // 2. 检查版本是否匹配
    [IJKFFMoviePlayerController checkIfFFmpegVersionMatch:YES];
    // [IJKFFMoviePlayerController checkIfPlayerVersionMatch:YES major:1 minor:0 micro:0];
    
    // 3.  创建IJKFFMoviePlayerController
    // 3.1 默认选项配置
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    // 3.2 创建播放控制器
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:self.url withOptions:options];
    
    //4. 屏幕适配
    // 4.1 设置播放视频视图的frame与控制器的View的bounds一致
    self.player.view.frame = self.view.bounds;
    // 4.2 设置适配横竖屏(设置四边固定,长宽灵活)
    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    //  4.3 设置播放视图的缩放模式
    self.player.scalingMode = IJKMPMovieScalingModeAspectFit;
    //  4.4 设置自动播放
    self.player.shouldAutoplay = YES;
    //  4.5 自动更新子视图的大小
    self.view.autoresizesSubviews = YES;
    //  4.6 添加播放视图到控制器的View
    [self.view addSubview:self.player.view];
    
    //5. 添加播放控件到控制器的View
    [self.player.view addSubview:self.mediaControl];
    self.mediaControl.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenWidth * 9 / 16);
    // 5.1 代理设置
    self.mediaControl.delegatePlayer = self.player;
    
    //6.添加加载视频时进度动画
    _loadView = [[NSBundle mainBundle] loadNibNamed:@"SCVideoLoadingView" owner:nil options:nil][0];
    _loadView.backgroundColor = [UIColor colorWithHex:@"#000000" alpha:0.8];
    _loadView.frame = CGRectMake(0, 0, 64, 64);
    // 6.1 开始动画
    [_loadView startAnimating];
    [self.view addSubview:_loadView];
    [_loadView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(64, 64));
        
    }];
    
}

-(void)closePlayer
{
    if (self.player) {
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
    //方案一时使用
    if ( [PlayerViewRotate isOrientationLandscape]) {//如果正在全屏，先返回小屏
        self.isFullScreen = NO;
        [PlayerViewRotate forceOrientation:UIInterfaceOrientationPortrait];
        _lastOrientaion = [UIApplication sharedApplication].statusBarOrientation;
        //            [self prepareForSmallScreen];
        //使用通知到该控制器的父视图中更改该控制器的视图
        [[NSNotificationCenter defaultCenter] postNotificationName:SwitchToSmallScreen object:nil];
        
    }else{
        
        // 取出当前的导航控制器
        UITabBarController *tabBarVC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        // 当前选择的导航控制器
        UINavigationController *navController = (UINavigationController *)tabBarVC.selectedViewController;
       
        //DONG_Log(@"%@",navController.viewControllers);
        
        // pop到指定页面
        // 因为是出栈，所以要倒叙遍历navController.viewControllers 从栈顶到栈底遍历
        for (int i = 0; i < navController.viewControllers.count ; i++) {
            unsigned long index = navController.viewControllers.count - i;
            UIViewController* controller = navController.viewControllers[index-1];
            
            
            if ([controller isKindOfClass:[SCMyProgramListVC class]]) {//我的节目单
                
                [navController popToViewController:controller animated:YES];
                return;
                
            }else if ([controller isKindOfClass:[SCMyCollectionVC class]]) {//我的收藏
                
                [navController popToViewController:controller animated:YES];
                return;
                
            }else if ([controller isKindOfClass:[SCMyDownloadManagerVC class]]) {//我的下载
                
                [navController popToViewController:controller animated:YES];
                return;
                
            }else if ([controller isKindOfClass:[SCLiveViewController class]]) {//直播频道列表页
                
                [navController popToViewController:controller animated:YES];
                return;
                
            }else if ([controller isKindOfClass:[SCFilterViewController class]]) {//筛选
                
                [navController popToViewController:controller animated:YES];
                return;
                
            }else if ([controller isKindOfClass:[SCChannelCategoryVC class]]){//点播节目频道分类
                
                [navController popToViewController:controller animated:YES];
                return;
                
            }else if ([controller isKindOfClass:[SCSearchViewController class]]){//搜索控制器
                
                [navController popToViewController:controller animated:YES];
                return;
            }
        }
        
        [navController popToRootViewControllerAnimated:YES];
    }
    
    //方案二时使用
    
    //    if (_isFullScreen || [PlayerViewRotate isOrientationLandscape]) {//如果正在全屏，先返回小屏
    //
    //        self.isFullScreen = NO;
    //
    //        [[NSNotificationCenter defaultCenter] postNotificationName:SwitchToSmallScreen object:nil];
    //
    //    }else{
    //
    //        if (self.doBackActionBlock) {
    //            self.doBackActionBlock();
    //        }
    //    }
    
}

/** 播放&暂停 */
- (IBAction)onClickPlay:(id)sender
{
    if ([self.player isPlaying]) {
        [self.player pause];
        [self.mediaControl.playButton setImage:[UIImage imageNamed:@"Play"] forState:UIControlStateNormal];
        [self.mediaControl refreshMediaControl];
        
    }else if (![self.player isPlaying]){
        [self.player play];
        [self.mediaControl.playButton setImage:[UIImage imageNamed:@"Pause"] forState:UIControlStateNormal];
        [self.mediaControl refreshMediaControl];
        
    }
}

/** 全屏 */
- (IBAction)onClickFullScreenButton:(id)sender
{
    //旋转方案一 系统方法旋转
    if ([PlayerViewRotate isOrientationLandscape]) {
        self.isFullScreen = NO;
        [PlayerViewRotate forceOrientation:UIInterfaceOrientationPortrait];
        _lastOrientaion = [UIApplication sharedApplication].statusBarOrientation;
        //                    [self prepareForSmallScreen];
        //使用通知到该控制器的父视图中更改该控制器的视图
        [[NSNotificationCenter defaultCenter] postNotificationName:SwitchToSmallScreen object:nil];
        
    }else {
        
        self.isFullScreen = YES;
        [PlayerViewRotate forceOrientation:UIInterfaceOrientationLandscapeRight];
        
        //            [self prepareForFullScreen];
        //使用通知到该控制器的父视图中更改该控制器的视图
        [[NSNotificationCenter defaultCenter] postNotificationName:SwitchToFullScreen object:nil];
    }
    
    //旋转方案二 自定义旋转90°
    //    if (!self.isFullScreen) {
    //
    //        self.isFullScreen = YES;
    //        //使用通知到该控制器的父视图中更改该控制器的视图
    //        [[NSNotificationCenter defaultCenter] postNotificationName:SwitchToFullScreen object:nil];
    //
    //    }else{
    //
    //        self.isFullScreen = NO;
    //        //使用通知到该控制器的父视图中更改该控制器的视图
    //        [[NSNotificationCenter defaultCenter] postNotificationName:SwitchToSmallScreen object:nil];
    //    }
}

/** 进度条 */
- (IBAction)didSliderTouchDown:(id)sender
{
    [self.mediaControl beginDragMediaSlider];
    
}

- (IBAction)didSliderTouchCancel:(id)sender
{
    [self.mediaControl endDragMediaSlider];
}

- (IBAction)didSliderTouchUpOutside:(id)sender
{
    [self.mediaControl endDragMediaSlider];
    
}

- (IBAction)didSliderTouchUpInside:(id)sender
{
    self.player.currentPlaybackTime = self.mediaControl.progressSlider.value;
    [self.mediaControl endDragMediaSlider];
    
}

- (IBAction)didSliderValueChanged:(id)sender
{
    [self.mediaControl continueDragMediaSlider];
    
}

/** 全屏锁定 */
- (IBAction)fullScreenLock:(id)sender
{
    if (self.isFullScreen) {
        [self.mediaControl.fullScreenLockButton setImage:[UIImage imageNamed:@"FullScreenLock"] forState:UIControlStateNormal];
    } else {
        [self.mediaControl.fullScreenLockButton setImage:[UIImage imageNamed:@"FullScreenUnlock"] forState:UIControlStateNormal];
    }
    
    
    DONG_NSLog(锁定屏幕);
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
    //
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
