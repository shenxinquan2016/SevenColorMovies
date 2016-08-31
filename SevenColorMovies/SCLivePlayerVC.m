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

//static const CGFloat StatusBarHeight = 20.0f;
static const CGFloat TitleHeight = 50.0f;/** 滑动标题栏高度 */
static const CGFloat LabelWidth = 55.f;/** 滑动标题栏宽度 */

@interface SCLivePlayerVC ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *titleScroll;/** 标题栏scrollView */
@property (nonatomic, strong) UIScrollView *contentScroll;/** 内容栏scrollView */
@property (nonatomic, strong) CALayer *bottomLine;/** 滑动短线 */
@property (nonatomic, strong) NSMutableArray *titleArr;/** 标题数组 */
@property (nonatomic, strong) NSMutableArray *programModelArr;/** 标题数组 */
@property (nonatomic, strong) NSMutableArray *dataSourceArr;/** 标题数组 */
@property (nonatomic, strong) SCLiveProgramListCollectionVC *needScrollToTopPage;/** 在当前页设置点击顶部滚动复位 */
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) IJKVideoPlayerVC *IJKPlayerViewController;/** 播放器控制器 */
@property (nonatomic, assign) NSInteger index;/** 正在播出节目的index */


@end

@implementation SCLivePlayerVC

{
    BOOL _isFullScreen;
    SCLiveProgramModel *model_;/* 接收所选中行的model 接收回调传值 */
    NSArray *liveProgramModelArray_;/* 选中行所在页的数组 接收回调传值 */
}

#pragma mark- Initialize
- (void)viewDidLoad{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHex:@"#f3f3f3"];
    //1.初始化数组
    self.titleArr = [NSMutableArray arrayWithCapacity:0];
    self.programModelArr = [NSMutableArray arrayWithCapacity:0];
    self.dataSourceArr = [NSMutableArray arrayWithCapacity:0];
    
    
    [self setView];
    
    //4.全屏小屏通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchToFullScreen) name:SwitchToFullScreen object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchToSmallScreen) name:SwitchToSmallScreen object:nil];
    //5.监听屏幕旋转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    
    
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    //注册播放结束通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_IJKPlayerViewController.player];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //注销全屏通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:SwitchToFullScreen object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:SwitchToSmallScreen object:nil];
    //监听屏幕旋转的通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    //注销播放器播放结束的通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:_IJKPlayerViewController.player];
}

#pragma mark- private methods
- (void)setView{
    //请求该频道直播流url
    [self getLiveVideoSignalFlowUrl];
    
    //请求直播节目列表数据后组装页面
    [self getLiveChannelData];
    
}

/** 添加滚动标题栏*/
- (void)constructSlideHeaderView{
    
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
    SCSlideHeaderLabel *lable = [self.titleScroll.subviews lastObject];
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
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
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
    //    float modulus = scrollView.contentOffset.x/_contentScroll.contentSize.width;
    //    _bottomLine.frame = CGRectMake(modulus * _titleScroll.contentSize.width, _titleScroll.frame.size.height-22+StatusBarHeight, LabelWidth, 2);
    
}

#pragma mark - IJK播放控制器的回调
- (void)doIJKPlayerBlock{
    DONGWeakSelf(self);
    //点击节目list切换节目
    _needScrollToTopPage.clickToPlayBlock = ^(SCLiveProgramModel *model, SCLiveProgramModel *nextProgramModel, NSArray *liveProgramModelArray){
        model_ = model;
        liveProgramModelArray_ = liveProgramModelArray;
        //请求url并播放
        [weakself requestProgramHavePastVideoSignalFlowUrlWithModel:model NextProgramModel:nextProgramModel];
        timesIndexOfHuikan = 0;//每次点击后将index复位为0
    };
    
}

static NSUInteger huikanIndex; //首页播放回看的url在_huikanPlayerUrlArray中的第几个，这个播放完后去播放index + 1的回看
static NSUInteger timesIndexOfHuikan = 0;//标记自动播放下一个节目的次数

#pragma mark - 播放下一个节目
- (void)playNextProgram{
    
    huikanIndex = [liveProgramModelArray_ indexOfObject:model_];
    NSLog(@">>>>>>>>>>>index::::%lu",huikanIndex);
    NSLog(@"这个节目播放结束了,播放下一个节目");

    if (huikanIndex+1+ ++timesIndexOfHuikan < liveProgramModelArray_.count) {
        
        SCLiveProgramModel *model1 = liveProgramModelArray_[huikanIndex+timesIndexOfHuikan];
        SCLiveProgramModel *model2 = liveProgramModelArray_[huikanIndex+timesIndexOfHuikan+1];
        //请求url并播放
        [self requestProgramHavePastVideoSignalFlowUrlWithModel:model1 NextProgramModel:model2];
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



#pragma mark - 网络请求
//请求回看节目视频流url
- (void)requestProgramHavePastVideoSignalFlowUrlWithModel:(SCLiveProgramModel *)model1 NextProgramModel:(SCLiveProgramModel *)model2{
    
    //1.关闭正在播放的节目
    if ([self.IJKPlayerViewController.player isPlaying]) {
        [self.IJKPlayerViewController.player shutdown];
    }
    //2.加载动画
    [CommonFunc showLoadingWithTips:@"视频加载中..."];
    //3.请求播放地址url
    
    NSString *startTime = model1.programTime;
    NSString *endTime = model2.programTime;
    NSLog(@"<<<<<<<<<<<<<<播放新节目:%@>>>下一个节目：%@>>>>>>>>",model1.programName, model2.programName);
    NSLog(@"<<<<<<<<<<<<<<开始时间：%@  结束时间：%@>>>>>>>>>>>",startTime, endTime);
    
    
    NSString *fidStr = [[_filmModel._TvId stringByAppendingString:@"_"] stringByAppendingString:_filmModel._TvId];
    NSDictionary *parameters = @{@"fid" : fidStr};
    [requestDataManager requestDataWithUrl:ToGetProgramHavePastVideoSignalFlowUrl parameters:parameters success:^(id  _Nullable responseObject) {
        
        //NSLog(@"====responseObject:::%@===",responseObject);
        
        NSString *liveUrl = responseObject[@"play_url"];
        
        NSLog(@">>>>>>ToGetLiveVideoSignalFlowUrl>>>>>%@>>>>>>>",liveUrl);
        
        
        
        self.url = [NSURL fileURLWithPath:@"/Users/yesdgq/Downloads/IMG_0839.MOV"];
        //        self.url = [NSURL URLWithString:@"http://live.hkstv.hk.lxdns.com/live/hks/playlist.m3u8"];
        
        //4.移除当前的播放器
        [self.IJKPlayerViewController closePlayer];
        
        //5.加载新的播放器开始播放
        self.IJKPlayerViewController = [IJKVideoPlayerVC initIJKPlayerWithTitle:nil URL:self.url];
        self.IJKPlayerViewController.view.frame = CGRectMake(0, 20, kMainScreenWidth, kMainScreenWidth * 9 / 16);
        [self.view addSubview:self.IJKPlayerViewController.view];
        
        [CommonFunc dismiss];
    } failure:^(id  _Nullable errorObject) {
        [CommonFunc dismiss];
        
    }];
    
    
}
//请求该频道直播流url
- (void)getLiveVideoSignalFlowUrl{
    //fid = tvId + "_" + tvId
    NSString *fidStr = [[_filmModel._TvId stringByAppendingString:@"_"] stringByAppendingString:_filmModel._TvId];
    //hid = 设备的mac地址
    
    NSDictionary *parameters = @{@"fid" : fidStr,
                                 @"hid" : @""};
    [requestDataManager requestDataWithUrl:ToGetLiveVideoSignalFlowUrl parameters:parameters success:^(id  _Nullable responseObject) {
        
        NSString *liveUrl = responseObject[@"play_url"];
        
        NSLog(@">>>>>>ToGetLiveVideoSignalFlowUrl>>>>>%@>>>>>>>",liveUrl);
        
        //开始播放直播
        //3.直播视频
        self.url = [NSURL URLWithString:@"http://live.hkstv.hk.lxdns.com/live/hks/playlist.m3u8"];
        self.url = [NSURL URLWithString:@"http://49.4.161.229:9009/live/chid=8"];
        self.url = [NSURL fileURLWithPath:@"/Users/yesdgq/Movies/疯狂动物城.BD1280高清国英双语中英双字.mp4"];
        //        self.url = [NSURL fileURLWithPath:@"http://10.177.1.245/IndexProxy.do?action=b2bplayauth&playtype=1000&mid=1&sid=1&pid=1&uid=10&oemid=30050&fid=230_230&hid=&time=10000&proto=9&key=_tv_230.m3u8"];
        
        self.IJKPlayerViewController = [IJKVideoPlayerVC initIJKPlayerWithTitle:nil URL:self.url];
        _IJKPlayerViewController.view.frame = CGRectMake(0, 20, kMainScreenWidth, kMainScreenWidth * 9 / 16);
        [self.view addSubview:_IJKPlayerViewController.view];
        
        [CommonFunc dismiss];
    } failure:^(id  _Nullable errorObject) {
        [CommonFunc dismiss];
        
    }];
    
}

//请求直播节目列表数据
- (void)getLiveChannelData{
    
    [CommonFunc showLoadingWithTips:@""];
    NSDictionary *parameters = @{@"tvid" : self.filmModel._TvId ? self.filmModel._TvId : @""};
    [requestDataManager requestDataWithUrl:LiveProgramList parameters:parameters success:^(id  _Nullable responseObject) {
        //        NSLog(@"====responseObject:::%@===",responseObject);
        [_dataSourceArr removeAllObjects];
        NSArray *array = responseObject[@"FilmClass"][@"FilmlistSet"];
        if (array.count > 0) {
            //
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
                        //
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
                        //获取节目状态
                        //4.当前时间
                        NSDate *currenDate = [NSDate date];
                        
                        //5.日期比较
                        
                        NSTimeInterval secondsInterval = [currenDate timeIntervalSinceDate:pragramDate];
                        
                        if (secondsInterval >= 0) {
                            if (idx+1 < arr.count) {
                                //获取下一个节目的开始时间
                                NSDictionary *dic2 = arr[idx+1];
                                NSString *forecastDateString2 = dic2[@"_ForecastDate"];
                                formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";//格式化对象的样式/z大小写都行/格式必须严格和字符串时间一样
                                NSDate *pragramDate2 = [formatter dateFromString:forecastDateString2];
                                //日期比较
                                NSTimeInterval secondsInterval2 = [currenDate timeIntervalSinceDate:pragramDate2];
                                
                                if (secondsInterval2 < 0) {//当前时间比当前节目的开始时间晚且比下一个节目的开始时间早，当前节目即为正在播出节目
                                    
                                    programModel.programState = NowPlaying;
                                    programModel.onLive = YES;
                                    _index = idx;//正在播出节目的index
                                    
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
        
        
        //4.添加滑动headerView
        [self constructSlideHeaderView];
        //5.添加contentScrllowView
        [self constructContentView];
        
        
        
    } failure:^(id  _Nullable errorObject) {
        [CommonFunc dismiss];
        
    }];
}




@end
