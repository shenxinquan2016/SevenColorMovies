//
//  SCPlayerViewController.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/22.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

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


static const CGFloat TitleHeight = 50.0f;
static const CGFloat StatusBarHeight = 20.0f;
static const CGFloat LabelWidth = 100.f;

@interface SCPlayerViewController ()<UIScrollViewDelegate>

/** 标题栏scrollView */
@property (nonatomic, strong) UIScrollView *titleScroll;

/** 内容栏scrollView */
@property (nonatomic, strong) UIScrollView *contentScroll;

/** 滑动短线 */
@property (nonatomic, strong) CALayer *bottomLine;

/** 滑动标题标识 */
@property (nonatomic, copy) NSString *identifier;

/** 标题数组 */
@property (nonatomic, strong) NSArray *titleArr;

/** 存放所有集 */
@property (nonatomic, strong) NSMutableArray *filmSetsArr;

/** 综艺生活存放film */
@property (nonatomic, strong) NSMutableArray *filmsArr;

@property (nonatomic, strong) SCFilmIntroduceModel *filmIntroduceModel;

/** 电影播放地址url*/
@property (nonatomic, strong) NSString *VODStreamingUrl;

/////测试播放器
@property (atomic, strong) NSURL *url;
@property (atomic, retain) id <IJKMediaPlayback> player;
@property (weak, nonatomic) UIView *PlayerView;
@end

@implementation SCPlayerViewController


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
    
    //3.初始化数组
    
    self.filmSetsArr = [NSMutableArray arrayWithCapacity:0];
    self.filmsArr = [NSMutableArray arrayWithCapacity:0];
    
    [self setView];
    
    
    
    
}

- (void)doPlay{
    
    //直播视频
    self.url = [NSURL URLWithString:@"http://live.hkstv.hk.lxdns.com/live/hks/playlist.m3u8"];
    
    //    SCFilmSetModel *model = _filmSetsArr.firstObject;
    //    self.url = [NSURL URLWithString:model.VODStreamingUrl];
    //    NSLog(@">>>>>>>>>>>model._DownUrl::::%@",model.VODStreamingUrl);
    //直播地址
    //    self.url = [NSURL URLWithString:@"http://49.4.161.229:9009/live/chid=8"];
    
    _player = [[IJKFFMoviePlayerController alloc] initWithContentURL:self.url withOptions:nil];
    
    UIView *playerView = [self.player view];
    
    UIView *displayView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 213)];
    self.PlayerView = displayView;
    self.PlayerView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.PlayerView];
    
    playerView.frame = self.PlayerView.bounds;
    playerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.PlayerView insertSubview:playerView atIndex:1];
    [_player setScalingMode:IJKMPMovieScalingModeAspectFill];
    [self installMovieNotificationObservers];
    
    
}

- (void)setView{
    
    NSString *mtype;
    if (_filmModel._Mtype) {
        
        mtype = _filmModel._Mtype;
        
    }else if (_filmModel.mtype){
        
        mtype = _filmModel.mtype;
    }
    
    NSLog(@"++++++++++++++++++++_filmModel._Mtype::::%@",mtype);

    // 电影
    if ([mtype isEqualToString:@"0"] ||
        [mtype isEqualToString:@"2"] ||
        [mtype isEqualToString:@"10"] ||
        [mtype isEqualToString:@"13"] ||
        [mtype isEqualToString:@"15"])
    {
        self.titleArr = @[@"详情", @"精彩推荐"];
        self.identifier = @"电影";
        [self getMoveData];
        
    }else if // 综艺 生活
             ([mtype isEqualToString:@"7"] ||
              [mtype isEqualToString:@"9"] ||
              [mtype isEqualToString:@"30"])
    {
        self.titleArr = @[@"剧情", @"详情"];
        self.identifier = @"综艺";

        [self getArtsAndLifeData];
        
    
        
    }else{
        //电视剧 少儿
        self.titleArr = @[@"剧情", @"详情", @"精彩推荐"];
        self.identifier = @"电视剧";

        [self getTeleplayData];
    }
    
    
    //    [self doPlay];
    
    
}
#pragma Install Notifiacation

- (void)installMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_player];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackFinish:)
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


- (void)removeMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:_player];
    
}


#pragma Selector func

- (void)loadStateDidChange:(NSNotification*)notification {
    IJKMPMovieLoadState loadState = _player.loadState;
    
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        NSLog(@"LoadStateDidChange: IJKMovieLoadStatePlayThroughOK: %d\n",(int)loadState);
    }else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
    } else {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}

- (void)moviePlayBackFinish:(NSNotification*)notification {
    int reason =[[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    switch (reason) {
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

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification {
    NSLog(@"mediaIsPrepareToPlayDidChange\n");
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification {
    switch (_player.playbackState) {
        case IJKMPMoviePlaybackStateStopped:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStatePlaying:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStatePaused:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStateInterrupted:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
            break;
            
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





- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    if (![self.player isPlaying]) {
        [self.player prepareToPlay];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self removeMovieNotificationObservers];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)playVideo:(id)sender {
    
    
    if (![self.player isPlaying]) {
        [self.player play];
    }else{
        [self.player pause];
    }
    
    
    
}

#pragma mark- private methods
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
        CGFloat lbW = LabelWidth;                //宽
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
                    filmsColleView.dataSource = _filmsArr;
                    
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
        //    self.needScrollToTopPage = self.childViewControllers[0];
        
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
    
    [requestDataManager requestDataWithUrl:FilmSourceUrl parameters:parameters success:^(id  _Nullable responseObject) {
//                    NSLog(@"====responseObject:::%@===",responseObject);
        if (responseObject) {
            
            NSString *mid = responseObject[@"Film"][@"_Mid"];
            
            //介绍页model
            self.filmIntroduceModel  = [SCFilmIntroduceModel mj_objectWithKeyValues:responseObject[@"Film"]];
            
            for (NSDictionary *dic in responseObject[@"ContentSet"][@"Content"]) {
                
                SCFilmSetModel *model = [SCFilmSetModel mj_objectWithKeyValues:dic];
                //获取fid
                NSString *fidString = [[[[model._DownUrl componentsSeparatedByString:@"?"] lastObject] componentsSeparatedByString:@"&"] firstObject];
                //base64编码downloadUrl
                NSString *downloadBase64Url = [model._DownUrl stringByBase64Encoding];
                //视频播放url
                NSString *VODStreamingUrl = [[[[[[VODUrl stringByAppendingString:@"&mid="] stringByAppendingString:mid] stringByAppendingString:@"&"] stringByAppendingString:fidString] stringByAppendingString:@"&ext="] stringByAppendingString:downloadBase64Url];
                
                model.VODStreamingUrl = VODStreamingUrl;
                NSLog(@">>>>>>>>>>>model._DownUrl>>>>>>>>>>>>>%@",model._DownUrl);
                NSLog(@">>>>>>>>>>>>VODStreamingUrl>>>>>>>>>>>%@",model.VODStreamingUrl);
                [_filmSetsArr addObject:model];
                
                [CommonFunc dismiss];
                //5.添加contentScrllowView
            }
            
            //4.添加滑动headerView
            [self constructSlideHeaderView];
            [self constructContentView];
            
        }
        
    } failure:^(id  _Nullable errorObject) {
        
        
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
    [requestDataManager requestDataWithUrl:ArtsAndLifeSourceUrl parameters:parameters success:^(id  _Nullable responseObject) {
        NSLog(@"====responseObject======%@===",responseObject);
        [_filmsArr removeAllObjects];
        if (responseObject) {
            
            //介绍页model
            self.filmIntroduceModel  = [SCFilmIntroduceModel mj_objectWithKeyValues:responseObject[@"ParentFilm"]];

            for (NSDictionary *dic in responseObject[@"Film"]) {
            
                SCFilmModel *model = [SCFilmModel mj_objectWithKeyValues:dic];
                [_filmsArr addObject:model];
        
            }
        }
        
        //4.添加滑动headerView
        [self constructSlideHeaderView];
        [self constructContentView];
        [CommonFunc dismiss];
    } failure:^(id  _Nullable errorObject) {
        
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
    
    
    NSLog(@"====filmmidStr:::%@===",filmmidStr);
    [requestDataManager requestDataWithUrl:FilmSourceUrl parameters:parameters success:^(id  _Nullable responseObject) {
        NSLog(@"====responseObject:::%@===",responseObject);
        if (responseObject) {
            //介绍页model
            self.filmIntroduceModel  = [SCFilmIntroduceModel mj_objectWithKeyValues:responseObject[@"Film"]];
            
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
            
            
            NSString *VODStreamingUrl = [[[[[[VODUrl stringByAppendingString:@"&mid="] stringByAppendingString:mid] stringByAppendingString:@"&"] stringByAppendingString:fidString] stringByAppendingString:@"&ext="] stringByAppendingString:downloadBase64Url];
            
            _VODStreamingUrl = VODStreamingUrl;
             NSLog(@">>>>>>>>>>>DownUrl>>>>>>>>>>%@",downloadUrl);
            NSLog(@">>>>>>>>>>>>VODStreamingUrl>>>>>>>>>>%@",_VODStreamingUrl);
        }
        //4.添加滑动headerView
        [self constructSlideHeaderView];
        [self constructContentView];
        
        [CommonFunc dismiss];
        
    } failure:^(id  _Nullable errorObject) {
        
       [CommonFunc dismiss];
    }];
    
}
@end
