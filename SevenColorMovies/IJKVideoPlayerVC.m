//
//  IJKVideoPlayerVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/15.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "IJKVideoPlayerVC.h"
#import "IJKMediaControl.h"
#import "PlayerViewRotate.h"//横竖屏强制转换

@interface IJKVideoPlayerVC ()

@end

@implementation IJKVideoPlayerVC

{
    UIInterfaceOrientation _lastOrientaion;
}
#pragma mark- Initialize

+ (void)presentFromViewController:(UIViewController *)viewController withTitle:(NSString *)title URL:(NSURL *)url completion:(void (^)())completion {
    
    [viewController presentViewController:[[IJKVideoPlayerVC alloc] initWithURL:url] animated:YES completion:completion];
}

+ (instancetype)initIJKPlayerWithTitle:(NSString *)title URL:(NSURL *)url{
    IJKVideoPlayerVC *IJKPlayer = [[IJKVideoPlayerVC alloc] initWithURL:url];
    return IJKPlayer;
}

- (instancetype)initWithURL:(NSURL *)url {
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

    //初始化播放器
    [self setupIJKPlayer];
    
    //本应写在viewWillAppear中，但viewWillAppear不被执行
    [self installMovieNotificationObservers];
    [self.player prepareToPlay];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.player shutdown];
    [self removeMovieNotificationObservers];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    
}

#pragma mark - 初始化播放器

- (void) setupIJKPlayer{
    
#ifdef DEBUG
    [IJKFFMoviePlayerController setLogReport:YES];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_DEBUG];
#else
    [IJKFFMoviePlayerController setLogReport:NO];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_INFO];
#endif
    
    [IJKFFMoviePlayerController checkIfFFmpegVersionMatch:YES];
    // [IJKFFMoviePlayerController checkIfPlayerVersionMatch:YES major:1 minor:0 micro:0];
    
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:self.url withOptions:options];
    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.player.view.frame = self.view.bounds;
    self.player.scalingMode = IJKMPMovieScalingModeAspectFit;
    self.player.shouldAutoplay = YES;
    
    self.view.autoresizesSubviews = YES;
    [self.view addSubview:self.player.view];
    [self.view addSubview:self.mediaControl];

    
    self.mediaControl.delegatePlayer = self.player;
    
}


#pragma mark - IBAction

/** 控制面板底层 */
- (IBAction)onClickMediaControl:(id)sender {
    [self.mediaControl showAndFade];
}

/** 控制面板 */
- (IBAction)onClickOverlay:(id)sender {
    [self.mediaControl hide];
}

/** 返回 */
- (IBAction)onClickBack:(id)sender {
//    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    if (self.doBackActionBlock) {
        self.doBackActionBlock();
    }
}

/** 播放&暂停 */
- (IBAction)onClickPlay:(id)sender {
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
- (IBAction)onClickFullScreenButton:(id)sender {
    if ([PlayerViewRotate isOrientationLandscape]) {
        [PlayerViewRotate forceOrientation:UIInterfaceOrientationPortrait];
        _lastOrientaion = [UIApplication sharedApplication].statusBarOrientation;
        [self prepareForSmallScreen];
    }else {
        
        [PlayerViewRotate forceOrientation:UIInterfaceOrientationLandscapeRight];
        
        [self prepareForFullScreen];
    }
}

/** 进度条 */
- (IBAction)didSliderTouchDown:(id)sender {
    [self.mediaControl beginDragMediaSlider];
    
}

- (IBAction)didSliderTouchCancel:(id)sender {
    [self.mediaControl endDragMediaSlider];
}

- (IBAction)didSliderTouchUpOutside:(id)sender {
    [self.mediaControl endDragMediaSlider];

}

- (IBAction)didSliderTouchUpInside:(id)sender {
    self.player.currentPlaybackTime = self.mediaControl.progressSlider.value;
    [self.mediaControl endDragMediaSlider];

}

- (IBAction)didSliderValueChanged:(id)sender {
    [self.mediaControl continueDragMediaSlider];

}



#pragma mark - IJK响应事件
- (void)loadStateDidChange:(NSNotification*)notification
{
    IJKMPMovieLoadState loadState = _player.loadState;
    
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStatePlaythroughOK: %d\n", (int)loadState);
    } else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
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


#pragma mark Install Movie Notifications

-(void)installMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];
}

#pragma mark Remove Movie Notification Handlers

/* Remove the movie notification observers from the movie object. */
-(void)removeMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerLoadStateDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:_player];
}




- (void) fullScreenButDidTouch {
    if ([PlayerViewRotate isOrientationLandscape]) {
        [PlayerViewRotate forceOrientation:UIInterfaceOrientationPortrait];
        _lastOrientaion = [UIApplication sharedApplication].statusBarOrientation;
        [self prepareForSmallScreen];
    }else {
        
        [PlayerViewRotate forceOrientation:UIInterfaceOrientationLandscapeRight];
        
        [self prepareForFullScreen];
    }
}


- (void)prepareForFullScreen {
    
    [_player setScalingMode:IJKMPMovieScalingModeAspectFit];
    
    self.view.frame = [[UIScreen mainScreen] bounds];
    self.player.view.frame = CGRectMake(self.view.bounds.origin.x,self.view.bounds.origin.y-20,self.view.bounds.size.width,self.view.bounds.size.height);
    self.mediaControl.frame = CGRectMake(self.view.bounds.origin.x,self.view.bounds.origin.y-20,self.view.bounds.size.width,self.view.bounds.size.height);
    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth & UIViewAutoresizingFlexibleHeight;
    self.mediaControl.autoresizingMask = UIViewAutoresizingFlexibleWidth & UIViewAutoresizingFlexibleHeight;
    
}

- (void)prepareForSmallScreen {
    [_player setScalingMode:IJKMPMovieScalingModeAspectFit];
    self.view.frame = CGRectMake(0, 20, kMainScreenWidth, 213);
    self.player.view.frame = self.view.bounds;
    self.mediaControl.frame = self.view.bounds;
}


@end
