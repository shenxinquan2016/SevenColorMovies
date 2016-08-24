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

static const CGFloat StatusBarHeight = 20.0f;
static const CGFloat TitleHeight = 50.0f;/** 滑动标题栏高度 */
static const CGFloat LabelWidth = 100.f;/** 滑动标题栏宽度 */

@interface SCLivePlayerVC ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *titleScroll;/** 标题栏scrollView */
@property (nonatomic, strong) UIScrollView *contentScroll;/** 内容栏scrollView */
@property (nonatomic, strong) CALayer *bottomLine;/** 滑动短线 */
@property (nonatomic, strong) NSArray *titleArr;/** 标题数组 */



@property (atomic, strong) NSURL *url;
@property (nonatomic, strong) IJKVideoPlayerVC *IJKPlayerViewController;/** 播放器控制器 */
@end

@implementation SCLivePlayerVC

{
    BOOL _isFullScreen;
}

#pragma mark- Initialize
- (void)viewDidLoad{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    
    
    
    //3.直播视频
    self.url = [NSURL URLWithString:@"http://live.hkstv.hk.lxdns.com/live/hks/playlist.m3u8"];
    self.url = [NSURL URLWithString:@"http://49.4.161.229:9009/live/chid=8"];
    self.url = [NSURL fileURLWithPath:@"/Users/yesdgq/Movies/疯狂动物城.BD1280高清国英双语中英双字.mp4"];
    
    self.IJKPlayerViewController = [IJKVideoPlayerVC initIJKPlayerWithTitle:nil URL:self.url];
    _IJKPlayerViewController.view.frame = CGRectMake(0, 20, kMainScreenWidth, kMainScreenWidth * 9 / 16);
    [self.view addSubview:_IJKPlayerViewController.view];
    
    
    
    
    //4.全屏小屏通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchToFullScreen) name:SwitchToFullScreen object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchToSmallScreen) name:SwitchToSmallScreen object:nil];
    //5.监听屏幕旋转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
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
    //注销全屏通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:SwitchToFullScreen object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:SwitchToSmallScreen object:nil];
    //监听屏幕旋转的通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

#pragma mark- private methods
- (void)setView{
    //数据请求后组装页面
    [self getLiveChannelData];
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
    
        // 添加默认控制器
    
    
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

#pragma mark - 网络请求
//电视剧请求数据
- (void)getLiveChannelData{
    
    //请求播放资源
    [CommonFunc showLoadingWithTips:@""];
    NSDictionary *parameters = @{@"tvid" : self.filmModel._TvId ? self.filmModel : @""};
    
    [requestDataManager requestDataWithUrl:LiveProgramList parameters:parameters success:^(id  _Nullable responseObject) {
        NSLog(@"====responseObject:::%@===",responseObject);
        if (responseObject) {
            
        }
        
        //4.添加滑动headerView
//        [self constructSlideHeaderView];
        //5.添加contentScrllowView
//        [self constructContentView];
        [CommonFunc dismiss];
    
     
     } failure:^(id  _Nullable errorObject) {
         [CommonFunc dismiss];
         
     }];
}



@end
