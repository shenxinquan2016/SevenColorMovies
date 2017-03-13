//
//  SCLivePlayerVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/24.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  直播播放页控制器

#import "SCLivePlayerVC.h"
#import "IJKVideoPlayerVC.h"
#import "SCSlideHeaderLabel.h"
#import "SCLiveProgramModel.h"
#import "SCLiveProgramListCollectionVC.h"
#import "SCTCPSocketManager.h"
#import "SCSearchDeviceVC.h"

#import "SCMyProgramListVC.h"
#import "SCMyCollectionVC.h"
#import "SCMyDownloadManagerVC.h"
#import "SCMyWatchingHistoryVC.h"
#import "SCFilterViewController.h"
#import "SCChannelCategoryVC.h"
#import "SCSearchViewController.h"
#import "SCLiveViewController.h"
#import "HLJUUID.h" // 获取UDID
#import "SCXMPPManager.h"
#import "SCScanQRCodesVC.h"
#import "PlayerViewRotate.h"
#import "SCRemoteControlVC.h"

//static const CGFloat StatusBarHeight = 20.0f;
/** 滑动标题栏高度 */
static const CGFloat TitleHeight = 50.0f;
/** 滑动标题栏宽度 */
static const CGFloat LabelWidth = 55.f;

@interface SCLivePlayerVC () <UIScrollViewDelegate, UIAlertViewDelegate, SocketManagerDelegate, SCXMPPManagerDelegate>

/** 标题栏scrollView */
@property (nonatomic, strong) UIScrollView *titleScroll;
/** 内容栏scrollView */
@property (nonatomic, strong) UIScrollView *contentScroll;
/** 滑动短线 */
@property (nonatomic, strong) CALayer *bottomLine;
/** 标题数组 */
@property (nonatomic, strong) NSMutableArray *titleArr;
/** 标题数组 */
@property (nonatomic, strong) NSMutableArray *programModelArr;
/** 标题数组 */
@property (nonatomic, strong) NSMutableArray *dataSourceArr;
/** 在当前页设置点击顶部滚动复位 */
@property (nonatomic, strong) SCLiveProgramListCollectionVC *needScrollToTopPage;
@property (nonatomic, strong) NSURL *url;
/** 播放器控制器 */
@property (nonatomic, strong) IJKVideoPlayerVC *IJKPlayerViewController;
/** 正在播出节目的index */
@property (nonatomic, assign) NSInteger index;
/** 当前列表的arr在dataSourceArr的位置 */
@property (nonatomic, assign) NSUInteger indexOfArrInArr;
/** 选中行所在页的数组 接收回调传值 */
@property (nonatomic, copy) NSArray *liveProgramModelArray;
/** 接收所选中行的model 接收回调传值 */
@property (nonatomic, strong) SCLiveProgramModel *liveModel;
/** 域名替换工具 */
@property (nonatomic, strong) HLJRequest *hljRequest;
/** 动态域名获取工具 */
@property (nonatomic, strong) SCDomaintransformTool *domainTransformTool;
/** 是否全屏锁定 */
@property (nonatomic, assign) BOOL fullScreenLock;
/** 功能区距顶部约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toTopConstraint;
/** 记录时移时距最右端的位置差 */
@property (nonatomic, assign) NSTimeInterval minusSeconds;

@property (weak, nonatomic) IBOutlet UIView *playerBackgroundView;

@property (weak, nonatomic) IBOutlet UIView *functionalZoneView;
/** 控制记录当前播放时间的时机 */
@property (nonatomic, assign) BOOL isRecordingCurrentPlayTime;
/** 记录进入后台时播放器的类型：直播/时移/回看 */
@property (nonatomic, copy) NSString *liveStyle;
/** 记录进入后台时时移进度条的位置 */
@property (nonatomic, assign) NSInteger positionTime;

@end

@implementation SCLivePlayerVC

{
    NSString *programOnLiveName_;/* 临时保存直播节目的名称 */
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHex:@"#f3f3f3"];
    
    // -1.更新功能区的上约束值
    _toTopConstraint.constant = kMainScreenWidth * 9 / 16;
    
    // 0.电视频道名称
    self.channelNameLabel.text = self.filmModel._Title;
    
    // 1.初始化数组
    self.titleArr = [NSMutableArray arrayWithCapacity:0];
    self.programModelArr = [NSMutableArray arrayWithCapacity:0];
    self.dataSourceArr = [NSMutableArray arrayWithCapacity:0];
    
    // 2.set view
    [self setView];
    
    // 3.XMPP delegate
    XMPPManager.delegate = self;
    
    // 4.YES:进入后台时需要记录当前播放时间
    _isRecordingCurrentPlayTime = YES;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self registerNotificationObservers];
    //TCPScoketManager.delegate = self;
    XMPPManager.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    huikanIndex = 0;
    timesIndexOfHuikan = 0;
    // 关闭播放代理
    libagent_finish();
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

-(void)dealloc {
    NSLog(@"🔴%s 第%d行 \n",__func__, __LINE__);
}

- (IBAction)goBack:(id)sender {
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
            
        } else if ([controller isKindOfClass:[SCMyCollectionVC class]]) {//我的收藏
            
            [navController popToViewController:controller animated:YES];
            return;
            
        } else if ([controller isKindOfClass:[SCMyDownloadManagerVC class]]) {//我的下载
            
            [navController popToViewController:controller animated:YES];
            return;
            
        }  else if ([controller isKindOfClass:[SCRemoteControlVC class]]){//遥控器
            
            [navController popToViewController:controller animated:YES];
            return;
            
        } else if ([controller isKindOfClass:[SCMyWatchingHistoryVC class]]) {//直播频道列表页
            
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


#pragma mark- private methods

- (void)registerNotificationObservers
{
    //3.监听屏幕旋转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    //第一次加载成功准备播放
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:nil];
    //播放状态改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:nil];
    //注册播放结束通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_IJKPlayerViewController.player];
    // 5.APP进入后台
    [DONG_NotificationCenter addObserver:self selector:@selector(gotoBackground) name:AppWillResignActive object:nil];
    // 6.APP被激活
    [DONG_NotificationCenter addObserver:self selector:@selector(gotoFrontground) name:AppDidBecomeActive object:nil];
}

- (void)setView
{
    // 请求直播节目列表数据后组装页面
    [self getLiveChannelData];
    
}

#pragma mark - 播放时进入后台和返回前台的处理
/** 进入后台 */
- (void)gotoBackground
{
    
    if ([self.liveStyle isEqualToString:@"回看"] &&_isRecordingCurrentPlayTime) {
        // 允许保存时才记录当前播放时间
        NSInteger currentPlayTime = self.IJKPlayerViewController.player.currentPlaybackTime;
        [DONG_UserDefaults setInteger:currentPlayTime forKey:kCurrentPlayTimeWhenGotoBG];
        [DONG_UserDefaults synchronize];
        DONG_Log(@"进入后台: %ld", (long)currentPlayTime);
        _isRecordingCurrentPlayTime = NO;
        
    }
}

/** 回到前台 */
- (void)gotoFrontground
{
    // 重置播放器
    // 0.关闭正在播放的节目
    if ([self.IJKPlayerViewController.player isPlaying]) {
        [self.IJKPlayerViewController.player pause];
    }
    
    // 1.移除当前的播放器
    [self.IJKPlayerViewController closePlayer];
    
    // 2.重新加载播放器 seekto到指定时间
    // 直播和时移时的进度条不同
    if ([self.liveStyle isEqualToString:@"直播"]) {
        
        if ([PlayerViewRotate isOrientationLandscape]) {
            // 全屏
            // 5.开始播放直播
            self.IJKPlayerViewController = [IJKVideoPlayerVC initIJKPlayerWithURL:self.url];
            self.view.frame = [[UIScreen mainScreen] bounds];
            _IJKPlayerViewController.view.frame = self.view.bounds;
            _IJKPlayerViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth & UIViewAutoresizingFlexibleHeight;
            _IJKPlayerViewController.mediaControl.frame = self.view.frame;
            _IJKPlayerViewController.mediaControl.programNameRunLabel.titleName = programOnLiveName_;
            _IJKPlayerViewController.mediaControl.liveState = Live;
            _IJKPlayerViewController.mediaControl.isLive = YES;
            
        } else {
            
            // 小屏
            // 5.开始播放直播
            self.IJKPlayerViewController = [IJKVideoPlayerVC initIJKPlayerWithURL:self.url];
            _IJKPlayerViewController.view.frame = CGRectMake(0, 20, kMainScreenWidth, kMainScreenWidth * 9 / 16);
            _IJKPlayerViewController.mediaControl.programNameRunLabel.titleName = programOnLiveName_;
            _IJKPlayerViewController.mediaControl.liveState = Live;
            _IJKPlayerViewController.mediaControl.isLive = YES;
            
        }
        
        if (_isFeiPing) {
            // 飞屏 （控制播放器返回事件）
            _IJKPlayerViewController.isFeiPing = YES;
        }
        
        // 6.推屏的回调
        DONG_WeakSelf(self);
        self.IJKPlayerViewController.pushScreenBlock = ^{
            // 未连接设备时要先扫描设备
            if (XMPPManager.isConnected) {
                
                NSString *toName = [NSString stringWithFormat:@"%@@hljvoole.com/%@", XMPPManager.uid, XMPPManager.hid];
                [weakself getLivePushScreenXMLCommandWithFilmModel:weakself.filmModel liveProgramModel:nil success:^(id  _Nullable responseObject) {
                    
                    //[TCPScoketManager socketWriteData:responseObject withTimeout:-1 tag:1001];
                    [XMPPManager sendMessageWithBody:responseObject andToName:toName andType:@"text"];
                }];
                
            } else {
                
                [MBProgressHUD showError:@"设备未绑定，请扫码绑定"];
                //UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"尚未绑定设备，请先扫码绑定设备" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                //[alertView show];
                //alertView.delegate = weakself;
                
            }
        };
        
        // 7.根据全屏锁定的回调，更新本页视图是否支持屏幕旋转的状态
        self.IJKPlayerViewController.fullScreenLockBlock = ^(BOOL isFullScreenLock){
            DONG_StrongSelf(self);
            strongself.fullScreenLock = isFullScreenLock;
            [strongself shouldAutorotate];
        };
        
        // 8.时移的回调
        self.IJKPlayerViewController.timeShiftBlock = ^(NSString *liveState, int positionTime) {
            DONG_Log(@"liveState:%@", liveState);
            if ([liveState isEqualToString:@"timeShift"]) {
                // 进入时移
                [weakself requestTimeShiftVideoSignalFlowUrl:positionTime];
            }
            
        };
        
        [self.view addSubview:_IJKPlayerViewController.view];
        
    } else if ([self.liveStyle isEqualToString:@"时移"]) {
        
        if ([PlayerViewRotate isOrientationLandscape]) {
            // 全屏
            // 6.开始播放时移
            self.IJKPlayerViewController = [IJKVideoPlayerVC initIJKPlayerWithURL:self.url];
            self.view.frame = [[UIScreen mainScreen] bounds];
            _IJKPlayerViewController.view.frame = self.view.bounds;
            _IJKPlayerViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth & UIViewAutoresizingFlexibleHeight;
            _IJKPlayerViewController.mediaControl.frame = self.view.frame;
            
            _IJKPlayerViewController.mediaControl.programNameRunLabel.titleName = programOnLiveName_;
            _IJKPlayerViewController.mediaControl.liveState = TimeShift;
            _IJKPlayerViewController.mediaControl.firmPosition = self.positionTime;
            _IJKPlayerViewController.mediaControl.isLive = YES;
            
        } else {
            
            // 小屏
            // 6.开始播放时移
            self.IJKPlayerViewController = [IJKVideoPlayerVC initIJKPlayerWithURL:self.url];
            _IJKPlayerViewController.view.frame = CGRectMake(0, 20, kMainScreenWidth, kMainScreenWidth * 9 / 16);
            _IJKPlayerViewController.mediaControl.programNameRunLabel.titleName = programOnLiveName_;
            _IJKPlayerViewController.mediaControl.liveState = TimeShift;
            _IJKPlayerViewController.mediaControl.firmPosition = self.positionTime;
            _IJKPlayerViewController.mediaControl.isLive = YES;
            
        }
        
        if (_isFeiPing) {
            // 飞屏 （控制播放器返回事件）
            _IJKPlayerViewController.isFeiPing = YES;
        }
        
        // 7.推屏的回调
        DONG_WeakSelf(self);
        self.IJKPlayerViewController.pushScreenBlock = ^{
            // 未连接设备时要先扫描设备
            if (XMPPManager.isConnected) {
                
                NSString *toName = [NSString stringWithFormat:@"%@@hljvoole.com/%@", XMPPManager.uid, XMPPManager.hid];
                [weakself getLivePushScreenXMLCommandWithFilmModel:weakself.filmModel liveProgramModel:nil success:^(id  _Nullable responseObject) {
                    
                    [XMPPManager sendMessageWithBody:responseObject andToName:toName andType:@"text"];
                }];
                
                
            } else {
                
                [MBProgressHUD showError:@"设备未绑定，请扫码绑定"];
                //UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"尚未绑定设备，请先扫码绑定设备" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                //[alertView show];
                //alertView.delegate = weakself;
                
            }
        };
        
        // 8.根据全屏锁定的回调，更新本页视图是否支持屏幕旋转的状态
        self.IJKPlayerViewController.fullScreenLockBlock = ^(BOOL isFullScreenLock){
            DONG_StrongSelf(self);
            strongself.fullScreenLock = isFullScreenLock;
            [strongself shouldAutorotate];
        };
        
        // 9.时移的回调
        self.IJKPlayerViewController.timeShiftBlock = ^(NSString *liveState, int positionTime) {
            DONG_Log(@"liveState:%@", liveState);
            if ([liveState isEqualToString:@"live"]) {
                // 进入直播
                [weakself getLiveVideoSignalFlowUrl];
                
            } else if ([liveState isEqualToString:@"timeShift"]) {
                // 请求新的时移
                [weakself requestTimeShiftVideoSignalFlowUrl:positionTime];
            }
        };
        
        [self.view addSubview:_IJKPlayerViewController.view];
        
    } else if ([self.liveStyle isEqualToString:@"回看"]) {
        
        if ([PlayerViewRotate isOrientationLandscape]) {
            // 全屏
            // 6.加载新的播放器开始播放
            self.IJKPlayerViewController = [IJKVideoPlayerVC initIJKPlayerWithURL:self.url];
            self.view.frame = [[UIScreen mainScreen] bounds];
            _IJKPlayerViewController.view.frame = self.view.bounds;
            _IJKPlayerViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth & UIViewAutoresizingFlexibleHeight;
            _IJKPlayerViewController.mediaControl.frame = self.view.frame;
            
            //self.IJKPlayerViewController.mediaControl.programNameLabel.text = model1.programName;
//            self.IJKPlayerViewController.mediaControl.programNameRunLabel.titleName = model1.programName;
            
            
        } else {
            
            // 6.加载新的播放器开始播放
            self.IJKPlayerViewController = [IJKVideoPlayerVC initIJKPlayerWithURL:self.url];
            self.IJKPlayerViewController.view.frame = CGRectMake(0, 20, kMainScreenWidth, kMainScreenWidth * 9 / 16);
            //self.IJKPlayerViewController.mediaControl.programNameLabel.text = model1.programName;
            self.IJKPlayerViewController.mediaControl.programNameRunLabel.titleName = self.liveModel.programName;
            
        }
        
        
        
        // 7.推屏的回调
        DONG_WeakSelf(self);
        self.IJKPlayerViewController.pushScreenBlock = ^{
            // 未连接设备时要先扫描设备
            if (XMPPManager.isConnected) {
                
                NSString *toName = [NSString stringWithFormat:@"%@@hljvoole.com/%@", XMPPManager.uid, XMPPManager.hid];
                [weakself getXMLCommandWithFilmModel:weakself.filmModel liveProgramModel:weakself.liveModel success:^(id  _Nullable responseObject) {
                    
                    //[TCPScoketManager socketWriteData:responseObject withTimeout:-1 tag:1001];
                    [XMPPManager sendMessageWithBody:responseObject andToName:toName andType:@"text"];
                }];
                
            } else {
                
                [MBProgressHUD showError:@"设备未绑定，请扫码绑定"];
                
                //UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"尚未绑定设备，请先扫码绑定设备" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                //[alertView show];
                //alertView.delegate = weakself;
                
            }
        };
        
        // 8.根据全屏锁定的回调，更新本页视图是否支持屏幕旋转的状态
        self.IJKPlayerViewController.fullScreenLockBlock = ^(BOOL isFullScreenLock){
            DONG_StrongSelf(self);
            strongself.fullScreenLock = isFullScreenLock;
            [strongself shouldAutorotate];
        };
        
        [self.view addSubview:self.IJKPlayerViewController.view];
    }
    
    
}

/** 添加滚动标题栏 */
- (void)constructSlideHeaderView
{
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 280, kMainScreenWidth, TitleHeight)];
    backgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backgroundView];
    
    CGFloat titleScrollWith = 0.f;
    if (_titleArr.count*LabelWidth<kMainScreenWidth) {
        titleScrollWith = _titleArr.count*LabelWidth;
    }else{
        titleScrollWith = kMainScreenWidth;
    }
    self.titleScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, titleScrollWith, TitleHeight)];//滚动窗口
    //    _titleScroll.backgroundColor = [UIColor greenColor];
    self.titleScroll.showsHorizontalScrollIndicator = NO;
    self.titleScroll.showsVerticalScrollIndicator = NO;
    self.titleScroll.scrollsToTop = NO;
    
    [backgroundView addSubview:_titleScroll];
    
    //0.添加lab
    [self addLabel];//添加标题label
    //1、底部滑动短线
    //    _bottomLine = [CALayer layer];
    //    [_bottomLine setBackgroundColor:[UIColor colorWithHex:@"#5184FF"].CGColor];
    //    _bottomLine.frame = CGRectMake(0, _titleScroll.frame.size.height-22+StatusBarHeight, LabelWidth, 2);
    //
    //    [_titleScroll.layer addSublayer:_bottomLine];
    
}

/** 添加标题栏label */
- (void)addLabel
{
    for (int i = 0; i < _titleArr.count; i++) {
        CGFloat lbW = LabelWidth;        //宽
        CGFloat lbH = TitleHeight;       //高
        CGFloat lbX = i * lbW;           //X
        CGFloat lbY = 0;                 //Y
        SCSlideHeaderLabel *label = [[SCSlideHeaderLabel alloc] initWithFrame:(CGRectMake(lbX, lbY, lbW, lbH))];
        //        UIViewController *vc = self.childViewControllers[i];
        label.text =_titleArr[i];
        label.font = [UIFont fontWithName:@"HYQiHei" size:19];
        [self.titleScroll addSubview:label];
        label.tag = i;
        label.userInteractionEnabled = YES;
        //        label.backgroundColor = [UIColor greenColor];
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelClick:)]];
    }
    
    _titleScroll.contentSize = CGSizeMake(LabelWidth * _titleArr.count, 0);
    
    //默认选择第一个label
    SCSlideHeaderLabel *lable = [self.titleScroll.subviews lastObject];
    lable.scale = 1.0;
    
}

- (void)hideIJKPlayerMediaControlView
{
    [_IJKPlayerViewController.mediaControl hide];
}

#pragma mark- Event reponse
- (void)labelClick:(UITapGestureRecognizer *)recognizer
{
    SCSlideHeaderLabel *label = (SCSlideHeaderLabel *)recognizer.view;
    CGFloat offsetX = label.tag * _contentScroll.frame.size.width;
    
    CGFloat offsetY = _contentScroll.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    
    [_contentScroll setContentOffset:offset animated:YES];
}

/** 添加正文内容页 */
- (void)constructContentView
{
    _contentScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 330, kMainScreenWidth, kMainScreenHeight-330)];//滚动窗口
    _contentScroll.scrollsToTop = NO;
    _contentScroll.showsHorizontalScrollIndicator = NO;
    _contentScroll.pagingEnabled = YES;
    _contentScroll.delegate = self;
    //    _contentScroll.backgroundColor = [UIColor redColor];
    [self.view addSubview:_contentScroll];
    
    //添加子控制器
    for (int i=0 ; i<_titleArr.count ;i++){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];// 布局对象
        SCLiveProgramListCollectionVC *vc = [[SCLiveProgramListCollectionVC alloc] initWithCollectionViewLayout:layout];
        
        if (_dataSourceArr.count) {
            
            vc.liveProgramModelArr = _dataSourceArr[i];
            vc.viewIdentifier = i;//页面唯一标识符(响应通知时判断使用)
        }
        [self addChildViewController:vc];
        
    }
    
    CGFloat contentX = self.childViewControllers.count * [UIScreen mainScreen].bounds.size.width;
    _contentScroll.contentSize = CGSizeMake(contentX, 0);
    
    // 将_contentScroll滚动到最后的位置
    CGPoint offset = CGPointMake(contentX-[UIScreen mainScreen].bounds.size.width, 0);
    [_contentScroll setContentOffset:offset animated:NO];
    
    // 添加默认控制器
    SCLiveProgramListCollectionVC *vc = [self.childViewControllers lastObject];
    vc.index = _index;
    [self.contentScroll addSubview:vc.view];
    
    [[NSUserDefaults standardUserDefaults] setInteger:_titleArr.count-1 forKey:k_for_Live_selectedViewIndex];//正在显示的view
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    self.needScrollToTopPage = [self.childViewControllers lastObject];
    vc.view.frame = self.contentScroll.bounds;
    
    //点击切换节目block回调方法
    [self doIJKPlayerBlock];
    
    //将_titleScroll滚动到最后的位置
    // 获得索引
    NSUInteger index = _contentScroll.contentOffset.x / _contentScroll.frame.size.width;
    // 滚动标题栏
    SCSlideHeaderLabel *titleLable = (SCSlideHeaderLabel *)_titleScroll.subviews[index];
    CGFloat offsetx = titleLable.center.x - _titleScroll.frame.size.width * 0.5;
    
    CGFloat offsetMax = _titleScroll.contentSize.width - _titleScroll.frame.size.width;
    
    if (offsetx < 0) {
        offsetx = 0;
    }else if (offsetx > offsetMax){
        offsetx = offsetMax;
    }
    
    CGPoint offset1 = CGPointMake(offsetx, _titleScroll.contentOffset.y);
    [_titleScroll setContentOffset:offset1 animated:NO];
}

#pragma mark - UIScrollViewDelegate
/** 滚动结束后调用（代码导致的滚动停止） */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / _contentScroll.frame.size.width;
    // 滚动标题栏
    SCSlideHeaderLabel *titleLable = (SCSlideHeaderLabel *)_titleScroll.subviews[index];
    
    //把下划线与titieLabel的frame绑定(下划线滑动方式)
    //    _bottomLine.frame = CGRectMake(titleLable.frame.origin.x, _titleScroll.frame.size.height-22+StatusBarHeight, LabelWidth, 2);
    
    CGFloat offsetx = titleLable.center.x - _titleScroll.frame.size.width * 0.5;
    
    CGFloat offsetMax = _titleScroll.contentSize.width - _titleScroll.frame.size.width;
    
    if (offsetx < 0) {
        offsetx = 0;
    }else if (offsetx > offsetMax){
        offsetx = offsetMax;
    }
    
    CGPoint offset = CGPointMake(offsetx, _titleScroll.contentOffset.y);
    [_titleScroll setContentOffset:offset animated:YES];
    
    // 将控制器添加到contentScroll
    UIViewController *vc = self.childViewControllers[index];
    //    vc.index = index;
    
    [_titleScroll.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx != index) {
            SCSlideHeaderLabel *temlabel = _titleScroll.subviews[idx];
            temlabel.scale = 0.0;
        }
    }];
    
    [self setScrollToTopWithTableViewIndex:index];
    
    if (vc.view.superview) return;//阻止vc重复添加
    vc.view.frame = scrollView.bounds;
    [_contentScroll addSubview:vc.view];
    
    
}

#pragma mark - ScrollToTop
- (void)setScrollToTopWithTableViewIndex:(NSInteger)index
{
    self.needScrollToTopPage.collectionView.scrollsToTop = NO;
    self.needScrollToTopPage = self.childViewControllers[index];
    self.needScrollToTopPage.collectionView.scrollsToTop = YES;
    
    //点击切换节目block回调方法
    [self doIJKPlayerBlock];
}

/** 滚动结束（手势导致的滚动停止） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

/** 正在滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 取出绝对值 避免最左边往右拉时形变超过1
    CGFloat value = ABS(scrollView.contentOffset.x / scrollView.frame.size.width);
    NSUInteger leftIndex = (int)value;
    NSUInteger rightIndex = leftIndex + 1;
    CGFloat scaleRight = value - leftIndex;
    CGFloat scaleLeft = 1 - scaleRight;
    SCSlideHeaderLabel *labelLeft = _titleScroll.subviews[leftIndex];
    labelLeft.scale = scaleLeft;
    // 考虑到最后一个板块，如果右边已经没有板块了 就不在下面赋值scale了
    if (rightIndex < _titleScroll.subviews.count) {
        SCSlideHeaderLabel *labelRight = _titleScroll.subviews[rightIndex];
        labelRight.scale = scaleRight;
    }
    
    //下划线即时滑动
    //    float modulus = scrollView.contentOffset.x/_contentScroll.contentSize.width;
    //    _bottomLine.frame = CGRectMake(modulus * _titleScroll.contentSize.width, _titleScroll.frame.size.height-22+StatusBarHeight, LabelWidth, 2);
    
}

#pragma mark - IJK播放控制器的回调
- (void)doIJKPlayerBlock
{
    DONG_WeakSelf(self);
    //点击节目list切换节目
    _needScrollToTopPage.clickToPlayBlock = ^(SCLiveProgramModel *model, SCLiveProgramModel *nextProgramModel, NSArray *liveProgramModelArray){
        DONG_StrongSelf(self);
        strongself.liveModel = model;
        strongself.liveProgramModelArray = liveProgramModelArray;
        strongself.indexOfArrInArr = [strongself.dataSourceArr indexOfObject:strongself.liveProgramModelArray];
        
        //请求url并播放
        if (model.programState == HavePast) {//回看
            
            [strongself requestProgramHavePastVideoSignalFlowUrlWithModel:model NextProgramModel:nextProgramModel];
            
        }else if (model.programState == NowPlaying){
            
            [strongself getLiveVideoSignalFlowUrl];//直播
            
        }else {
            [MBProgressHUD showError:@"节目未开始"];//未开始
            return;
        }
        timesIndexOfHuikan = 0;//每次点击后将index复位为0
    };
}

static NSUInteger huikanIndex; //首页播放回看的url在_huikanPlayerUrlArray中的第几个，这个播放完后去播放index + 1的回看
static NSUInteger timesIndexOfHuikan = 0;//标记自动播放下一个节目的次数

#pragma mark - 播放下一个节目

- (void)playNextProgram
{
    huikanIndex = [self.liveProgramModelArray indexOfObject:self.liveModel];
    //NSLog(@">>>>>>>>>>>index::::%lu",huikanIndex);
    //NSLog(@"这个节目播放结束了,播放下一个节目");
    //NSLog(@">>>>>>indexOfArrInArr_::::%lu",indexOfArrInArr_);
    
    if (huikanIndex+1+ ++timesIndexOfHuikan < self.liveProgramModelArray.count) {
        
        SCLiveProgramModel *model1 = self.liveProgramModelArray[huikanIndex+timesIndexOfHuikan];
        SCLiveProgramModel *model2 = self.liveProgramModelArray[huikanIndex+timesIndexOfHuikan+1];
        
        //当前列表的arr在dataSourceArr的位置通知给cellectionView
        NSString *index = [NSString stringWithFormat:@"%lu",(unsigned long)self.indexOfArrInArr];
        NSDictionary *message = @{@"model" : model1, @"index" : index};
        
        //请求url并播放
        if (model1.programState == HavePast) {
            
            [self requestProgramHavePastVideoSignalFlowUrlWithModel:model1 NextProgramModel:model2];//回看
            
            [[NSNotificationCenter defaultCenter] postNotificationName:ChangeCellStateWhenPlayNextProgrom object:message];
        }else if (model1.programState == NowPlaying){
            
            [self getLiveVideoSignalFlowUrl];//直播
            [[NSNotificationCenter defaultCenter] postNotificationName:ChangeCellStateWhenPlayNextProgrom object:message];
        }else {
            [MBProgressHUD showError:@"节目未开始"];//预约
            return;
        }
    }
}

#pragma mark - IJK播放状态改变通知

- (void)moviePlayBackStateDidChange:(NSNotification*)notification
{
    //    MPMoviePlaybackStateStopped,
    //    MPMoviePlaybackStatePlaying,
    //    MPMoviePlaybackStatePaused,
    //    MPMoviePlaybackStateInterrupted,
    //    MPMoviePlaybackStateSeekingForward,
    //    MPMoviePlaybackStateSeekingBackward
    
    switch (_IJKPlayerViewController.player.playbackState)
    {
        case IJKMPMoviePlaybackStateStopped: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_IJKPlayerViewController.player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStatePlaying: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_IJKPlayerViewController.player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStatePaused: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_IJKPlayerViewController.player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateInterrupted: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_IJKPlayerViewController.player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateSeekingForward:
            
        case IJKMPMoviePlaybackStateSeekingBackward: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_IJKPlayerViewController.player.playbackState);
            
            
            
            break;
        }
        default: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_IJKPlayerViewController.player.playbackState);
            break;
        }
    }
}

#pragma mark - IJK播放结束通知响应时间

- (void)moviePlayBackDidFinish:(NSNotification*)notification
{
    //    MPMovieFinishReasonPlaybackEnded,
    //    MPMovieFinishReasonPlaybackError,
    //    MPMovieFinishReasonUserExited
    int reason = [[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    
    switch (reason)
    {
        case IJKMPMovieFinishReasonPlaybackEnded:
            
            [self playNextProgram];
            
            break;
            
        case IJKMPMovieFinishReasonUserExited:
            
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:
            
            break;
            
        default:
            
            break;
    }
}

#pragma mark - IJK完成加载即将播放的通知

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification
{
    // 开始播放5秒后隐藏播放器控件
    [self performSelector:@selector(hideIJKPlayerMediaControlView) withObject:nil afterDelay:5.0];
    
    // 从后台回来
    // 在此通知里设置加载IJK时的起始播放时间
    NSInteger currentPlayTime = [DONG_UserDefaults integerForKey:kCurrentPlayTimeWhenGotoBG];
    
    if ([self.liveStyle isEqualToString:@"回看"] && currentPlayTime) {
        
        self.IJKPlayerViewController.player.currentPlaybackTime = currentPlayTime;
        currentPlayTime = 0;// 复位
        [DONG_UserDefaults setInteger:currentPlayTime forKey:kCurrentPlayTimeWhenGotoBG];
        [DONG_UserDefaults synchronize];
        // 加载成功seekTo指定时间后才允许下次进入后台时记录当前播放时间
        _isRecordingCurrentPlayTime = YES;
        
    }

}

#pragma mark - 全屏/小屏切换
// 监听屏幕旋转后，更改frame
- (void)orientChange:(NSNotification *)noti
{
    //NSDictionary* ntfDict = [noti userInfo];
    
    UIDeviceOrientation  orient = [UIDevice currentDevice].orientation;
    /*
     UIDeviceOrientationUnknown,
     UIDeviceOrientationPortrait,            // Device oriented vertically, home button on the bottom
     UIDeviceOrientationPortraitUpsideDown,  // Device oriented vertically, home button on the top
     UIDeviceOrientationLandscapeLeft,       // Device oriented horizontally, home button on the right
     UIDeviceOrientationLandscapeRight,      // Device oriented horizontally, home button on the left
     UIDeviceOrientationFaceUp,              // Device oriented flat, face up
     UIDeviceOrientationFaceDown             // Device oriented flat, face down   */
    
    switch (orient) {
        case UIDeviceOrientationPortrait:
            
            //此方向为正常竖屏方向，当锁定全屏设备旋转至此方向时，屏幕虽然不显示StatusBar，但会留出StatusBar位置，所以调整IJKPlayer的位置
            if (self.fullScreenLock) {
                [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
                _IJKPlayerViewController.isFullScreen = YES;
                [_IJKPlayerViewController.player setScalingMode:IJKMPMovieScalingModeAspectFit];
                _IJKPlayerViewController.view.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenWidth * 9 / 16);
                _IJKPlayerViewController.mediaControl.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenWidth * 9 / 16);
                _IJKPlayerViewController.mediaControl.fullScreenLockButton.hidden = NO;
                DONG_Log(@"全屏锁定");
                
            } else {
                
                [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
                [_IJKPlayerViewController.player setScalingMode:IJKMPMovieScalingModeAspectFit];
                _playerBackgroundView.frame = CGRectMake(0, 20, kMainScreenWidth, kMainScreenWidth * 9 / 16);
                _functionalZoneView.frame = CGRectMake(0, 20 + (kMainScreenWidth * 9 / 16) + 2, kMainScreenWidth, 36);
                _IJKPlayerViewController.view.frame = CGRectMake(0, 20, kMainScreenWidth, kMainScreenWidth * 9 / 16);
                _IJKPlayerViewController.mediaControl.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenWidth * 9 / 16);
                _IJKPlayerViewController.mediaControl.fullScreenLockButton.hidden = YES;
            }
            
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
            [_IJKPlayerViewController.player setScalingMode:IJKMPMovieScalingModeAspectFit];
            self.view.frame = [[UIScreen mainScreen] bounds];
            _IJKPlayerViewController.view.frame = self.view.bounds;
            _IJKPlayerViewController.isFullScreen = YES;
            _IJKPlayerViewController.mediaControl.fullScreenLockButton.hidden = NO;
            _IJKPlayerViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth & UIViewAutoresizingFlexibleHeight;
            _IJKPlayerViewController.mediaControl.frame = self.view.frame;
            [self.view bringSubviewToFront:_IJKPlayerViewController.view];
            DONG_Log(@"全屏");
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
            _IJKPlayerViewController.mediaControl.fullScreenLockButton.hidden = NO;
            _IJKPlayerViewController.isFullScreen = YES;
            _IJKPlayerViewController.mediaControl.fullScreenLockButton.hidden = NO;
            DONG_Log(@"全屏");
            break;
            
        case UIDeviceOrientationLandscapeRight:
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
            [_IJKPlayerViewController.player setScalingMode:IJKMPMovieScalingModeAspectFit];
            self.view.frame = [[UIScreen mainScreen] bounds];
            _IJKPlayerViewController.view.frame = self.view.bounds;
            _IJKPlayerViewController.isFullScreen = YES;
            _IJKPlayerViewController.mediaControl.fullScreenLockButton.hidden = NO;
            _IJKPlayerViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth & UIViewAutoresizingFlexibleHeight;
            _IJKPlayerViewController.mediaControl.frame = self.view.frame;
            [self.view bringSubviewToFront:_IJKPlayerViewController.view];
            DONG_Log(@"全屏");
            break;
            
        default:
            break;
    }
}

#pragma mark - 网络请求

// 请求直播节目列表数据
- (void)getLiveChannelData
{
    [CommonFunc showLoadingWithTips:@""];
    
    // 域名获取
    _domainTransformTool  = [[SCDomaintransformTool alloc] init];
    [_domainTransformTool getNewDomainByUrlString:LiveProgramList key:@"sklive" success:^(id  _Nullable newUrlString) {
        
        DONG_Log(@"newUrlString:%@",newUrlString);
        // ip转换
        _hljRequest = [HLJRequest requestWithPlayVideoURL:newUrlString];
        [_hljRequest getNewVideoURLSuccess:^(NSString *newVideoUrl) {
            
            DONG_Log(@"newVideoUrl:%@",newVideoUrl);
            
            NSDictionary *parameters = @{@"tvid" : self.filmModel._TvId ? self.filmModel._TvId : @""};
            [requestDataManager requestDataWithUrl:newVideoUrl parameters:parameters success:^(id  _Nullable responseObject) {
                //NSLog(@"====responseObject:::%@===",responseObject);
                [_dataSourceArr removeAllObjects];
                NSArray *array = responseObject[@"FilmClass"][@"FilmlistSet"];
                if (array.count > 0) {
                    
                    [_titleArr removeAllObjects];
                    
                    for (NSDictionary *dic in array) {
                        
                        NSString *dateStr = dic[@"_Date"];
                        //按格式如:08.28 获取滑动标题头
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        formatter.dateFormat = @"yyyy-MM-dd";//格式化对象的样式/z大小写都行/格式必须严格和字符串时间一样
                        NSDate *date = [formatter dateFromString:dateStr];
                        formatter.dateFormat = @"MM.dd";
                        NSString *dateString = [formatter stringFromDate:date];
                        
                        [_titleArr addObject:dateString];
                        
                        //以下获取program信息
                        NSArray *arr = dic[@"Film"];
                        if (arr.count > 0) {
                            [_programModelArr removeAllObjects];
                            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                NSDictionary *dic1 = obj;
                                
                                SCLiveProgramModel *programModel = [[SCLiveProgramModel alloc] init];
                                
                                programModel.onLive = NO;
                                //节目名称
                                programModel.programName = dic1[@"FilmName"];
                                NSString *forecastDateString = dic1[@"_ForecastDate"];
                                //按格式如:10:05 获取时间
                                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";//格式化对象的样式/z大小写都行/格式必须严格和字符串时间一样
                                NSDate *pragramDate = [formatter dateFromString:forecastDateString];
                                formatter.dateFormat = @"HH:mm";
                                NSString *timeString = [formatter stringFromDate:pragramDate];
                                programModel.programTime = timeString;
                                programModel.startTime = forecastDateString;
                                
                                
                                DONG_Log(@"programModel.startTime:%@", programModel.startTime);
                                
                                //获取节目状态
                                //1.当前时间
                                NSDate *currenDate = [NSDate date];
                                //2.日期比较
                                NSTimeInterval secondsInterval = [currenDate timeIntervalSinceDate:pragramDate];
                                
                                if (secondsInterval >= 0) {
                                    if (idx+1 < arr.count) {
                                        //获取下一个节目的开始时间
                                        NSDictionary *dic2 = arr[idx+1];
                                        NSString *forecastDateString2 = dic2[@"_ForecastDate"];
                                        programModel.endTime = forecastDateString2;//下一个开始即上一个结束时间
                                        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";//格式化对象的样式/z大小写都行/格式必须严格和字符串时间一样
                                        NSDate *pragramDate2 = [formatter dateFromString:forecastDateString2];
                                        //日期比较
                                        NSTimeInterval secondsInterval2 = [currenDate timeIntervalSinceDate:pragramDate2];
                                        
                                        if (secondsInterval2 < 0) {//当前时间比当前节目的开始时间晚且比下一个节目的开始时间早，当前节目即为正在播出节目
                                            
                                            programModel.programState = NowPlaying;
                                            programModel.onLive = YES;
                                            _index = idx;//正在播出节目的index
                                            programOnLiveName_ = programModel.programName;//保存正在播出的节目的名称
                                            
                                            [[NSUserDefaults standardUserDefaults] setInteger:_index forKey:k_for_Live_selectedCellIndex];//被选中的行
                                            [[NSUserDefaults standardUserDefaults] synchronize];
                                            
                                        }else{
                                            programModel.programState = HavePast;
                                        }
                                    }
                                }else{
                                    programModel.programState = WillPlay;
                                }
                                
                                [_programModelArr addObject:programModel];
                                
                                //NSLog(@"====responseObject:::%@=%lu==",timeString,(unsigned long)programModel.programState);
                            }];
                        }
                        
                        [_dataSourceArr addObject:[_programModelArr copy]];
                    }
                }
                
                if (_liveState == TimeShift) {
                    
                    // 0.请求时移拉屏视频流url
                    [self requestTimeShiftVideoSignalFlowUrlWhenPullScreenWithCurrentPlayTime:_currentPlayTime];
                    
                } else {
                    
                    // 1.请求该频道直播流url
                    [self getLiveVideoSignalFlowUrl];
                }
                
                // 2.添加滑动headerView
                [self constructSlideHeaderView];
                // 3.添加contentScrllowView
                [self constructContentView];
                
            } failure:^(id  _Nullable errorObject) {
                [CommonFunc dismiss];
                
            }];
            
        } failure:^(NSError *error) {
            
            [CommonFunc dismiss];
            
        }];
        
    } failure:^(id  _Nullable errorObject) {
        
        [CommonFunc dismiss];
        
    }];
}

// 请求直播流url
- (void)getLiveVideoSignalFlowUrl
{
    DONG_Log(@"<<<<<<<<<<<<< 进入直播 >>>>>>>>>>>>>");
    
    self.liveStyle = @"直播";
    
    // 1.关闭正在播放的节目
    if ([self.IJKPlayerViewController.player isPlaying]) {
        [self.IJKPlayerViewController.player pause];
    }
    
    // 2.加载动画
    [CommonFunc showLoadingWithTips:@"视频加载中..."];
    
    // 3.请求播放地址url
    NSString *fidStr = [[_filmModel._TvId stringByAppendingString:@"_"] stringByAppendingString:_filmModel._TvId];
    // [MBProgressHUD showError:fidStr];
    //hid = 设备的mac地址
    
    NSString *uuidStr = [HLJUUID getUUID];
    
    NSDictionary *parameters = @{@"fid"      : fidStr? fidStr : @"",
                                 @"playtype" : @"1000",
                                 @"hid"      : uuidStr? uuidStr : @""};

    // 域名获取
    NSString *domainUrl = [_domainTransformTool getNewViedoURLByUrlString:ToGetLiveVideoSignalFlowUrl key:@"playauth"];
    
    DONG_Log(@"domainUrl:%@",domainUrl);
    // ip转换
    NSString *newIpUrl = [_hljRequest getNewViedoURLByOriginVideoURL:domainUrl];
    
    DONG_Log(@"newIpUrl:%@",newIpUrl);
    
    [requestDataManager requestDataWithUrl:newIpUrl parameters:parameters success:^(id  _Nullable responseObject) {
        DONG_Log(@"====responseObject:::%@===",responseObject);
        
        NSString *liveUrl = responseObject[@"play_url"];
        
        NSString *newLiveUrl = [self.hljRequest getNewViedoURLByOriginVideoURL:liveUrl];
        
        //            NSString *newLiveUrl = @"http://10.177.1.245/IndexProxy.do?action=b2bplayauth&playtype=1100&mid=1&sid=1&pid=1&uid=10&oemid=30050&hid=dc:ee:06:c9:8b:a6&fid=160_160&ext=c3RpbWU9MTQ4NjM0MjYwNyZwb3J0PTU2NTYmZXh0PW9pZDozMDA1MA&time=10000&proto=11&key=dc:ee:06:c9:8b:a600000000000000000000000_tv_160.m3u8";
        
        DONG_Log(@">>>>>>直播节目播放url>>>>>%@>>>>>>>",newLiveUrl);
        
        
        // 4.移除当前的播放器
        [self.IJKPlayerViewController closePlayer];
        
        if ([PlayerViewRotate isOrientationLandscape]) {
            // 全屏
            // 5.开始播放直播
            self.url = [NSURL URLWithString:newLiveUrl];
            self.IJKPlayerViewController = [IJKVideoPlayerVC initIJKPlayerWithURL:self.url];
            self.view.frame = [[UIScreen mainScreen] bounds];
            _IJKPlayerViewController.view.frame = self.view.bounds;
            _IJKPlayerViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth & UIViewAutoresizingFlexibleHeight;
            _IJKPlayerViewController.mediaControl.frame = self.view.frame;
            _IJKPlayerViewController.mediaControl.programNameRunLabel.titleName = programOnLiveName_;
            _IJKPlayerViewController.mediaControl.liveState = Live;
            _IJKPlayerViewController.mediaControl.isLive = YES;
            
        } else {
            
            // 小屏
            // 5.开始播放直播
            self.url = [NSURL URLWithString:newLiveUrl];
            //self.url = [NSURL fileURLWithPath:@"/Users/yesdgq/Downloads/IMG_0839.MOV"];
            self.IJKPlayerViewController = [IJKVideoPlayerVC initIJKPlayerWithURL:self.url];
            _IJKPlayerViewController.view.frame = CGRectMake(0, 20, kMainScreenWidth, kMainScreenWidth * 9 / 16);
            _IJKPlayerViewController.mediaControl.programNameRunLabel.titleName = programOnLiveName_;
            _IJKPlayerViewController.mediaControl.liveState = Live;
            _IJKPlayerViewController.mediaControl.isLive = YES;
            
        }
        
        if (_isFeiPing) {
            // 飞屏 （控制播放器返回事件）
            _IJKPlayerViewController.isFeiPing = YES;
        }
        
        // 6.推屏的回调
        DONG_WeakSelf(self);
        self.IJKPlayerViewController.pushScreenBlock = ^{
            // 未连接设备时要先扫描设备
            if (XMPPManager.isConnected) {
                
                NSString *toName = [NSString stringWithFormat:@"%@@hljvoole.com/%@", XMPPManager.uid, XMPPManager.hid];
                [weakself getLivePushScreenXMLCommandWithFilmModel:weakself.filmModel liveProgramModel:nil success:^(id  _Nullable responseObject) {
                    
                    //[TCPScoketManager socketWriteData:responseObject withTimeout:-1 tag:1001];
                    [XMPPManager sendMessageWithBody:responseObject andToName:toName andType:@"text"];
                }];
                
            } else {
                
                [MBProgressHUD showError:@"设备未绑定，请扫码绑定"];
                //UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"尚未绑定设备，请先扫码绑定设备" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                //[alertView show];
                //alertView.delegate = weakself;
                
            }
        };
        
        // 7.根据全屏锁定的回调，更新本页视图是否支持屏幕旋转的状态
        self.IJKPlayerViewController.fullScreenLockBlock = ^(BOOL isFullScreenLock){
            DONG_StrongSelf(self);
            strongself.fullScreenLock = isFullScreenLock;
            [strongself shouldAutorotate];
        };
        
        // 8.时移的回调
        self.IJKPlayerViewController.timeShiftBlock = ^(NSString *liveState, int positionTime) {
            DONG_Log(@"liveState:%@", liveState);
            if ([liveState isEqualToString:@"timeShift"]) {
                // 进入时移
                [weakself requestTimeShiftVideoSignalFlowUrl:positionTime];
            }
            
        };
        
        [self.view addSubview:_IJKPlayerViewController.view];
        
        [CommonFunc dismiss];
    } failure:^(id  _Nullable errorObject) {
        [CommonFunc dismiss];
        
    }];
}

// 请求时移节目视屏流url
- (void)requestTimeShiftVideoSignalFlowUrl:(int)positionTime
{
    DONG_Log(@"<<<<<<<<<<<<< 进入时移 >>>>>>>>>>>>>");
    
    self.liveStyle = @"时移";
    self.positionTime = positionTime;
    
    // 1.关闭正在播放的节目
    if ([self.IJKPlayerViewController.player isPlaying]) {
        [self.IJKPlayerViewController.player pause];
    }
    
    // 2.加载动画
    [CommonFunc showLoadingWithTips:@"视频加载中..."];
    
    // 3.请求播放地址url
    NSString *fidStr = [[_filmModel._TvId stringByAppendingString:@"_"] stringByAppendingString:_filmModel._TvId];
    // 4.hid = UUID
    const NSString *uuidStr = [HLJUUID getUUID];
    
    NSTimeInterval minusSeconds = 6 * 3600 - positionTime;
    _minusSeconds = minusSeconds;
    
    // 格林尼治时间
    NSDate *date = [NSDate date];
    // 当前时间的时间戳
    NSInteger nowTimeStap = [NSDate timeStampFromDate:date];
    // 当前播放位置的时间戳
    NSString *currentPlayTimeStap = [NSString stringWithFormat:@"%.0f", (nowTimeStap - minusSeconds)];
    NSString *ext = [NSString stringWithFormat:@"stime=%@&port=5656&ext=oid:30050", currentPlayTimeStap];
    NSString *base64Ext = [[ext stringByBase64Encoding] stringByTrimmingEqualMark];
    DONG_Log(@"currentPlayTimeStap:%@", currentPlayTimeStap);
    DONG_Log(@"base64Ext:%@", base64Ext);
    
    NSDictionary *parameters = @{@"ext"      : base64Ext,
                                 @"hid"      : uuidStr,
                                 @"playtype" : @"1100",
                                 @"fid"      : fidStr};
    
    // 域名获取
    NSString *domainUrl = [_domainTransformTool getNewViedoURLByUrlString:ToGetLiveTimeShiftVideoSignalFlowUrl key:@"playauth"];
    
    DONG_Log(@"domainUrl:%@",domainUrl);
    // ip转换
    NSString *newIpUrl = [_hljRequest getNewViedoURLByOriginVideoURL:domainUrl];
    
    DONG_Log(@"newIpUrl:%@",newIpUrl);
    
    [requestDataManager requestDataWithUrl:newIpUrl parameters:parameters success:^(id  _Nullable responseObject) {
        //DONG_Log(@"responseObject:%@",responseObject);
        NSString *timeShiftUrl = responseObject[@"play_url"];
        // ip转换
        NSString *newTimeShiftUrl = [self.hljRequest getNewViedoURLByOriginVideoURL:timeShiftUrl];
        
        DONG_Log(@"newTimeShiftUrl:%@",newTimeShiftUrl);
        
        // 5.移除当前的播放器
        [self.IJKPlayerViewController closePlayer];
        
        if ([PlayerViewRotate isOrientationLandscape]) {
            // 全屏
            // 6.开始播放直播
            self.url = [NSURL URLWithString:newTimeShiftUrl];
            self.IJKPlayerViewController = [IJKVideoPlayerVC initIJKPlayerWithURL:self.url];
            self.view.frame = [[UIScreen mainScreen] bounds];
            _IJKPlayerViewController.view.frame = self.view.bounds;
            _IJKPlayerViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth & UIViewAutoresizingFlexibleHeight;
            _IJKPlayerViewController.mediaControl.frame = self.view.frame;
            
            _IJKPlayerViewController.mediaControl.programNameRunLabel.titleName = programOnLiveName_;
            _IJKPlayerViewController.mediaControl.liveState = TimeShift;
            _IJKPlayerViewController.mediaControl.firmPosition = positionTime;
            _IJKPlayerViewController.mediaControl.isLive = YES;
            
        } else {
            
            // 小屏
            // 6.开始播放直播
            self.url = [NSURL URLWithString:newTimeShiftUrl];
            self.IJKPlayerViewController = [IJKVideoPlayerVC initIJKPlayerWithURL:self.url];
            _IJKPlayerViewController.view.frame = CGRectMake(0, 20, kMainScreenWidth, kMainScreenWidth * 9 / 16);
            _IJKPlayerViewController.mediaControl.programNameRunLabel.titleName = programOnLiveName_;
            _IJKPlayerViewController.mediaControl.liveState = TimeShift;
            _IJKPlayerViewController.mediaControl.firmPosition = positionTime;
            _IJKPlayerViewController.mediaControl.isLive = YES;
            
        }
        
        if (_isFeiPing) {
            // 飞屏 （控制播放器返回事件）
            _IJKPlayerViewController.isFeiPing = YES;
        }
        
        // 7.推屏的回调
        DONG_WeakSelf(self);
        self.IJKPlayerViewController.pushScreenBlock = ^{
            // 未连接设备时要先扫描设备
            if (XMPPManager.isConnected) {
                
                NSString *toName = [NSString stringWithFormat:@"%@@hljvoole.com/%@", XMPPManager.uid, XMPPManager.hid];
                [weakself getLivePushScreenXMLCommandWithFilmModel:weakself.filmModel liveProgramModel:nil success:^(id  _Nullable responseObject) {
                    
                    [XMPPManager sendMessageWithBody:responseObject andToName:toName andType:@"text"];
                }];
                
                
            } else {
                
                [MBProgressHUD showError:@"设备未绑定，请扫码绑定"];
                //UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"尚未绑定设备，请先扫码绑定设备" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                //[alertView show];
                //alertView.delegate = weakself;
                
            }
        };
        
        // 8.根据全屏锁定的回调，更新本页视图是否支持屏幕旋转的状态
        self.IJKPlayerViewController.fullScreenLockBlock = ^(BOOL isFullScreenLock){
            DONG_StrongSelf(self);
            strongself.fullScreenLock = isFullScreenLock;
            [strongself shouldAutorotate];
        };
        
        // 9.时移的回调
        self.IJKPlayerViewController.timeShiftBlock = ^(NSString *liveState, int positionTime) {
            DONG_Log(@"liveState:%@", liveState);
            if ([liveState isEqualToString:@"live"]) {
                // 进入直播
                [weakself getLiveVideoSignalFlowUrl];
                
            } else if ([liveState isEqualToString:@"timeShift"]) {
                // 请求新的时移
                [weakself requestTimeShiftVideoSignalFlowUrl:positionTime];
            }
            
        };
        
        [self.view addSubview:_IJKPlayerViewController.view];
        
        
        [CommonFunc dismiss];
    } failure:^(id  _Nullable errorObject) {
        
        [CommonFunc dismiss];
        
    }];
    
    
    
}

// 请求时移拉屏视频流
- (void)requestTimeShiftVideoSignalFlowUrlWhenPullScreenWithCurrentPlayTime:(NSString *)currentPlayTime
{
    DONG_Log(@"<<<<<<<<<<<<< 进入时移拉屏 >>>>>>>>>>>>>");
    
    self.liveStyle = @"时移";
    
    // 1.关闭正在播放的节目
    if ([self.IJKPlayerViewController.player isPlaying]) {
        [self.IJKPlayerViewController.player pause];
    }
    
    // 2.加载动画
    [CommonFunc showLoadingWithTips:@"视频加载中..."];
    
    // 3.请求播放地址url
    NSString *fidStr = [[_filmModel._TvId stringByAppendingString:@"_"] stringByAppendingString:_filmModel._TvId];
    // 4.hid = UUID
    const NSString *uuidStr = [HLJUUID getUUID];
    
    // 当前播放位置的时间戳
    NSString *ext = [NSString stringWithFormat:@"stime=%@&port=5656&ext=oid:30050", currentPlayTime];
    NSString *base64Ext = [[ext stringByBase64Encoding] stringByTrimmingEqualMark];
    DONG_Log(@"currentPlayTime:%@", currentPlayTime);
    DONG_Log(@"base64Ext:%@", base64Ext);
    
    NSDictionary *parameters = @{@"ext"       : base64Ext,
                                 @"hid"       : uuidStr,
                                  @"playtype" : @"1100",
                                 @"fid"       : fidStr};
    
    // 域名获取
    NSString *domainUrl = [_domainTransformTool getNewViedoURLByUrlString:ToGetLiveTimeShiftVideoSignalFlowUrl key:@"playauth"];
    
    DONG_Log(@"domainUrl:%@",domainUrl);
    // ip转换
    NSString *newIpUrl = [_hljRequest getNewViedoURLByOriginVideoURL:domainUrl];
    
    DONG_Log(@"newIpUrl:%@",newIpUrl);
    
    [requestDataManager requestDataWithUrl:newIpUrl parameters:parameters success:^(id  _Nullable responseObject) {
        //DONG_Log(@"responseObject:%@",responseObject);
        NSString *timeShiftUrl = responseObject[@"play_url"];
        // ip转换
        NSString *newTimeShiftUrl = [self.hljRequest getNewViedoURLByOriginVideoURL:timeShiftUrl];
        
        DONG_Log(@"newTimeShiftUrl:%@",newTimeShiftUrl);
        
        // 格林尼治时间
        NSDate *date = [NSDate date];
        // 当前时间的时间戳
        NSInteger nowTimeStap = [NSDate timeStampFromDate:date];
        // 当前播放位置
        NSInteger currentPlace = 6 * 3600 - (nowTimeStap - [currentPlayTime integerValue]);
        self.positionTime = currentPlace;
        // 5.移除当前的播放器
        [self.IJKPlayerViewController closePlayer];
        
        if ([PlayerViewRotate isOrientationLandscape]) {
            // 全屏
            // 6.开始播放直播
            self.url = [NSURL URLWithString:newTimeShiftUrl];
            self.IJKPlayerViewController = [IJKVideoPlayerVC initIJKPlayerWithURL:self.url];
            self.view.frame = [[UIScreen mainScreen] bounds];
            _IJKPlayerViewController.view.frame = self.view.bounds;
            _IJKPlayerViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth & UIViewAutoresizingFlexibleHeight;
            _IJKPlayerViewController.mediaControl.frame = self.view.frame;
            
            _IJKPlayerViewController.mediaControl.programNameRunLabel.titleName = programOnLiveName_;
            _IJKPlayerViewController.mediaControl.liveState = TimeShift;
            _IJKPlayerViewController.mediaControl.firmPosition = currentPlace;
            _IJKPlayerViewController.mediaControl.isLive = YES;
            
        } else {
            
            // 小屏
            // 6.开始播放直播
            self.url = [NSURL URLWithString:newTimeShiftUrl];
            self.IJKPlayerViewController = [IJKVideoPlayerVC initIJKPlayerWithURL:self.url];
            _IJKPlayerViewController.view.frame = CGRectMake(0, 20, kMainScreenWidth, kMainScreenWidth * 9 / 16);
            _IJKPlayerViewController.mediaControl.programNameRunLabel.titleName = programOnLiveName_;
            _IJKPlayerViewController.mediaControl.liveState = TimeShift;
            _IJKPlayerViewController.mediaControl.firmPosition = currentPlace;
            _IJKPlayerViewController.mediaControl.isLive = YES;
            
        }
        
        if (_isFeiPing) {
            // 飞屏 （控制播放器返回事件）
            _IJKPlayerViewController.isFeiPing = YES;
        }
        
        // 7.推屏的回调
        DONG_WeakSelf(self);
        self.IJKPlayerViewController.pushScreenBlock = ^{
            // 未连接设备时要先扫描设备
            if (XMPPManager.isConnected) {
                
                NSString *toName = [NSString stringWithFormat:@"%@@hljvoole.com/%@", XMPPManager.uid, XMPPManager.hid];
                [weakself getLivePushScreenXMLCommandWithFilmModel:weakself.filmModel liveProgramModel:nil success:^(id  _Nullable responseObject) {
                    
                    [XMPPManager sendMessageWithBody:responseObject andToName:toName andType:@"text"];
                }];
                
                
            } else {
                
                [MBProgressHUD showError:@"设备未绑定，请扫码绑定"];
                //UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"尚未绑定设备，请先扫码绑定设备" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                //[alertView show];
                //alertView.delegate = weakself;
                
            }
        };
        
        // 8.根据全屏锁定的回调，更新本页视图是否支持屏幕旋转的状态
        self.IJKPlayerViewController.fullScreenLockBlock = ^(BOOL isFullScreenLock){
            DONG_StrongSelf(self);
            strongself.fullScreenLock = isFullScreenLock;
            [strongself shouldAutorotate];
        };
        
        // 9.时移的回调
        self.IJKPlayerViewController.timeShiftBlock = ^(NSString *liveState, int positionTime) {
            DONG_Log(@"liveState:%@", liveState);
            if ([liveState isEqualToString:@"live"]) {
                // 进入直播
                [weakself getLiveVideoSignalFlowUrl];
                
            } else if ([liveState isEqualToString:@"timeShift"]) {
                // 请求新的时移
                [weakself requestTimeShiftVideoSignalFlowUrl:positionTime];
            }
            
        };
        
        [self.view addSubview:_IJKPlayerViewController.view];
        
        
        [CommonFunc dismiss];
    } failure:^(id  _Nullable errorObject) {
        
        [CommonFunc dismiss];
        
    }];
    
}

// 请求回看节目视频流url
- (void)requestProgramHavePastVideoSignalFlowUrlWithModel:(SCLiveProgramModel *)model1 NextProgramModel:(SCLiveProgramModel *)model2
{
    self.liveStyle = @"回看";
    
    // 1.关闭正在播放的节目
    if ([self.IJKPlayerViewController.player isPlaying]) {
        [self.IJKPlayerViewController.player pause];
    }
    
    // 2.加载动画
    [CommonFunc showLoadingWithTips:@"视频加载中..."];
    
    // 3.请求播放地址url
    DONG_Log(@"<<<<<<<<<<<<<<播放新节目:%@>>>下一个节目：%@>>>>>>>>",model1.programName, model2.programName);
    DONG_Log(@"model1.startTime:%@   model2.startTime:%@",model1.startTime,model2.startTime);
    //获取时间戳字符串
    NSString *startTime = [NSString stringWithFormat:@"%ld", (long)[NSDate timeStampFromString:model1.startTime format:@"yyyy-MM-dd HH:mm:ss"]];
    NSString *endTime =  [NSString stringWithFormat:@"%ld", (long)[NSDate timeStampFromString:model2.startTime format:@"yyyy-MM-dd HH:mm:ss"]];
    
    model1.startTimeStamp = startTime;
    model1.endTimeStamp = endTime;
    
    DONG_Log(@"startTimeStamp:%@   endTimeStamp:%@",model1.startTimeStamp, model1.endTimeStamp);
    
    NSString *extStr = [NSString stringWithFormat:@"stime=%@&etime=%@&port=5656&ext=oid:30050",startTime,endTime];
    NSString *ext = [extStr stringByBase64Encoding];
    NSString *fid = [NSString stringWithFormat:@"%@_%@",_filmModel._TvId,_filmModel._TvId];
    
    DONG_Log(@"startTime：%@ \n endTime:%@",startTime, endTime);
    
    DONG_Log(@"ext：%@ \nfid:%@",ext,fid);
    
    NSDictionary *parameters = @{@"fid"      : fid,
                                 @"playtype" : @"1500",
                                 @"ext"      : ext };
    
    // 域名获取
    NSString *domainUrl = [_domainTransformTool getNewViedoURLByUrlString:ToGetProgramHavePastVideoSignalFlowUrl key:@"playauth"];
    
    DONG_Log(@"domainUrl:%@",domainUrl);
    // ip转换
    NSString *newIpUrl = [_hljRequest getNewViedoURLByOriginVideoURL:domainUrl];
    
    DONG_Log(@"newIpUrl:%@",newIpUrl);
    
    
    [requestDataManager requestDataWithUrl:newIpUrl parameters:parameters success:^(id  _Nullable responseObject) {
        NSLog(@"====responseObject:::%@===",responseObject);
        
        NSString *liveUrl = responseObject[@"play_url"];
        
        NSString *playUrl = [_hljRequest getNewViedoURLByOriginVideoURL:liveUrl];
        DONG_Log(@"playUrl：%@ ",playUrl);
        //self.url = [NSURL fileURLWithPath:@"/Users/yesdgq/Downloads/IMG_0839.MOV"];
        self.url= [NSURL URLWithString:playUrl];
        
        // 5.移除当前的播放器
        [self.IJKPlayerViewController closePlayer];
        
        if ([PlayerViewRotate isOrientationLandscape]) {
            // 全屏
            // 6.加载新的播放器开始播放
            self.IJKPlayerViewController = [IJKVideoPlayerVC initIJKPlayerWithURL:self.url];
            self.view.frame = [[UIScreen mainScreen] bounds];
            _IJKPlayerViewController.view.frame = self.view.bounds;
            _IJKPlayerViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth & UIViewAutoresizingFlexibleHeight;
            _IJKPlayerViewController.mediaControl.frame = self.view.frame;
            
            //self.IJKPlayerViewController.mediaControl.programNameLabel.text = model1.programName;
            self.IJKPlayerViewController.mediaControl.programNameRunLabel.titleName = model1.programName;
           
            
        } else {
          
            // 6.加载新的播放器开始播放
            self.IJKPlayerViewController = [IJKVideoPlayerVC initIJKPlayerWithURL:self.url];
            self.IJKPlayerViewController.view.frame = CGRectMake(0, 20, kMainScreenWidth, kMainScreenWidth * 9 / 16);
            //self.IJKPlayerViewController.mediaControl.programNameLabel.text = model1.programName;
            self.IJKPlayerViewController.mediaControl.programNameRunLabel.titleName = model1.programName;
            
        }
        
        
        
        // 7.推屏的回调
        DONG_WeakSelf(self);
        self.IJKPlayerViewController.pushScreenBlock = ^{
            // 未连接设备时要先扫描设备
            if (XMPPManager.isConnected) {
                
                NSString *toName = [NSString stringWithFormat:@"%@@hljvoole.com/%@", XMPPManager.uid, XMPPManager.hid];
                [weakself getXMLCommandWithFilmModel:weakself.filmModel liveProgramModel:model1 success:^(id  _Nullable responseObject) {
                    
                    //[TCPScoketManager socketWriteData:responseObject withTimeout:-1 tag:1001];
                    [XMPPManager sendMessageWithBody:responseObject andToName:toName andType:@"text"];
                }];
                
            } else {
                
                [MBProgressHUD showError:@"设备未绑定，请扫码绑定"];
                
                //UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"尚未绑定设备，请先扫码绑定设备" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                //[alertView show];
                //alertView.delegate = weakself;
                
            }
        };
        
        // 8.根据全屏锁定的回调，更新本页视图是否支持屏幕旋转的状态
        self.IJKPlayerViewController.fullScreenLockBlock = ^(BOOL isFullScreenLock){
            DONG_StrongSelf(self);
            strongself.fullScreenLock = isFullScreenLock;
            [strongself shouldAutorotate];
        };
        
        [self.view addSubview:self.IJKPlayerViewController.view];
        
        [CommonFunc dismiss];
    } failure:^(id  _Nullable errorObject) {
        [CommonFunc dismiss];
        
    }];
    
    
}

#pragma mark - SCXMPPManagerDelegate

/** 消息发送成功 */
- (void)xmppDidSendMessage:(XMPPMessage *)message
{
    
    
}

- (void)xmppDidReceiveMessage:(XMPPMessage *)message
{
    NSString *from = message.fromStr;
    NSString *info = message.body;
    DONG_Log(@"接收到 %@ 说：%@",from, info);
    
    NSDictionary *dic = [NSDictionary dictionaryWithXMLString:info];
    DONG_Log(@"dic:%@",dic);
    
    if (dic) {
        if ([dic[@"info"] isEqualToString:@"当前设备未绑定任何设备!"] || ([dic[@"_value"] isEqualToString:@"sendMsgUnder_unBind"] && [dic[@"_type"] isEqualToString:@"error"])) {
            // 被其他设备挤掉线
            
            [MBProgressHUD showError:@"绑定已被断开，请重新扫码绑定"];
            
        } else if ([dic[@"_type"] isEqualToString:@"TV_Response"] && [dic[@"_value"] isEqualToString:@"tvStartPlayVideoInfo"]) {
            
            // 推屏的返回消息
            DONG_MAIN(^{
                [MBProgressHUD showSuccess:@"推屏成功"];
            });
            
        } else if ([dic[@"_targetName"] isEqualToString:@"com.hlj.live.action"]) {
            
            // 推屏的返回消息
            DONG_MAIN(^{
                [MBProgressHUD showSuccess:@"推屏成功"];
            });
        }
    }
    
}


#pragma mark - SocketManagerDelegate

/** 连接成功 */
- (void)socket:(GCDAsyncSocket *)socket didConnect:(NSString *)host port:(uint16_t)port
{
    //吐司提醒不能发在此，因为socket自己断开后自动连接时不需要弹出吐司，提醒应放在SCSearchDeviceVC页
    //DONG_MAIN_AFTER(0.2, [MBProgressHUD showSuccess:@"设备连接成功"];);
}

/** 发送消息成功 */
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    if (tag == 1001) {
        DONG_MAIN(^{
            [MBProgressHUD showSuccess:@"推屏成功"];
        });
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        SCScanQRCodesVC *scanQRCodesVC = DONG_INSTANT_VC_WITH_ID(@"Discovery", @"SCScanQRCodesVC");
        scanQRCodesVC.entrance = @"player";
        scanQRCodesVC.isQQSimulator = YES;
        scanQRCodesVC.isVideoZoom = YES;
        scanQRCodesVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:scanQRCodesVC animated:YES];
    }
}

#pragma mark - XMLCommandConstruction 推屏

/** 直播推屏 */
- (void)getLivePushScreenXMLCommandWithFilmModel:(SCFilmModel *)filmModel liveProgramModel:(SCLiveProgramModel *)liveProgramModel success:(nullable void(^)(id _Nullable responseObject))backStr
{
    //当前tvId不好使，要重新请求获取Sequence
    __block NSString *sequence = nil;
    __block NSString *xmlString= nil;
    
    NSString *domainUrl = [_domainTransformTool getNewViedoURLByUrlString:GetLiveNewTvId key:@"sklivezh"];
    
    DONG_Log(@"domainUrl:%@",domainUrl);
    
    NSString *newIpUrl = [_hljRequest getNewViedoURLByOriginVideoURL:domainUrl];
    
    DONG_Log(@"newIpUrl:%@",newIpUrl);
    
    [requestDataManager postRequestDataWithUrl:newIpUrl parameters:nil success:^(id  _Nullable responseObject) {
        DONG_Log(@"====responseObject:::%@===",responseObject);
        
        NSArray *array = responseObject[@"LiveTvSort"];
        
        for (NSDictionary *dic in array) {
            
            for (NSDictionary *dic2 in dic[@"LiveTv"]) {
                
                NSString *tvId = dic2[@"_TvId"];
                if ([tvId isEqualToString:self.filmModel._TvId]) {
                    sequence = dic2[@"_Sequence"];
                    
                    NSString *playingType;
                    NSString *currentPlayTime;
                    if (_IJKPlayerViewController.mediaControl.liveState == TimeShift) {
                        
                        playingType = @"timeshift";
                        // 格林尼治时间
                        NSDate *date = [NSDate date];
                        // 当前时间的时间戳
                        NSInteger nowTimeStap = [NSDate timeStampFromDate:date];
                        // 当前播放位置的时间戳
                        NSString *currentPlayTimeStap = [NSString stringWithFormat:@"%.0f", (nowTimeStap - _minusSeconds)];
                        currentPlayTime = currentPlayTimeStap;
                        
                    } else {
                        
                        playingType = @"live";
                        currentPlayTime = [NSString stringWithFormat:@"%.0f", self.IJKPlayerViewController.player.currentPlaybackTime * 1000];
                    }
                    
                    NSString *targetName   = @"com.hlj.live.action";
                    NSString *mid       = @"";
                    NSString *sid       = @"1";
                    NSString *tvId      = sequence;
                    NSString *startTime = @"";
                    
                    xmlString = [self getXMLStringCommandWithFilmName:programOnLiveName_ mid:mid sid:sid tvId:tvId currentPlayTime:currentPlayTime startTime:startTime endTime:nil targetName:targetName playingType:playingType];
                    
                    backStr(xmlString);
                }
            }
        }
        
    } failure:^(id  _Nullable errorObject) {
        
        
    }];
    
}

/** 回看推屏 */
- (void)getXMLCommandWithFilmModel:(SCFilmModel *)filmModel liveProgramModel:(SCLiveProgramModel *)liveProgramModel success:(nullable void(^)(id _Nullable responseObject))backStr
{
    //当前tvId不好使，要重新请求获取Sequence
    __block NSString *sequence = nil;
    __block NSString *xmlString= nil;
    
//    NSString *domainUrl = [_domainTransformTool getNewViedoURLByUrlString:GetLiveNewTvId key:@"sklivezh"];
    
//    DONG_Log(@"domainUrl:%@",domainUrl);
    
//    NSString *newIpUrl = [_hljRequest getNewViedoURLByOriginVideoURL:domainUrl];
    
//    DONG_Log(@"newIpUrl:%@",newIpUrl);
    
    
//    [requestDataManager postRequestDataWithUrl:newIpUrl parameters:nil success:^(id  _Nullable responseObject) {
//        DONG_Log(@"====responseObject:::%@===",responseObject);
    
//        NSArray *array = responseObject[@"LiveTvSort"];
    
//        for (NSDictionary *dic in array) {
    
//            for (NSDictionary *dic2 in dic[@"LiveTv"]) {
    
//                NSString *tvId = dic2[@"_TvId"];
//                if ([tvId isEqualToString:self.filmModel._TvId]) {
//                    sequence = dic2[@"_Sequence"];
    
                    NSString *targetName   = @"epg.vurc.goback.action";
                    NSString *playingType  = @"goback";
                    NSString *sid          = @"1";
                    NSString *tvId         = filmModel._TvId;
                    NSString *startTime    = liveProgramModel.startTime;
                    NSString *endTime      = liveProgramModel.endTime;
                    
                    DONG_Log(@"liveProgramModel.programName:%@", liveProgramModel.programName);
                    DONG_Log(@"startTime:%@", startTime);
                    DONG_Log(@"endTime:%@", endTime);
                    
                    //                    NSDate *date1 = [NSDate getDateWithTimeStamp:startTime];
                    //                    NSDate *date2 = [NSDate getDateWithTimeStamp:endTime];
                    //
                    //                    DONG_Log(@"date1:%@", date1);
                    //                    DONG_Log(@"date2:%@", date2);
                    
                    NSString *currentPlayTime = [NSString stringWithFormat:@"%.0f", self.IJKPlayerViewController.player.currentPlaybackTime * 1000];
                    
                    xmlString = [self getXMLStringCommandWithFilmName:liveProgramModel.programName mid:nil sid:sid tvId:tvId currentPlayTime:currentPlayTime startTime:startTime endTime:endTime targetName:targetName playingType:playingType];
                    
                    backStr(xmlString);
//                }
//            }
//        }

//    } failure:^(id  _Nullable errorObject) {
    
        
//    }];
    
}

- (NSString *) getXMLStringCommandWithFilmName:(NSString *)filmName mid:(NSString *)mid sid:(NSString *)sid tvId:(NSString *)tvId currentPlayTime:(NSString *)currentPlayTime startTime:(NSString *)startTime endTime:(NSString *)endTime targetName:(NSString *)targetName playingType:(NSString *)playingType
{
    NSString *messageType  = @"sendContent2TV";
    NSString *deviceType   = @"TV";
    NSString *currentIndex = @"0";
    NSString *fromWhere    = @"mobile";
    NSString *clientType   = @"VideoGuide";
    NSString *cyclePlay    = @"0";
    
    return [self getXMLStringBodyWithTargetName:targetName messageType:messageType deviceType:deviceType mid:mid sid:sid tvId:tvId playingType:playingType currentIndex:currentIndex fromWhere:fromWhere clientType:clientType currentPlayTime:currentPlayTime startTime:startTime endTime:endTime cyclePlay:cyclePlay filmName:filmName];
}

- (NSString *)getXMLStringBodyWithTargetName:(NSString *)targetName messageType:(NSString *)messageType deviceType:(NSString *)deviceType mid:(NSString *)mid sid:(NSString *)sid tvId:(NSString *)tvId playingType:(NSString *)playingType currentIndex:(NSString *)currentIndex fromWhere:(NSString *)fromWhere clientType:(NSString *)clientType currentPlayTime:(NSString *)currentPlayTime startTime:(NSString *)startTime endTime:(NSString *)endTime cyclePlay:(NSString *)cyclePlay filmName:(NSString *)filmName
{
    NSString *xmlString = [NSString stringWithFormat:@"<?xml version='1.0' encoding='utf-8' standalone='no' ?><Message targetName=\"%@\"><Body><![CDATA[<?xml version='1.0' encoding='utf-8' standalone='no' ?><Message type=\"%@\"><Body><![CDATA[<?xml version='1.0' encoding='utf-8' standalone='no' ?><Device type=\"%@\" mid=\"%@\" sid=\"%@\" tvId=\"%@\" playingType=\"%@\" currentIndex=\"%@\" fromWhere=\"%@\" clientType=\"%@\" currentPlayTime=\"%@\" startTime=\"%@\"  endTime=\"%@\" cyclePlay=\"%@\"><filmName><![CDATA[%@]]]]]]><![CDATA[><![CDATA[></filmName><columnCode><![CDATA[]]]]]]><![CDATA[><![CDATA[></columnCode><dataUrl><![CDATA[]]]]]]><![CDATA[><![CDATA[></dataUrl><info><![CDATA[<?xml version='1.0' encoding='utf-8' standalone='no' ?><ContentList />]]]]]]><![CDATA[><![CDATA[></info></Device>]]]]><![CDATA[></Body></Message>]]></Body></Message>\n", targetName, messageType, deviceType, mid, sid, tvId, playingType, currentIndex, fromWhere, clientType, currentPlayTime, startTime, endTime, cyclePlay, filmName];
    
    return xmlString;
}

// 禁止旋转屏幕
- (BOOL)shouldAutorotate {
    if (self.fullScreenLock) {
        return NO;
    } else {
        return YES;
    }
}

@end
