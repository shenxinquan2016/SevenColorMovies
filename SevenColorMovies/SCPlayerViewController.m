//
//  SCPlayerViewController.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/22.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  点播播放页面

#import "SCPlayerViewController.h"
#import "SCSlideHeaderLabel.h"
#import "SCMoiveAllEpisodesVC.h"
#import "SCMoiveIntroduceVC.h"

#import <IJKMediaFramework/IJKMediaFramework.h>
#import "SCFilmModel.h"
#import "SCFilmSetModel.h"
#import "SCMoiveRecommendationCollectionVC.h"
#import "SCFilmIntroduceModel.h"
#import "SCArtsFilmsCollectionVC.h"
#import "IJKVideoPlayerVC.h"//播放器

static const CGFloat StatusBarHeight = 20.0f;
static const CGFloat TitleHeight = 50.0f;/** 滑动标题栏高度 */
static const CGFloat LabelWidth = 100.f;/** 滑动标题栏宽度 */

@interface SCPlayerViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *titleScroll;/** 标题栏scrollView */
@property (nonatomic, strong) UIScrollView *contentScroll;/** 内容栏scrollView */
@property (nonatomic, strong) CALayer *bottomLine;/** 滑动短线 */
@property (nonatomic, copy) NSString *identifier;/** 滑动标题标识 */
@property (nonatomic, copy) NSArray *titleArr;/** 标题数组 */
@property (nonatomic, strong) NSMutableArray *filmSetsArr;/** 存放所有film集 */
@property (nonatomic, strong) NSMutableArray *filmsArr;/** 综艺生活存放film */
@property (nonatomic, strong) SCFilmIntroduceModel *filmIntroduceModel;/** 影片介绍model */
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) IJKVideoPlayerVC *IJKPlayerViewController;/** 播放器控制器 */
@property (nonatomic,strong) SCArtsFilmsCollectionVC *needScrollToTopPage;
@property (nonatomic, copy) NSString *movieType;
@property (nonatomic, strong) HLJRequest *hljRequest;

@end

@implementation SCPlayerViewController

{
    BOOL _isFullScreen;
}

#pragma mark- Initialize
- (instancetype)initWithWithFilmType:(NSString *)tpye{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark-  ViewLife Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHex:@"dddddd"];
    
    //1.初始化数组
    self.filmSetsArr = [NSMutableArray arrayWithCapacity:0];
    self.filmsArr = [NSMutableArray arrayWithCapacity:0];
    
    //2.组建页面
    [self setView];
    
    //3.全屏小屏通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchToFullScreen) name:SwitchToFullScreen object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchToSmallScreen) name:SwitchToSmallScreen object:nil];
    //4.监听屏幕旋转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    //5.注册播放结束通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
    //6.注册点击列表播放通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playNewFilm:) name:PlayVODFilmWhenClick object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    VODIndex = 0;
    timesIndexOfVOD = 0;
    //注销所有通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)dealloc{
    NSLog(@"🔴%s 第%d行 \n",__func__, __LINE__);
}


#pragma mark- private methods

- (void)setView{
    
    NSString *mtype;
    if (_filmModel._Mtype) {
        
        mtype = _filmModel._Mtype;
        
    }else if (_filmModel.mtype){
        
        mtype = _filmModel.mtype;
    }
    
    NSLog(@"++++++++++++++++++++_filmModel._Mtype::::%@",mtype);
    
    // 私人影院 电影 海外片场
    if ([mtype isEqualToString:@"0"] ||
        [mtype isEqualToString:@"2"] ||
        [mtype isEqualToString:@"13"])
    {
        [self getMoveData];
        
    }else if // 综艺 生活
        ([mtype isEqualToString:@"7"] ||
         [mtype isEqualToString:@"9"])
    {
        [self getArtsAndLifeData];
        
    }else{
        //电视剧 少儿 少儿剧场 动漫 纪录片 游戏 专题
        [self getTeleplayData];
    }
}

/** 添加滚动标题栏*/
- (void)constructSlideHeaderView{
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 280, kMainScreenWidth, TitleHeight)];
    backgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backgroundView];
    
    self.titleScroll = [[UIScrollView alloc] initWithFrame:CGRectMake((kMainScreenWidth-LabelWidth*_titleArr.count)/2, 0, LabelWidth*_titleArr.count, TitleHeight)];//滚动窗口
    //    _titleScroll.backgroundColor = [UIColor greenColor];
    self.titleScroll.showsHorizontalScrollIndicator = NO;
    self.titleScroll.showsVerticalScrollIndicator = NO;
    self.titleScroll.scrollsToTop = NO;
    
    [backgroundView addSubview:_titleScroll];
    
    //0.添加lab
    [self addLabel];//添加标题label
    //1、底部滑动短线
    _bottomLine = [CALayer layer];
    [_bottomLine setBackgroundColor:[UIColor colorWithHex:@"#5184FF"].CGColor];
    _bottomLine.frame = CGRectMake(0, _titleScroll.frame.size.height-22+StatusBarHeight, LabelWidth, 2);
    
    [_titleScroll.layer addSublayer:_bottomLine];
    
}

/** 添加标题栏label */
- (void)addLabel{
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
    SCSlideHeaderLabel *lable = [self.titleScroll.subviews firstObject];
    lable.scale = 1.0;
    
    
}

#pragma mark- Event reponse
- (void)labelClick:(UITapGestureRecognizer *)recognizer{
    SCSlideHeaderLabel *label = (SCSlideHeaderLabel *)recognizer.view;
    CGFloat offsetX = label.tag * _contentScroll.frame.size.width;
    
    CGFloat offsetY = _contentScroll.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    
    [_contentScroll setContentOffset:offset animated:YES];
}

/** 添加正文内容页 */
- (void)constructContentView{
    _contentScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 338, kMainScreenWidth, kMainScreenHeight-338)];//滚动窗口
    _contentScroll.scrollsToTop = NO;
    _contentScroll.showsHorizontalScrollIndicator = NO;
    _contentScroll.pagingEnabled = YES;
    _contentScroll.delegate = self;
    //    _contentScroll.backgroundColor = [UIColor redColor];
    [self.view addSubview:_contentScroll];
    //添加子控制器
    if ([_identifier isEqualToString:@"电影"]) {
        for (int i=0; i<_titleArr.count ;i++){
            switch (i) {
                case 0:{//详情
                    SCMoiveIntroduceVC *introduceVC = DONG_INSTANT_VC_WITH_ID(@"HomePage", @"SCMoiveIntroduceVC");
                    introduceVC.model = _filmIntroduceModel;
                    [self addChildViewController:introduceVC];
                    
                    break;
                }
                case 1:{//精彩推荐
                    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];// 布局对象
                    SCMoiveRecommendationCollectionVC *vc = [[SCMoiveRecommendationCollectionVC alloc] initWithCollectionViewLayout:layout];
                    vc.filmModel = self.filmModel;
                    [self addChildViewController:vc];
                    break;
                }
                default:
                    break;
            }
            
        }
        
        // 添加默认控制器
        SCMoiveIntroduceVC *vc = [self.childViewControllers firstObject];
        vc.view.frame = self.contentScroll.bounds;
        [self.contentScroll addSubview:vc.view];
        //    self.needScrollToTopPage = self.childViewControllers[0];
        
        [self.contentScroll addSubview:vc.view];
    }else if ([_identifier isEqualToString:@"电视剧"]){
        
        for (int i=0; i<_titleArr.count ;i++){
            switch (i) {
                case 0:{//剧集
                    SCMoiveAllEpisodesVC *episodesVC = [[SCMoiveAllEpisodesVC alloc] init];
                    [self addChildViewController:episodesVC];
                    episodesVC.filmSetsArr = _filmSetsArr;
                    break;
                }
                case 1:{//详情
                    SCMoiveIntroduceVC *introduceVC = DONG_INSTANT_VC_WITH_ID(@"HomePage", @"SCMoiveIntroduceVC");
                    introduceVC.model = _filmIntroduceModel;
                    [self addChildViewController:introduceVC];
                    
                    break;
                }
                case 2:{//精彩推荐
                    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];// 布局对象
                    SCMoiveRecommendationCollectionVC *vc = [[SCMoiveRecommendationCollectionVC alloc] initWithCollectionViewLayout:layout];
                    vc.filmModel = self.filmModel;
                    [self addChildViewController:vc];
                    break;
                }
                default:
                    break;
            }
            
        }
        
        // 添加默认控制器
        SCMoiveIntroduceVC *vc = [self.childViewControllers firstObject];
        vc.view.frame = self.contentScroll.bounds;
        [self.contentScroll addSubview:vc.view];
        //    self.needScrollToTopPage = self.childViewControllers[0];
        
    }else if ([_identifier isEqualToString:@"综艺"]){
        
        for (int i=0; i<_titleArr.count ;i++){
            switch (i) {
                case 0:{// 剧集
                    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];// 布局对象
                    SCArtsFilmsCollectionVC *filmsColleView = [[SCArtsFilmsCollectionVC alloc] initWithCollectionViewLayout:layout];
                    filmsColleView.dataArray = _filmsArr;
                    [self addChildViewController:filmsColleView];
                    break;
                }
                case 1:{// 介绍
                    SCMoiveIntroduceVC *introduceVC = DONG_INSTANT_VC_WITH_ID(@"HomePage", @"SCMoiveIntroduceVC");
                    introduceVC.model = _filmIntroduceModel;
                    [self addChildViewController:introduceVC];
                    break;
                }
                default:
                    break;
            }
            
        }
        // 添加默认控制器
        SCArtsFilmsCollectionVC *vc = [self.childViewControllers firstObject];
        vc.view.frame = self.contentScroll.bounds;
        [self.contentScroll addSubview:vc.view];
        self.needScrollToTopPage = vc;
        [self doPlayNewArtsFilmBlock];
    }
    
    CGFloat contentX = self.childViewControllers.count * [UIScreen mainScreen].bounds.size.width;
    _contentScroll.contentSize = CGSizeMake(contentX, 0);
}



#pragma mark - UIScrollViewDelegate
/** 滚动结束后调用（代码导致的滚动停止） */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / _contentScroll.frame.size.width;
    // 滚动标题栏
    SCSlideHeaderLabel *titleLable = (SCSlideHeaderLabel *)_titleScroll.subviews[index];
    
    //把下划线与titieLabel的frame绑定(下划线滑动方式)
    _bottomLine.frame = CGRectMake(titleLable.frame.origin.x, _titleScroll.frame.size.height-22+StatusBarHeight, LabelWidth, 2);
    
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
    
    //    [self setScrollToTopWithTableViewIndex:index];
    
    if (vc.view.superview) return;//阻止vc重复添加
    vc.view.frame = scrollView.bounds;
    [_contentScroll addSubview:vc.view];
    
    
}

/** 滚动结束（手势导致的滚动停止） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

/** 正在滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
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
    float modulus = scrollView.contentOffset.x/_contentScroll.contentSize.width;
    _bottomLine.frame = CGRectMake(modulus * _titleScroll.contentSize.width, _titleScroll.frame.size.height-22+StatusBarHeight, LabelWidth, 2);
    
}

#pragma mark - 全屏/小屏切换
- (void)switchToFullScreen {
    // 方案一：系统旋转
    [_IJKPlayerViewController.player setScalingMode:IJKMPMovieScalingModeAspectFit];
    
    self.view.frame = [[UIScreen mainScreen] bounds];
    _IJKPlayerViewController.view.frame = self.view.bounds;
    _IJKPlayerViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth & UIViewAutoresizingFlexibleHeight;
    _IJKPlayerViewController.mediaControl.frame = self.view.frame;
    
    
    // 方案二：自定义旋转90°进入全屏
    //    [self setNeedsStatusBarAppearanceUpdate];
    //
    //    [UIView animateWithDuration:0.3 animations:^{
    //
    //        _IJKPlayerViewController.view.transform = CGAffineTransformRotate(self.view.transform, M_PI_2);
    //        _IJKPlayerViewController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    //        _IJKPlayerViewController.mediaControl.frame = CGRectMake(0, 0, kMainScreenHeight, kMainScreenWidth);
    //        [self.view bringSubviewToFront:_IJKPlayerViewController.view];
    //
    //    }];
    
}

- (void)switchToSmallScreen {
    // 方案一：系统旋转
    [_IJKPlayerViewController.player setScalingMode:IJKMPMovieScalingModeAspectFit];
    _IJKPlayerViewController.view.frame = CGRectMake(0, 20, kMainScreenWidth, kMainScreenWidth * 9 / 16);
    _IJKPlayerViewController.mediaControl.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenWidth * 9 / 16);
    
    
    // 方案二：自定义旋转90°进入全屏
    //    [self setNeedsStatusBarAppearanceUpdate];
    //
    //    [UIView animateWithDuration:0.3 animations:^{
    //
    //    _IJKPlayerViewController.view.transform = CGAffineTransformIdentity;
    //    _IJKPlayerViewController.view.frame = CGRectMake(0, 20, kMainScreenWidth, kMainScreenWidth * 9/ 16);
    //    _IJKPlayerViewController.mediaControl.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenWidth * 9/ 16);
    //
    //    }];
    
}

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
    
    switch (orient)
    {
        case UIDeviceOrientationPortrait:
            
            [_IJKPlayerViewController.player setScalingMode:IJKMPMovieScalingModeAspectFit];
            _IJKPlayerViewController.view.frame = CGRectMake(0, 20, kMainScreenWidth, kMainScreenWidth * 9 / 16);
            _IJKPlayerViewController.mediaControl.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenWidth * 9 / 16);
            
            break;
        case UIDeviceOrientationLandscapeLeft:
            
            [_IJKPlayerViewController.player setScalingMode:IJKMPMovieScalingModeAspectFit];
            
            self.view.frame = [[UIScreen mainScreen] bounds];
            _IJKPlayerViewController.view.frame = self.view.bounds;
            _IJKPlayerViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth & UIViewAutoresizingFlexibleHeight;
            _IJKPlayerViewController.mediaControl.frame = self.view.frame;
            [self.view bringSubviewToFront:_IJKPlayerViewController.view];
            
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            
            break;
        case UIDeviceOrientationLandscapeRight:
            
            [_IJKPlayerViewController.player setScalingMode:IJKMPMovieScalingModeAspectFit];
            
            self.view.frame = [[UIScreen mainScreen] bounds];
            _IJKPlayerViewController.view.frame = self.view.bounds;
            _IJKPlayerViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth & UIViewAutoresizingFlexibleHeight;
            _IJKPlayerViewController.mediaControl.frame = self.view.frame;
            [self.view bringSubviewToFront:_IJKPlayerViewController.view];
            
            break;
            
        default:
            break;
    }
}

#pragma mark - IJK播放结束的通知
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
            //当前节目播放结束，播放下一个节目
            [self playNextFilm];
            break;
            
        case IJKMPMovieFinishReasonUserExited:
            
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:
            
            break;
            
        default:
            
            break;
    }
}


#pragma mark - 播放下一个节目
- (void)playNextFilm
{
    DONG_Log(@"播放下个节目");
    NSDictionary *message;
    if ([_identifier isEqualToString:@"电影"]){
        
        return;
        
    }else if ([_identifier isEqualToString:@"电视剧"]){
        
        if (VODIndex+ ++timesIndexOfVOD < self.filmSetsArr.count) {
            DONG_Log(@"VODIndex:%lu timesIndexOfVOD: %lu",(unsigned long)VODIndex,(unsigned long)timesIndexOfVOD);
            //-1.关闭正在播放的节目
            if ([self.IJKPlayerViewController.player isPlaying]) {
                [self.IJKPlayerViewController.player pause];
            }
            
            //0.获取下一个节目的model
            SCFilmSetModel *filmSetModel = self.filmSetsArr[VODIndex+timesIndexOfVOD];
            //1.获取下一个节目的model
            SCFilmSetModel *lastFilmSetModel = self.filmSetsArr[VODIndex+timesIndexOfVOD-1];
            
            message = @{@"mextFilmSetModel" : filmSetModel,
                        @"lastFilmSetModel" : lastFilmSetModel};
            [[NSNotificationCenter defaultCenter] postNotificationName:ChangeCellStateWhenPlayNextVODFilm object:message];
            
            //2.请求播放地址
            [CommonFunc showLoadingWithTips:@""];
            [requestDataManager requestDataWithUrl:filmSetModel.VODStreamingUrl parameters:nil success:^(id  _Nullable responseObject) {
                //            NSLog(@"====responseObject:::%@===",responseObject);
                NSString *play_url = responseObject[@"play_url"];
                DONG_Log(@"responseObject:%@",play_url);
                //请求将播放地址域名转换  并拼接最终的播放地址
                NSString *newVideoUrl = [_hljRequest getNewViedoURLByOriginVideoURL:play_url];
                //1.拼接新地址
                NSString *playUrl = [NSString stringWithFormat:@"http://127.0.0.1:5656/play?url='%@'",newVideoUrl];
                self.url = [NSURL URLWithString:playUrl];
                //self.url = [NSURL fileURLWithPath:@"/Users/yesdgq/Downloads/IMG_0839.MOV"];
                //1.移除当前的播放器
                [self.IJKPlayerViewController closePlayer];
                //2.调用播放器播放
                self.IJKPlayerViewController = [IJKVideoPlayerVC initIJKPlayerWithURL:self.url];
                _IJKPlayerViewController.view.frame = CGRectMake(0, 20, kMainScreenWidth, kMainScreenWidth * 9 / 16);
                [self.view addSubview:_IJKPlayerViewController.view];
                _IJKPlayerViewController.mediaControl.programNameLabel.text = _filmModel.FilmName;//节目名称
                [CommonFunc dismiss];
                
            } failure:^(id  _Nullable errorObject) {
                
            }];
        }
    }else if ([_identifier isEqualToString:@"综艺"]){
        
        if (VODIndex+ ++timesIndexOfVOD < self.filmsArr.count) {
            //0.获取下一个节目的model
            SCFilmModel *atrsFilmModel = self.filmsArr[VODIndex+timesIndexOfVOD];
            //请求播放地址
            NSString *urlStr = [atrsFilmModel.SourceURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            //1.关闭正在播放的节目
            if ([self.IJKPlayerViewController.player isPlaying]) {
                [self.IJKPlayerViewController.player pause];
            }
            
            //获取downLoadUrl
            [requestDataManager requestDataWithUrl:urlStr parameters:nil success:^(id  _Nullable responseObject) {
                
                NSString *downLoadUrl = responseObject[@"ContentSet"][@"Content"][@"_DownUrl"];
                
                //获取fid
                NSString *fidString = [[[[downLoadUrl componentsSeparatedByString:@"?"] lastObject] componentsSeparatedByString:@"&"] firstObject];
                //base64编码downloadUrl
                NSString *downloadBase64Url = [downLoadUrl stringByBase64Encoding];
                //视频播放url
                NSString *replacedUrl = [_hljRequest getNewViedoURLByOriginVideoURL:VODUrl];
                NSString *VODStreamingUrl = [[[[[[replacedUrl stringByAppendingString:@"&mid="] stringByAppendingString:atrsFilmModel._Mid] stringByAppendingString:@"&"] stringByAppendingString:fidString] stringByAppendingString:@"&ext="] stringByAppendingString:downloadBase64Url];
                //获取play_url
                [requestDataManager requestDataWithUrl:VODStreamingUrl parameters:nil success:^(id  _Nullable responseObject) {
                    //            NSLog(@"====responseObject:::%@===",responseObject);
                    NSString *play_url = responseObject[@"play_url"];
                    DONG_Log(@"responseObject:%@",play_url);
                    //请求将播放地址域名转换  并拼接最终的播放地址
                    NSString *newVideoUrl = [self.hljRequest getNewViedoURLByOriginVideoURL:play_url];
                    //1.拼接新地址
                    NSString *playUrl = [NSString stringWithFormat:@"http://127.0.0.1:5656/play?url='%@'",newVideoUrl];
                    self.url = [NSURL URLWithString:playUrl];
                    //                    self.url = [NSURL fileURLWithPath:@"/Users/yesdgq/Downloads/IMG_0839.MOV"];
                    //1.移除播放器
                    [self.IJKPlayerViewController closePlayer];
                    //2.调用播放器播放
                    self.IJKPlayerViewController = [IJKVideoPlayerVC initIJKPlayerWithURL:self.url];
                    _IJKPlayerViewController.view.frame = CGRectMake(0, 20, kMainScreenWidth, kMainScreenWidth * 9 / 16);
                    [self.view addSubview:_IJKPlayerViewController.view];
                    _IJKPlayerViewController.mediaControl.programNameLabel.text = _filmModel.FilmName;//节目名称
                    [CommonFunc dismiss];
                    
                } failure:^(id  _Nullable errorObject) {
                    [CommonFunc dismiss];
                }];
            } failure:^(id  _Nullable errorObject) {
                
                [CommonFunc dismiss];
            }];
            
            message = @{@"filmModel" : atrsFilmModel,
                        @"VODIndex" : [NSString stringWithFormat:@"%lu",VODIndex+timesIndexOfVOD]};
            
            [[NSNotificationCenter defaultCenter] postNotificationName:ChangeCellStateWhenPlayNextVODFilm object:message];
        }
    }
}

static NSUInteger VODIndex; //首页播放回看的url在_huikanPlayerUrlArray中的第几个，这个播放完后去播放index + 1的回看
static NSUInteger timesIndexOfVOD = 0;//标记自动播放下一个节目的次数

#pragma mark - 电视剧播放列表点击事件
- (void)playNewFilm:(NSNotification *)notification
{
    NSDictionary *dic = notification.object;
    SCFilmSetModel *filmSetModel = dic[@"model"];
    VODIndex = [self.filmSetsArr indexOfObject:filmSetModel];
    
    DONG_Log(@">>>>>>>>>>%lu<<<<<<<<<<<",VODIndex);
    
    //1.关闭正在播放的节目
    if ([self.IJKPlayerViewController.player isPlaying]) {
        [self.IJKPlayerViewController.player pause];
    }
    
    //2.请求播放地址
    [CommonFunc showLoadingWithTips:@""];
    [requestDataManager requestDataWithUrl:filmSetModel.VODStreamingUrl parameters:nil success:^(id  _Nullable responseObject) {
        //            NSLog(@"====responseObject:::%@===",responseObject);
        
        NSString *play_url = responseObject[@"play_url"];
        //-1.请求将播放地址域名转换  并拼接最终的播放地址
        NSString *newVideoUrl = [_hljRequest getNewViedoURLByOriginVideoURL:play_url];
        //拼接新地址
        NSString *playUrl = [NSString stringWithFormat:@"http://127.0.0.1:5656/play?url='%@'",newVideoUrl];
        self.url = [NSURL URLWithString:playUrl];
        //self.url = [NSURL fileURLWithPath:@"/Users/yesdgq/Downloads/IMG_0839.MOV"];
        //1.移除当前的播放器
        [self.IJKPlayerViewController closePlayer];
        //2.调用播放器播放
        self.IJKPlayerViewController = [IJKVideoPlayerVC initIJKPlayerWithURL:self.url];
        _IJKPlayerViewController.view.frame = CGRectMake(0, 20, kMainScreenWidth, kMainScreenWidth * 9 / 16);
        [self.view addSubview:_IJKPlayerViewController.view];
        _IJKPlayerViewController.mediaControl.programNameLabel.text = _filmModel.FilmName;//节目名称
        [CommonFunc dismiss];
        
    } failure:^(id  _Nullable errorObject) {
        [CommonFunc dismiss];
    }];
    
    timesIndexOfVOD = 0;//每次点击后将index复位为0
}

#pragma mark - 综艺播放列表点击事件
- (void)doPlayNewArtsFilmBlock{
    DONG_WeakSelf(self);
    self.needScrollToTopPage.clickToPlayBlock = ^(NSString *urlStr,SCFilmModel *filmModel){
        DONG_StrongSelf(self);
        //1.关闭正在播放的节目
        if ([strongself.IJKPlayerViewController.player isPlaying]) {
            [strongself.IJKPlayerViewController.player pause];
        }
        
        //请求播放地址
        [CommonFunc showLoadingWithTips:@""];
        [requestDataManager requestDataWithUrl:urlStr parameters:nil success:^(id  _Nullable responseObject){
            NSString *downLoadUrl = responseObject[@"ContentSet"][@"Content"][@"_DownUrl"];
            
            //获取fid
            NSString *fidString = [[[[downLoadUrl componentsSeparatedByString:@"?"] lastObject] componentsSeparatedByString:@"&"] firstObject];
            //base64编码downloadUrl
            NSString *downloadBase64Url = [downLoadUrl stringByBase64Encoding];
            //视频播放url
            NSString *VODStreamingUrl = [[[[[[VODUrl stringByAppendingString:@"&mid="] stringByAppendingString:filmModel._Mid] stringByAppendingString:@"&"] stringByAppendingString:fidString] stringByAppendingString:@"&ext="] stringByAppendingString:downloadBase64Url];
            
            NSLog(@">>>>>>>>>>>downLoadUrl>>>>>>>>%@",downLoadUrl);
            NSLog(@">>>>>>>>>>>VODStreamingUrl>>>>>>>>%@",VODStreamingUrl);
            
            VODIndex = [self.filmsArr indexOfObject:filmModel];
            timesIndexOfVOD = 0;//每次点击后将index复位为0
            DONG_Log(@">>>>>>>>>>%lu<<<<<<<<<<<",VODIndex);
            
            //1.移除当前的播放器
            [strongself.IJKPlayerViewController closePlayer];
            //2.请求播放地址
            [requestDataManager requestDataWithUrl:VODStreamingUrl parameters:nil success:^(id  _Nullable responseObject) {
                //            NSLog(@"====responseObject:::%@===",responseObject);
                NSString *play_url = responseObject[@"play_url"];
                //请求将播放地址域名转换  并拼接最终的播放地址
                NSString *newVideoUrl = [strongself.hljRequest getNewViedoURLByOriginVideoURL:play_url];
                //1.拼接新地址
                NSString *playUrl = [NSString stringWithFormat:@"http://127.0.0.1:5656/play?url='%@'",newVideoUrl];
                strongself.url = [NSURL URLWithString:playUrl];
                //            strongself.url = [NSURL fileURLWithPath:@"/Users/yesdgq/Downloads/IMG_0839.MOV"];
                //2.调用播放器播放
                strongself.IJKPlayerViewController = [IJKVideoPlayerVC initIJKPlayerWithURL:strongself.url];
                strongself.IJKPlayerViewController.view.frame = CGRectMake(0, 20, kMainScreenWidth, kMainScreenWidth * 9 / 16);
                strongself.IJKPlayerViewController.mediaControl.programNameLabel.text = strongself.filmModel.FilmName;//节目名称
                [strongself.view addSubview:strongself.IJKPlayerViewController.view];
                strongself.IJKPlayerViewController.mediaControl.programNameLabel.text = strongself.filmModel.FilmName;//节目名称
                [CommonFunc dismiss];
                
            } failure:^(id  _Nullable errorObject) {
                [CommonFunc dismiss];
            }];
            
        } failure:^(id  _Nullable errorObject) {
            
            [CommonFunc dismiss];
        }];
        
    };
}

#pragma mark - 网络请求
//电视剧请求数据
- (void)getTeleplayData{
    
    NSString *mid;
    if (_filmModel._Mid) {
        mid = _filmModel._Mid;
    }else if (_filmModel.mid){
        mid = _filmModel.mid;
    }
    
    NSString *filmmidStr = mid ? mid : @"";
    //请求播放资源
    [CommonFunc showLoadingWithTips:@""];
    NSDictionary *parameters = @{@"pagesize" : @"1000",
                                 @"filmmid" : filmmidStr};
    
    self.hljRequest = [HLJRequest requestWithPlayVideoURL:FilmSourceUrl];
    [_hljRequest getNewVideoURLSuccess:^(NSString *newVideoUrl) {
        
        [requestDataManager requestDataWithUrl:newVideoUrl parameters:parameters success:^(id  _Nullable responseObject) {
            //NSLog(@"====responseObject:::%@===",responseObject);
            if (responseObject) {
                
                NSString *mid = responseObject[@"Film"][@"_Mid"];
                
                //介绍页model
                self.filmIntroduceModel  = [SCFilmIntroduceModel mj_objectWithKeyValues:responseObject[@"Film"]];
                
                if ([responseObject[@"ContentSet"][@"Content"] isKindOfClass:[NSDictionary class]]){
                    SCFilmSetModel *model = [SCFilmSetModel mj_objectWithKeyValues:responseObject[@"ContentSet"][@"Content"]];
                    
                    NSString *downloadUrl = responseObject[@"ContentSet"][@"Content"][@"_DownUrl"];
                    
                    //base64编码downloadUrl
                    NSString *downloadBase64Url = [downloadUrl stringByBase64Encoding];
                    
                    //获取fid
                    NSString *fidString = [[[[downloadUrl componentsSeparatedByString:@"?"] lastObject] componentsSeparatedByString:@"&"] firstObject];
                    //base64编码downloadUrl
                    
                    //视频播放url
                    NSString *replacedUrl = [_hljRequest getNewViedoURLByOriginVideoURL:VODUrl];
                    NSString *VODStreamingUrl = [[[[[[replacedUrl stringByAppendingString:@"&mid="] stringByAppendingString:mid] stringByAppendingString:@"&"] stringByAppendingString:fidString] stringByAppendingString:@"&ext="] stringByAppendingString:downloadBase64Url];
                    
                    model.VODStreamingUrl = VODStreamingUrl;
                    
                    //NSLog(@">>>>>>>>>>>DownUrl>>>>>>>>>>>>>%@",downloadUrl);
                    //NSLog(@">>>>>>>>>>>>VODStreamingUrl>>>>>>>>>>>%@",model.VODStreamingUrl);
                    [_filmSetsArr addObject:model];
                    
                }else if ([responseObject[@"ContentSet"][@"Content"] isKindOfClass:[NSArray class]]){
                    
                    
                    for (NSDictionary *dic in responseObject[@"ContentSet"][@"Content"]) {
                        
                        SCFilmSetModel *model = [SCFilmSetModel mj_objectWithKeyValues:dic];
                        
                        
                        //downloadUrl
                        NSString *downloadUrl = dic[@"_DownUrl"];
                        
                        //base64编码downloadUrl
                        NSString *downloadBase64Url = [downloadUrl stringByBase64Encoding];
                        
                        //获取fid
                        NSString *fidString = [[[[downloadUrl componentsSeparatedByString:@"?"] lastObject] componentsSeparatedByString:@"&"] firstObject];
                        //base64编码downloadUrl
                        
                        //视频播放url
                        NSString *replacedUrl = [_hljRequest getNewViedoURLByOriginVideoURL:VODUrl];
                        NSString *VODStreamingUrl = [[[[[[replacedUrl stringByAppendingString:@"&mid="] stringByAppendingString:mid] stringByAppendingString:@"&"] stringByAppendingString:fidString] stringByAppendingString:@"&ext="] stringByAppendingString:downloadBase64Url];
                        
                        model.VODStreamingUrl = VODStreamingUrl;
                        //NSLog(@">>>>>>>>>>>DownUrl>>>>>>>>>>>>>%@",downloadUrl);
                        //NSLog(@">>>>>>>>>>>>VODStreamingUrl>>>>>>>>>>>%@",model.VODStreamingUrl);
                        [_filmSetsArr addObject:model];
                        
                    }
                }
                SCFilmSetModel *model = [_filmSetsArr firstObject];
                model.onLive = YES;
                
                if (_filmSetsArr.count == 1) {
                    
                    self.titleArr = @[@"详情", @"精彩推荐"];
                    self.identifier = @"电影";
                    
                }else if (_filmSetsArr.count > 1){
                    self.titleArr = @[@"剧情", @"详情", @"精彩推荐"];
                    self.identifier = @"电视剧";
                    
                }
                //1.添加滑动headerView
                [self constructSlideHeaderView];
                //2.添加contentScrllowView
                [self constructContentView];
                
                //请求第一集的播放地址
                [requestDataManager requestDataWithUrl:model.VODStreamingUrl parameters:nil success:^(id  _Nullable responseObject) {
                    //            NSLog(@"====responseObject:::%@===",responseObject);
                    NSString *play_url = responseObject[@"play_url"];
                    DONG_Log(@"responseObject:%@",play_url);
                    //请求将播放地址域名转换  并拼接最终的播放地址
                    self.hljRequest = [HLJRequest requestWithPlayVideoURL:play_url];
                    [_hljRequest getNewVideoURLSuccess:^(NSString *newVideoUrl) {
                        
                        DONG_Log(@"newVideoUrl:%@",newVideoUrl);
                        //1.拼接新地址
                        NSString *playUrl = [NSString stringWithFormat:@"http://127.0.0.1:5656/play?url='%@'",newVideoUrl];
                        self.url = [NSURL URLWithString:playUrl];
                        //self.url = [NSURL fileURLWithPath:@"/Users/yesdgq/Downloads/IMG_0839.MOV"];
                        
                        //2.调用播放器播放
                        self.IJKPlayerViewController = [IJKVideoPlayerVC initIJKPlayerWithURL:self.url];
                        _IJKPlayerViewController.view.frame = CGRectMake(0, 20, kMainScreenWidth, kMainScreenWidth * 9 / 16);
                        [self.view addSubview:_IJKPlayerViewController.view];
                        _IJKPlayerViewController.mediaControl.programNameLabel.text = _filmModel.FilmName;//节目名称
                        [CommonFunc dismiss];
                    } failure:^(NSError *error) {
                        [CommonFunc dismiss];
                    }];
                    
                } failure:^(id  _Nullable errorObject) {
                    [CommonFunc dismiss];
                }];
            }
            
        } failure:^(id  _Nullable errorObject) {
            [CommonFunc dismiss];
            
        }];
        
    } failure:^(NSError *error) {
        
        [CommonFunc dismiss];
    }];
}

//综艺请求数据
- (void)getArtsAndLifeData{
    
    NSString *mid;
    if (_filmModel._Mid) {
        mid = _filmModel._Mid;
    }else if (_filmModel.mid){
        mid = _filmModel.mid;
    }
    
    NSString *filmmidStr = mid ? mid : @"";
    
    NSDictionary *parameters = @{@"pagesize" : @"1000",
                                 @"filmmid" : filmmidStr};
    [CommonFunc showLoadingWithTips:@""];
    DONG_WeakSelf(self);
    self.hljRequest = [HLJRequest requestWithPlayVideoURL:ArtsAndLifeSourceUrl];
    [_hljRequest getNewVideoURLSuccess:^(NSString *newVideoUrl) {
        [requestDataManager requestDataWithUrl:newVideoUrl parameters:parameters success:^(id  _Nullable responseObject) {
            DONG_StrongSelf(self);
            //        NSLog(@"====responseObject======%@===",responseObject);
            [strongself.filmsArr removeAllObjects];
            if (responseObject) {
                
                //介绍页model
                strongself.filmIntroduceModel  = [SCFilmIntroduceModel mj_objectWithKeyValues:responseObject[@"ParentFilm"]];
                
                if ([responseObject[@"Film"] isKindOfClass:[NSDictionary class]]){
                    
                    SCFilmModel *model = [SCFilmModel mj_objectWithKeyValues:responseObject[@"Film"]];
                    model.onLive = YES;
                    [strongself.filmsArr addObject:model];
                    
                }else if ([responseObject[@"Film"] isKindOfClass:[NSArray class]]){
                    
                    [responseObject[@"Film"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        NSDictionary *dic = obj;
                        SCFilmModel *model = [SCFilmModel mj_objectWithKeyValues:dic];
                        if (idx == 0) {
                            model.onLive = YES;
                        }
                        [strongself.filmsArr addObject:model];
                    }];
                }
            }
            strongself.titleArr = @[@"剧情", @"详情"];
            strongself.identifier = @"综艺";
            
            //4.添加滑动headerView
            [strongself constructSlideHeaderView];
            [strongself constructContentView];
            
            //请求播放地址
            SCFilmModel *atrsFilmModel = [strongself.filmsArr firstObject];
            NSString *urlStr = [atrsFilmModel.SourceURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //获取downLoadUrl
            [requestDataManager requestDataWithUrl:urlStr parameters:nil success:^(id  _Nullable responseObject) {
                
                NSString *downLoadUrl = responseObject[@"ContentSet"][@"Content"][@"_DownUrl"];
                
                //获取fid
                NSString *fidString = [[[[downLoadUrl componentsSeparatedByString:@"?"] lastObject] componentsSeparatedByString:@"&"] firstObject];
                //base64编码downloadUrl
                NSString *downloadBase64Url = [downLoadUrl stringByBase64Encoding];
                //视频播放url
                NSString *replacedUrl = [strongself.hljRequest getNewViedoURLByOriginVideoURL:VODUrl];
                NSString *VODStreamingUrl = [[[[[[replacedUrl stringByAppendingString:@"&mid="] stringByAppendingString:atrsFilmModel._Mid] stringByAppendingString:@"&"] stringByAppendingString:fidString] stringByAppendingString:@"&ext="] stringByAppendingString:downloadBase64Url];
                //获取play_url
                [requestDataManager requestDataWithUrl:VODStreamingUrl parameters:nil success:^(id  _Nullable responseObject) {
                    //            NSLog(@"====responseObject:::%@===",responseObject);
                    NSString *play_url = responseObject[@"play_url"];
                    DONG_Log(@"responseObject:%@",play_url);
                    //请求将播放地址域名转换  并拼接最终的播放地址
                    NSString *newVideoUrl = [strongself.hljRequest getNewViedoURLByOriginVideoURL:play_url];
                    DONG_Log(@"newVideoUrl:%@",newVideoUrl);
                    //1.拼接新地址
                    NSString *playUrl = [NSString stringWithFormat:@"http://127.0.0.1:5656/play?url='%@'",newVideoUrl];
                    strongself.url = [NSURL URLWithString:playUrl];
                    //2.调用播放器播放
                    strongself.IJKPlayerViewController = [IJKVideoPlayerVC initIJKPlayerWithURL:strongself.url];
                    strongself.IJKPlayerViewController.view.frame = CGRectMake(0, 20, kMainScreenWidth, kMainScreenWidth * 9 / 16);
                    [strongself.view addSubview:strongself.IJKPlayerViewController.view];
                    strongself.IJKPlayerViewController.mediaControl.programNameLabel.text = strongself.filmModel.FilmName;//节目名称
                    [CommonFunc dismiss];
                    
                } failure:^(id  _Nullable errorObject) {
                    [CommonFunc dismiss];
                }];
            } failure:^(id  _Nullable errorObject) {
                
                [CommonFunc dismiss];
            }];
            
        } failure:^(id  _Nullable errorObject) {
            
            [CommonFunc dismiss];
        }];
        
    } failure:^(NSError *error) {
        [CommonFunc dismiss];
        
    }];
}

//电影请求数据
- (void)getMoveData{
    
    [CommonFunc showLoadingWithTips:@""];
    
    NSString *mid;
    if (_filmModel._Mid) {
        mid = _filmModel._Mid;
    }else if (_filmModel.mid){
        mid = _filmModel.mid;
    }
    
    NSString *filmmidStr = mid ? mid : @"";
    
    NSDictionary *parameters = @{@"pagesize" : @"1000",
                                 @"filmmid" : filmmidStr};
    
    DONG_WeakSelf(self);
    //请求film详细信息
    self.hljRequest = [HLJRequest requestWithPlayVideoURL:FilmSourceUrl];
    [_hljRequest getNewVideoURLSuccess:^(NSString *newVideoUrl) {
        
        [requestDataManager requestDataWithUrl:newVideoUrl parameters:parameters success:^(id  _Nullable responseObject) {
            //        DONG_Log(@"====responseObject:::%@===",responseObject);
            
            DONG_StrongSelf(self);
            //介绍页model
            strongself.filmIntroduceModel  = [SCFilmIntroduceModel mj_objectWithKeyValues:responseObject[@"Film"]];
            
            // 坑：：单片不同film竟然数据结构不同 服了！
            //downloadUrl
            NSString *downloadUrl;
            if ([responseObject[@"ContentSet"][@"Content"] isKindOfClass:[NSDictionary class]]){
                
                downloadUrl = responseObject[@"ContentSet"][@"Content"][@"_DownUrl"];
                
            }else if ([responseObject[@"ContentSet"][@"Content"] isKindOfClass:[NSArray class]]){
                
                downloadUrl = [responseObject[@"ContentSet"][@"Content"] firstObject][@"_DownUrl"];
            }
            
            //base64编码downloadUrl
            NSString *downloadBase64Url = [downloadUrl stringByBase64Encoding];
            
            //获取fid
            NSString *fidString = [[[[downloadUrl componentsSeparatedByString:@"?"] lastObject] componentsSeparatedByString:@"&"] firstObject];
            
            //这只是个请求视频播放流的url地址
            NSString *replacedUrl = [strongself.hljRequest getNewViedoURLByOriginVideoURL:VODUrl];
            NSString *VODStreamingUrl = [[[[[[replacedUrl stringByAppendingString:@"&mid="] stringByAppendingString:mid] stringByAppendingString:@"&"] stringByAppendingString:fidString] stringByAppendingString:@"&ext="] stringByAppendingString:downloadBase64Url];
            
            //DONG_Log(@">>>>>>>>>>>DownUrl>>>>>>>>>>%@",downloadUrl);
            //DONG_Log(@">>>>>>>>>>>>VODStreamingUrl>>>>>>>>>>%@",VODStreamingUrl);
            //请求播放地址
            [requestDataManager requestDataWithUrl:VODStreamingUrl parameters:nil success:^(id  _Nullable responseObject) {
                //                //            NSLog(@"====responseObject:::%@===",responseObject);
                NSString *play_url = responseObject[@"play_url"];
                DONG_Log(@"responseObject:%@",play_url);
                //请求将播放地址域名转换  并拼接最终的播放地址
                NSString *newVideoUrl = [strongself.hljRequest getNewViedoURLByOriginVideoURL:play_url];
                
                DONG_Log(@"newVideoUrl:%@",newVideoUrl);
                //1.拼接新地址
                NSString *playUrl = [NSString stringWithFormat:@"http://127.0.0.1:5656/play?url='%@'",newVideoUrl];
                strongself.url = [NSURL URLWithString:playUrl];
                //2.调用播放器播放
                strongself.IJKPlayerViewController = [IJKVideoPlayerVC initIJKPlayerWithURL:strongself.url];
                strongself.IJKPlayerViewController.view.frame = CGRectMake(0, 20, kMainScreenWidth, kMainScreenWidth * 9 / 16);
                [strongself.view addSubview:strongself.IJKPlayerViewController.view];
                strongself.IJKPlayerViewController.mediaControl.programNameLabel.text = strongself.filmModel.FilmName;//节目名称
                [CommonFunc dismiss];
                
            } failure:^(id  _Nullable errorObject) {
                [CommonFunc dismiss];
            }];
            
            strongself.titleArr = @[@"详情", @"精彩推荐"];
            strongself.identifier = @"电影";
            
            //4.添加滑动headerView
            [strongself constructSlideHeaderView];
            [strongself constructContentView];
            
        } failure:^(id  _Nullable errorObject) {
            
            [CommonFunc dismiss];
        }];
        
    } failure:^(NSError *error) {
        [CommonFunc dismiss];
        
    }];
    
}

#pragma mark - 更新状态栏状态 使用旋转方案二时调用
- (BOOL)prefersStatusBarHidden{
    if (_IJKPlayerViewController.isFullScreen) {
        return YES;//如果全屏，隐藏状态栏
    }
    return NO;
}

@end
