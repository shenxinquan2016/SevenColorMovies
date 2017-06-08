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
#import "IJKVideoPlayerVC.h"// 播放器
#import <Realm/Realm.h>// 数据库
#import "Dong_DownloadManager.h"
#import "Dong_DownloadModel.h"
#import "ZFDownloadManager.h"// 第三方下载工具
#import "SCDSJDownloadView.h"
#import "SCArtsDownloadView.h"
#import "HLJUUID.h"
#import "SCTCPSocketManager.h"
#import "SCSearchDeviceVC.h"

#import "SCMyProgramListVC.h"
#import "SCMyCollectionVC.h"
#import "SCMyDownloadManagerVC.h"
#import "SCMyWatchingHistoryVC.h"
#import "SCFilterViewController.h"
#import "SCChannelCategoryVC.h"
#import "SCSearchViewController.h"
#import "SCXMPPManager.h"
#import "SCScanQRCodesVC.h"
#import "SCAdvertisemetPosModel.h"
#import "SCAdMediaInfo.h"
#import "PlayerViewRotate.h" // 旋转控制

#define  DownloadManager  [ZFDownloadManager sharedDownloadManager]

static const CGFloat StatusBarHeight = 20.0f;
/** 滑动标题栏高度 */
static const CGFloat TitleHeight = 50.0f;
/** 滑动标题栏宽度 */
static const CGFloat LabelWidth = 100.f;

@interface SCPlayerViewController ()<UIScrollViewDelegate, SocketManagerDelegate, UIAlertViewDelegate, SCXMPPManagerDelegate>

/** 标题栏scrollView */
@property (nonatomic, strong) UIScrollView *titleScroll;
/** 内容栏scrollView */
@property (nonatomic, strong) UIScrollView *contentScroll;
/** 滑动短线 */
@property (nonatomic, strong) CALayer *bottomLine;
/** 滑动标题标识 */
@property (nonatomic, copy) NSString *identifier;
/** 标题数组 */
@property (nonatomic, copy) NSArray *titleArr;
/** 存放所有film集 */
@property (nonatomic, strong) NSMutableArray *filmSetsArr;
/** 综艺生活存放film */
@property (nonatomic, strong) NSMutableArray *filmsArr;
/** 影片介绍model */
@property (nonatomic, strong) SCFilmIntroduceModel *filmIntroduceModel;
@property (nonatomic, strong) NSURL *url;
/** 播放器控制器 */
@property (nonatomic, strong) IJKVideoPlayerVC *IJKPlayerViewController;
@property (nonatomic, strong) SCArtsFilmsCollectionVC *needScrollToTopPage;
@property (nonatomic, copy) NSString *movieType;
/** ip转换工具 */
@property (nonatomic, strong) HLJRequest *hljRequest;
/** 动态域名获取工具 */
@property (nonatomic, strong) SCDomaintransformTool *domainTransformTool;
/** 存储正在播放的剧集 */
@property (nonatomic, strong) SCFilmSetModel *filmSetModel;
/** 是否全屏锁定 */
@property (nonatomic, assign) BOOL fullScreenLock;
/** 功能区距顶部约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toTopConstraint;
/** 添加节目单button */
@property (weak, nonatomic) IBOutlet UIButton *addProgramListBtn;
/** 添加收藏button */
@property (weak, nonatomic) IBOutlet UIButton *addMyCollectionBtn;
/** 下载button */
@property (weak, nonatomic) IBOutlet UIButton *downLoadBtn;
/** 广告modul组 */
@property (nonatomic, strong) NSMutableArray *advertisementArray;

@property (weak, nonatomic) IBOutlet UIView *playerBackGroundView;
@property (weak, nonatomic) IBOutlet UIView *functionalZoneView;

/** 控制记录当前播放时间的时机 */
@property (nonatomic, assign) BOOL isRecordingCurrentPlayTime;

@end

@implementation SCPlayerViewController

{
    BOOL _isFullScreen;
    SCDSJDownloadView *_dsjdownloadView;
    SCArtsDownloadView *_artsDownloadView;
    NSString *_mid;
}

#pragma mark - Initialize
- (instancetype)initWithWithFilmType:(NSString *)tpye{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark -  ViewLife Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHex:@"dddddd"];
    [self.navigationItem setHidesBackButton:YES];
    
    // 0.更新功能区的上约束值
    _toTopConstraint.constant = kMainScreenWidth * 9 / 16;
    _addMyCollectionBtn.enlargedEdge = 5.f;
    _addProgramListBtn.enlargedEdge = 15.f;
    _downLoadBtn.enlargedEdge = 5.f;
    
    // 1.初始化数组
    self.filmSetsArr = [NSMutableArray arrayWithCapacity:0];
    self.filmsArr = [NSMutableArray arrayWithCapacity:0];
    self.advertisementArray = [NSMutableArray arrayWithCapacity:0];
    // 2.组建页面
    [self setView];
    // 3.注册通知
    //[self registerNotification];
    // 4.YES:进入后台时需要记录当前播放时间
    _isRecordingCurrentPlayTime = YES;
    
    //TCPScoketManager.delegate = self;
    XMPPManager.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [self registerNotification];
    //TCPScoketManager.delegate = self;
    XMPPManager.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    // 关闭播放代理
    libagent_finish();
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    VODIndex = 0;
    timesIndexOfVOD = 0;
    //注销所有通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    //7.查询数据库以更新功能区按钮视图
    [self refreshButtonStateFromQueryDatabase];
    [self refreshDownloadButtonStateFromQueryDatabase];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc{
    NSLog(@"🔴%s 第%d行 \n",__func__, __LINE__);
}

#pragma mark - IBAction

// 底层返回按钮
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
            
        } else if ([controller isKindOfClass:[SCMyWatchingHistoryVC class]]) {//直播频道列表页
            
            [navController popToViewController:controller animated:YES];
            return;
            
        } else if ([controller isKindOfClass:[SCFilterViewController class]]) {//筛选
            
            [navController popToViewController:controller animated:YES];
            return;
            
        } else if ([controller isKindOfClass:[SCChannelCategoryVC class]]){//点播节目频道分类
            
            [navController popToViewController:controller animated:YES];
            return;
            
        }else if ([controller isKindOfClass:[SCSearchViewController class]]){//搜索控制器
            
            [navController popToViewController:controller animated:YES];
            return;
        }
    }
    
    [navController popToRootViewControllerAnimated:YES];
}

// 添加节目单
- (IBAction)addFilmToProgramList:(UIButton *)sender {
    DONG_Log(@"添加到节目单");
    
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //});
    
    // 使用 NSPredicate 查询
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"FilmName = %@ AND jiIndex = %ld",
                         _filmModel.FilmName, _filmModel.jiIndex];
    RLMResults *results = [SCFilmModel objectsWithPredicate:pred];
    
    DONG_Log(@"tempArray.count:%ld",results.count);
    
    if (results.count) {//已经添加则取消收藏 从数据库删除
        [_addProgramListBtn setImage:[UIImage imageNamed:@"AddToPlayList"] forState:UIControlStateNormal];
        RLMRealm *realm = [RLMRealm defaultRealm];
        SCFilmModel *filmModel = results.firstObject;
        [realm transactionWithBlock:^{
            //若只删除filmModel 数据库中的filmSetModel不会被删除 故要先删除filmModel.filmSetModel
            if (filmModel.filmSetModel) {//不能删除空对象
                [realm deleteObject:filmModel.filmSetModel];
            }
            [realm deleteObject:filmModel];
        }];
        [MBProgressHUD showSuccess:@"从节目单移除"];
        
    } else {// 未添加 添加到数据库
        // 更新UI
        [_addProgramListBtn setImage:[UIImage imageNamed:@"AddToPlayList_Click"] forState:UIControlStateNormal];
        //保存到数据库
        SCFilmModel *filmModel = [[SCFilmModel alloc] initWithValue:_filmModel];
        RLMRealm *realm = [RLMRealm defaultRealm];
        
        if (_filmModel.filmSetModel) {
            
            SCFilmSetModel *filmSetModel = [[SCFilmSetModel alloc] initWithValue:_filmModel.filmSetModel];
            filmModel.filmSetModel = filmSetModel;
            
            [realm transactionWithBlock:^{
                [realm addObject: filmModel];
            }];
            
        }else{
            
            [realm transactionWithBlock:^{
                [realm addObject: filmModel];
            }];
            
        }
        
        [MBProgressHUD showSuccess:@"添加到节目单"];
    }
    
}

// 添加收藏
- (IBAction)addFilmToMyCollection:(UIButton *)sender {
    DONG_Log(@"添加到收藏");
    
    NSString *documentPath = [FileManageCommon GetDocumentPath];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"/myCollection.realm"];
    NSURL *databaseUrl = [NSURL URLWithString:filePath];
    RLMRealm *realm = [RLMRealm realmWithURL:databaseUrl];
    
    // 使用 NSPredicate 查询
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"FilmName = %@ AND jiIndex = %ld",
                         _filmModel.FilmName, _filmModel.jiIndex];
    RLMResults *results = [SCFilmModel objectsInRealm:realm withPredicate:pred];
    
    if (results.count) {// 已经添加则取消收藏 从数据库删除
        [_addMyCollectionBtn setImage:[UIImage imageNamed:@"Collection"] forState:UIControlStateNormal];
        SCFilmModel *filmModel = results.firstObject;
        [realm transactionWithBlock:^{
            //若只删除filmModel 数据库中的filmSetModel不会被删除 故要先删除filmModel.filmSetModel
            if (filmModel.filmSetModel) {//不能删除空对象
                [realm deleteObject:filmModel.filmSetModel];
            }
            [realm deleteObject:filmModel];
        }];
        
        [MBProgressHUD showSuccess:@"取消收藏"];
        
    } else {//未添加 添加到数据库
        
        //更新UI
        [_addMyCollectionBtn setImage:[UIImage imageNamed:@"Collection_Click"] forState:UIControlStateNormal];
        //保存到数据库
        SCFilmModel *filmModel = [[SCFilmModel alloc] initWithValue:_filmModel];
        
        if (_filmModel.filmSetModel) {
            
            SCFilmSetModel *filmSetModel = [[SCFilmSetModel alloc] initWithValue:_filmModel.filmSetModel];
            filmModel.filmSetModel = filmSetModel;
            
            [realm transactionWithBlock:^{
                [realm addObject: filmModel];
            }];
            
        } else {
            
            [realm transactionWithBlock:^{
                [realm addObject: filmModel];
            }];
            
        }
        [MBProgressHUD showSuccess:@"添加收藏"];
    }
}

// 下载
- (IBAction)beginDownload:(id)sender {
    DONG_Log(@"下载");
    // 名称
    NSString *filmName;
    if (_filmModel.FilmName) {
        if (_filmModel.filmSetModel) {
            filmName = [NSString stringWithFormat:@"%@ 第%@集",_filmModel.FilmName,_filmModel.filmSetModel._ContentIndex];
        } else {
            filmName = [NSString stringWithFormat:@"%@",_filmModel.FilmName];
        }
    } else if (_filmModel.cnname){
        if (_filmModel.filmSetModel) {
            filmName = [NSString stringWithFormat:@"%@ 第%@集",_filmModel.cnname,_filmModel.filmSetModel._ContentIndex];
        } else {
            filmName = [NSString stringWithFormat:@"%@",_filmModel.cnname];
        }
    }
    
    NSString *mid;
    if (_filmModel._Mid) {
        mid = _filmModel._Mid;
    }else if (_filmModel.mid){
        mid = _filmModel.mid;
    }
    
    NSString *filmmidStr = mid ? mid : @"";
    
    NSDictionary *parameters = @{@"pagesize" : @"1000",
                                 @"ctype"    : @"4",
                                 @"filmmid" : filmmidStr};
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
        DONG_WeakSelf(self);
        
        // 域名获取
        _domainTransformTool = [[SCDomaintransformTool alloc] init];
        [_domainTransformTool getNewDomainByUrlString:FilmSourceUrl key:@"skdbpd" success:^(id  _Nullable newUrlString) {
            
            DONG_Log(@"newUrlString:%@",newUrlString);
            // ip转换
            _hljRequest = [HLJRequest requestWithPlayVideoURL:newUrlString];
            [_hljRequest getNewVideoURLSuccess:^(NSString *newVideoUrl) {
                
                DONG_Log(@"newVideoUrl:%@",newVideoUrl);
                
                [requestDataManager requestDataWithUrl:newVideoUrl parameters:parameters success:^(id  _Nullable responseObject) {
                    DONG_Log(@"====responseObject:::%@===",responseObject);
                    
                    DONG_StrongSelf(self);
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
                    //视频播放url
                    NSString *domainUrl = [_domainTransformTool getNewViedoURLByUrlString:VODUrl key:@"vodplayauth"];
                    DONG_Log(@"domainUrl:%@",domainUrl);
                    NSString *replacedUrl = [_hljRequest getNewViedoURLByOriginVideoURL:domainUrl];
                    //NSString *replacedUrl = [strongself.hljRequest getNewViedoURLByOriginVideoURL:VODUrl];
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
                        //NSString *str = @"http://baobab.wdjcdn.com/1456665467509qingshu.mp4";
                        
                        // 利用ZFDownloadManager下载
                        [[ZFDownloadManager sharedDownloadManager] downFileUrl:playUrl filename:filmName fileimage:nil];
                        // 设置最多同时下载个数（默认是3）
                        [ZFDownloadManager sharedDownloadManager].maxCount = 1;
                        [_downLoadBtn setImage:[UIImage imageNamed:@"DownLoad_Click"] forState:UIControlStateNormal];
                        
                        // 初始化Realm
                        NSString *documentPath = [FileManageCommon GetDocumentPath];
                        NSString *filePath = [documentPath stringByAppendingPathComponent:@"/myDownload.realm"];
                        NSURL *databaseUrl = [NSURL URLWithString:filePath];
                        RLMRealm *realm = [RLMRealm realmWithURL:databaseUrl];
                        // 使用 NSPredicate 查询
                        NSPredicate *pred = [NSPredicate predicateWithFormat:
                                             @"FilmName = %@ AND _Mid = %@ And jiIndex = %ld",
                                             _filmModel.FilmName, _filmModel._Mid, _filmModel.jiIndex];
                        RLMResults *results = [SCFilmModel objectsInRealm:realm withPredicate:pred];
                        
                        if (!results.count) { // 没有保存过才保存
                            // 保存到数据库
                            SCFilmModel *filmModel = [[SCFilmModel alloc] initWithValue:_filmModel];
                            [realm transactionWithBlock:^{
                                [realm addObject: filmModel];
                            }];
                        }
                        [CommonFunc dismiss];
                    } failure:^(id  _Nullable errorObject) {
                        [CommonFunc dismiss];
                    }];
                } failure:^(id  _Nullable errorObject) {
                    [CommonFunc dismiss];
                }];
            } failure:^(NSError *error) {
                [CommonFunc dismiss];
            }];
        } failure:^(id  _Nullable errorObject) {
            
            [CommonFunc dismiss];
            
        }];
        
    } else if // 综艺 生活
    ([mtype isEqualToString:@"7"] ||
     [mtype isEqualToString:@"9"])
    {
        if (!_artsDownloadView) {
            _artsDownloadView = [[SCArtsDownloadView alloc] initWithFrame:CGRectMake(0, kMainScreenWidth * 9 / 16 +40, kMainScreenWidth, kMainScreenHeight-(kMainScreenWidth * 9 / 16 +20))];
            _artsDownloadView.dataSourceArray = _filmsArr;
            _artsDownloadView.filmModel = _filmModel;
            DONG_WeakSelf(_artsDownloadView);
            _artsDownloadView.backBtnBlock = ^{
                [weak_artsDownloadView removeFromSuperview];
                _artsDownloadView = nil;
            };
            [self.view addSubview:_artsDownloadView];
            
            [UIView animateWithDuration:0.2f animations:^{
                [_artsDownloadView setFrame:CGRectMake(0, kMainScreenWidth * 9 / 16 +20, kMainScreenWidth, kMainScreenHeight-(kMainScreenWidth * 9 / 16 +20))];
            }];
        }
    } else { // 电视剧 少儿 少儿剧场 动漫 纪录片 游戏 专题
        
        if (!_dsjdownloadView) {
            _dsjdownloadView = [[SCDSJDownloadView alloc] initWithFrame:CGRectMake(0, kMainScreenWidth * 9 / 16 +40, kMainScreenWidth, kMainScreenHeight-(kMainScreenWidth * 9 / 16 +20))];
            _dsjdownloadView.dataSourceArray = _filmSetsArr;
            _dsjdownloadView.filmModel = _filmModel;
            DONG_WeakSelf(_dsjdownloadView);
            _dsjdownloadView.backBtnBlock = ^{
                [weak_dsjdownloadView removeFromSuperview];
                _dsjdownloadView = nil;
            };
            [self.view addSubview:_dsjdownloadView];
            
            [UIView animateWithDuration:0.2f animations:^{
                [_dsjdownloadView setFrame:CGRectMake(0, kMainScreenWidth * 9 / 16 +20, kMainScreenWidth, kMainScreenHeight-(kMainScreenWidth * 9 / 16 +20))];
            }];
        }
    }
}

#pragma mark - query database
// 查询收藏和节目单
-(void)refreshButtonStateFromQueryDatabase
{
    //1.查询是否已经添加到节目单
    //使用 NSPredicate 查询
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"FilmName = %@ And jiIndex = %ld",
                         _filmModel.FilmName, _filmModel.jiIndex];
    RLMResults *results = [SCFilmModel objectsWithPredicate:pred];
    if (results.count) {
        [_addProgramListBtn setImage:[UIImage imageNamed:@"AddToPlayList_Click"] forState:UIControlStateNormal];
    }else{
        
        [_addProgramListBtn setImage:[UIImage imageNamed:@"AddToPlayList"] forState:UIControlStateNormal];
    }
    
    //2.查询是否已经收藏
    NSString *documentPath = [FileManageCommon GetDocumentPath];
    NSString *dataBasePath = [documentPath stringByAppendingPathComponent:@"/myCollection.realm"];
    NSURL *databaseUrl = [NSURL URLWithString:dataBasePath];
    RLMRealm *realm2 = [RLMRealm realmWithURL:databaseUrl];
    //使用 NSPredicate 查询
    RLMResults *results2 = [SCFilmModel objectsInRealm:realm2 withPredicate:pred];
    if (results2.count) {
        [_addMyCollectionBtn setImage:[UIImage imageNamed:@"Collection_Click"] forState:UIControlStateNormal];
    }else{
        [_addMyCollectionBtn setImage:[UIImage imageNamed:@"Collection"] forState:UIControlStateNormal];
    }
}

// 查询电影下载 电视剧和综艺无需查询
-(void)refreshDownloadButtonStateFromQueryDatabase
{
    NSString *mtype;
    if (_filmModel._Mtype) {
        mtype = _filmModel._Mtype;
    } else if (_filmModel.mtype) {
        mtype = _filmModel.mtype;
    }
    NSLog(@"++++++++++++++++++++_filmModel._Mtype::::%@",mtype);
    // 私人影院 电影 海外片场
    if ([mtype isEqualToString:@"0"] ||
        [mtype isEqualToString:@"2"] ||
        [mtype isEqualToString:@"13"])
    {
        // 初始化Realm
        NSString *documentPath = [FileManageCommon GetDocumentPath];
        NSString *filePath = [documentPath stringByAppendingPathComponent:@"/myDownload.realm"];
        NSURL *databaseUrl = [NSURL URLWithString:filePath];
        RLMRealm *realm = [RLMRealm realmWithURL:databaseUrl];
        // 使用 NSPredicate 查询
        NSPredicate *pred = [NSPredicate predicateWithFormat:
                             @"FilmName = %@ AND _Mid = %@ And jiIndex = %ld",
                             _filmModel.FilmName, _filmModel._Mid, _filmModel.jiIndex];
        RLMResults *results = [SCFilmModel objectsInRealm:realm withPredicate:pred];
        if (results.count) {//已经下载
            [_downLoadBtn setImage:[UIImage imageNamed:@"DownLoad_Click"] forState:UIControlStateNormal];
        } else {
            [_downLoadBtn setImage:[UIImage imageNamed:@"DownLoadIMG"] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - private methods

- (void)setView
{
    NSString *mtype;
    if (_filmModel._Mtype) {
        mtype = _filmModel._Mtype;
    }else if (_filmModel.mtype){
        mtype = _filmModel.mtype;
    }
    
    NSString *stype = _filmModel._Stype;
    
    DONG_Log(@"mtype:%@",mtype);
    DONG_Log(@"stype:%@",stype);
    
    if ([self.entrance isEqualToString:@"search"]) {
        
        // 私人影院 电影 海外片场
        if ([mtype isEqualToString:@"0"] ||
            [mtype isEqualToString:@"2"] ||
            [mtype isEqualToString:@"13"] || (([mtype isEqualToString:@"7"] || [mtype isEqualToString:@"9"]) && ![_filmModel.stype isEqualToString:@"1"]))
        {
            [self getMovieData];
            
        } else if // 综艺 生活
        
        ([mtype isEqualToString:@"7"] ||
         [mtype isEqualToString:@"9"])
        {
            [self getArtsAndLifeData];
            
        } else {
            //电视剧 少儿 少儿剧场 动漫 纪录片 游戏 专题
            [self getTeleplayData];
        }
        
    } else {
        
        // 私人影院 电影 海外片场
        if ([mtype isEqualToString:@"0"] ||
            [mtype isEqualToString:@"2"] ||
            [mtype isEqualToString:@"13"])
        {
            [self getMovieData];
            
        } else if // 综艺 生活
        
        (([mtype isEqualToString:@"7"] ||
         [mtype isEqualToString:@"9"])&& [stype isEqualToString:@"1"])
        {
            [self getArtsAndLifeData];
            
        } else {
            //电视剧 少儿 少儿剧场 动漫 纪录片 游戏 专题
            [self getTeleplayData];
        }
    }
    
}

- (void)registerNotification {
    // 1.监听屏幕旋转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    // 2.第一次加载成功准备播放
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:nil];
    // 3.播放结束通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
    // 4.点击列表播放通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playNewFilm:) name:PlayVODFilmWhenClick object:nil];
    // 5.APP进入后台
    [DONG_NotificationCenter addObserver:self selector:@selector(gotoBackground) name:AppWillResignActive object:nil];
    // 6.APP被激活
    [DONG_NotificationCenter addObserver:self selector:@selector(gotoFrontground) name:AppDidBecomeActive object:nil];
}

#pragma mark - 播放时进入后台和返回前台的处理
/** 进入后台 */
- (void)gotoBackground
{
    if (_isRecordingCurrentPlayTime) {
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
    if ([PlayerViewRotate isOrientationLandscape]) { // 全屏时
        
        //2.调用播放器播放
        self.IJKPlayerViewController = [IJKVideoPlayerVC initIJKPlayerWithURL:self.url];
        self.view.frame = [[UIScreen mainScreen] bounds];
        self.IJKPlayerViewController.view.frame = self.view.bounds;
        self.IJKPlayerViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth & UIViewAutoresizingFlexibleHeight;
        self.IJKPlayerViewController.mediaControl.frame = self.view.frame;
        [self.view addSubview:self.IJKPlayerViewController.view];
        [self.view bringSubviewToFront:self.IJKPlayerViewController.view];
        
    } else {
        
        // 2.调用播放器播放
        self.IJKPlayerViewController = [IJKVideoPlayerVC initIJKPlayerWithURL:self.url];
        self.IJKPlayerViewController.view.frame = CGRectMake(0, 20, kMainScreenWidth, kMainScreenWidth * 9 / 16);
        
        [self.view addSubview:self.IJKPlayerViewController.view];
    }
    
    NSString *filmName;
    if (self.filmModel.FilmName) {
        filmName = self.filmModel.FilmName;
    }else if (self.filmModel.cnname){
        filmName = self.filmModel.cnname;
    }
    
    self.IJKPlayerViewController.mediaControl.programNameRunLabel.titleName = filmName;
    
    // 1.全屏锁定回调
    DONG_WeakSelf(self);
    self.IJKPlayerViewController.fullScreenLockBlock = ^(BOOL isFullScreenLock){
        DONG_StrongSelf(self);
        strongself.fullScreenLock = isFullScreenLock;
    };
    // 2.添加播放记录的回调
    self.IJKPlayerViewController.addWatchHistoryBlock = ^(void){
        DONG_StrongSelf(self);
        [strongself addWatchHistoryWithFilmModel:strongself.filmModel];
    };
    // 3.推屏的回调
    self.IJKPlayerViewController.pushScreenBlock = ^{
        DONG_StrongSelf(self);
        // 未连接设备时要先扫描设备
        if (XMPPManager.isConnected) {
            NSString *toName = [NSString stringWithFormat:@"%@@hljvoole.com/%@", XMPPManager.uid, XMPPManager.hid];
            NSString *xmlString = [strongself getXMLCommandWithFilmModel:strongself.filmModel];
            //[TCPScoketManager socketWriteData:xmlString withTimeout:-1 tag:1001];
            [XMPPManager sendMessageWithBody:xmlString andToName:toName andType:@"text"];
            
        } else {
            
            [MBProgressHUD showError:@"设备未绑定，请扫码绑定"];
            
            //UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"尚未绑定设备，请先扫码绑定设备" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            //[alertView show];
            //alertView.delegate = weakself;
        }
    };
    // 4.暂停广告
    self.IJKPlayerViewController.mediaControl.advertisementIV.hidden = YES;
    
    for (SCAdvertisemetPosModel *adPosModel in self.advertisementArray) {
        // 选择暂停广告：706
        if ([adPosModel._pos isEqualToString:@"706"]) {
            
            if (adPosModel.adMediaInfoArray.count) {
                // 暂停广告有多条
                SCAdMediaInfo *adMediaInfo = [adPosModel.adMediaInfoArray firstObject];
                NSURL *imageUrl = [NSURL URLWithString:adMediaInfo.__text];
                [self.IJKPlayerViewController.mediaControl.advertisementIV sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@""]];
                
            } else {
                // 暂停广告只一条
                NSURL *imageUrl = [NSURL URLWithString:adPosModel.adMediaInfo.__text];
                [self.IJKPlayerViewController.mediaControl.advertisementIV sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@""]];
                
            }
            
            break;
        }
    }
 
}

/** 添加滚动标题栏*/
- (void)constructSlideHeaderView {
    
    NSInteger screenWith;
    if ([PlayerViewRotate isOrientationLandscape]) { // 全屏
        screenWith = kMainScreenHeight;
    } else {
        screenWith = kMainScreenWidth;
    }
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, screenWith * 9 / 16 +20+36+8, screenWith, TitleHeight)];
    
    DONG_Log(@"kMainScreenWidth:%ld",(long)screenWith);
    backgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backgroundView];
    
    self.titleScroll = [[UIScrollView alloc] initWithFrame:CGRectMake((screenWith-LabelWidth*_titleArr.count)/2, 0, LabelWidth*_titleArr.count, TitleHeight)];//滚动窗口
    //    _titleScroll.backgroundColor = [UIColor greenColor];
    self.titleScroll.showsHorizontalScrollIndicator = NO;
    self.titleScroll.showsVerticalScrollIndicator = NO;
    self.titleScroll.scrollsToTop = NO;
    
    [backgroundView addSubview:_titleScroll];
    
    //0.添加lab
    [self addLabel];//添加标题label
    //1.底部滑动短线
    _bottomLine = [CALayer layer];
    [_bottomLine setBackgroundColor:[UIColor colorWithHex:@"#5184FF"].CGColor];
    _bottomLine.frame = CGRectMake(0, _titleScroll.frame.size.height-22+StatusBarHeight, LabelWidth, 2);
    
    [_titleScroll.layer addSublayer:_bottomLine];
    
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
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)]];
    }
    
    _titleScroll.contentSize = CGSizeMake(LabelWidth * _titleArr.count, 0);
    
    //默认选择第一个label
    SCSlideHeaderLabel *lable = [self.titleScroll.subviews firstObject];
    lable.scale = 1.0;
}

//添加观看记录
- (void)addWatchHistoryWithFilmModel:(SCFilmModel *)filmModel
{
    NSString *titleStr;
    if (filmModel.FilmName) {
        titleStr = filmModel.FilmName;
    } else if (filmModel.cnname) {
        titleStr = filmModel.cnname;
    } else {
        titleStr = @"";
    }
    
    NSString *mTypeStr;
    if (filmModel._Mtype) {
        mTypeStr = filmModel._Mtype;
    } else if (filmModel.mtype) {
        mTypeStr = filmModel.mtype;
    }else {
        mTypeStr = @"";
    }
    
    NSString *timeStamp = [NSString stringWithFormat:@"%ld",(long)[NSDate timeStampFromDate:[NSDate date]]];
    const NSString *uuidStr = [HLJUUID getUUID];
    filmModel.jiIndex = filmModel.jiIndex == 0 ? -1 : filmModel.jiIndex;
    
    NSNumber *oemid    = [NSNumber numberWithInt:300126];
    NSNumber *mid      = [NSNumber numberWithInteger:[_mid integerValue]];
    NSNumber *mType    = [NSNumber numberWithInteger:[mTypeStr integerValue]];
    NSNumber *sid      = [NSNumber numberWithInteger:filmModel.jiIndex];//第几集
    NSNumber *fid      = [NSNumber numberWithInteger:[filmModel._FilmID integerValue]];
    NSNumber *playtime = [NSNumber numberWithInteger:self.IJKPlayerViewController.player.currentPlaybackTime];
    
    NSDictionary *parameters = @{@"ctype"     : @"2",
                                 @"hid"       : uuidStr,
                                 @"mid"       : mid,
                                 @"mtype"     : mType,
                                 @"sid"       : sid,
                                 @"fid"       : fid,
                                 @"playtime"  : playtime,
                                 @"datetime"  : timeStamp,
                                 @"title"     : titleStr,
                                 @"detailurl" : filmModel._ImgUrlO? filmModel._ImgUrlO : @""
                                 };
    
    // 域名获取
    NSString *domainUrl = [_domainTransformTool getNewViedoURLByUrlString:AddWatchHistory key:@"skscxb"];
    DONG_Log(@"domainUrl:%@",domainUrl);
    // ip转换
    NSString *newVideoUrl = [_hljRequest getNewViedoURLByOriginVideoURL:domainUrl];
    DONG_Log(@"newVideoUrl:%@",newVideoUrl);
    
    [requestDataManager requestDataWithUrl:newVideoUrl parameters:parameters success:^(id  _Nullable responseObject) {
        
        DONG_Log(@"添加观看记录成功 parameters:%@ \nresponseObject:%@",parameters, responseObject);
        
    }failure:^(id  _Nullable errorObject) {
        
    }];
}

- (void)hideIJKPlayerMediaControlView
{
    [_IJKPlayerViewController.mediaControl hide];
}

#pragma mark - Event reponse
- (void)labelClick:(UITapGestureRecognizer *)recognizer {
    SCSlideHeaderLabel *label = (SCSlideHeaderLabel *)recognizer.view;
    CGFloat offsetX = label.tag * _contentScroll.frame.size.width;
    
    CGFloat offsetY = _contentScroll.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    
    [_contentScroll setContentOffset:offset animated:YES];
}

/** 添加正文内容页 */
- (void)constructContentView
{
    NSInteger screenWith;
    NSInteger screenHeight;
    if ([PlayerViewRotate isOrientationLandscape]) { // 全屏
        screenWith = kMainScreenHeight;
        screenHeight = kMainScreenWidth;
    } else {
        screenWith = kMainScreenWidth;
        screenHeight = kMainScreenHeight;
    }
    _contentScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, screenWith * 9 / 16 +20+36+8+TitleHeight+8, screenWith, screenHeight-(screenWith * 9 / 16 +20+36+8+TitleHeight+8))];//滚动窗口
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
                        vc.bannerFilmModelArray = self.bannerFilmModelArray;
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
        
    } else if ([_identifier isEqualToString:@"电视剧"]) {
        
        for (int i=0; i<_titleArr.count ;i++) {
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
                        vc.bannerFilmModelArray = self.bannerFilmModelArray;
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
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
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
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

/** 正在滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
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
            case UIDeviceOrientationPortrait: {
                
                //此方向为正常竖屏方向，当锁定全屏设备旋转至此方向时，屏幕虽然不显示StatusBar，但会留出StatusBar位置，所以调整IJKPlayer的位置
                if (self.fullScreenLock) {
                    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
                    _IJKPlayerViewController.isFullScreen = YES;
                    [_IJKPlayerViewController.player setScalingMode:IJKMPMovieScalingModeAspectFit];
                    _IJKPlayerViewController.view.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenWidth * 9 / 16);
                    _IJKPlayerViewController.mediaControl.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenWidth * 9 / 16);
                    _IJKPlayerViewController.mediaControl.fullScreenLockButton.hidden = NO;
                    
                } else {
                    
                    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
                    _playerBackGroundView.frame = CGRectMake(0, 20, kMainScreenWidth, kMainScreenWidth * 9 / 16);
                    _functionalZoneView.frame = CGRectMake(0, 20 + (kMainScreenWidth * 9 / 16) + 2, kMainScreenWidth, 36);
                    [_IJKPlayerViewController.player setScalingMode:IJKMPMovieScalingModeAspectFit];
                    _IJKPlayerViewController.view.frame = CGRectMake(0, 20, kMainScreenWidth, kMainScreenWidth * 9 / 16);
                    _IJKPlayerViewController.mediaControl.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenWidth * 9 / 16);
                    _IJKPlayerViewController.mediaControl.fullScreenLockButton.hidden = YES;
                }
                
                break;
            }
            
            case UIDeviceOrientationLandscapeLeft: {
                [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
                [_IJKPlayerViewController.player setScalingMode:IJKMPMovieScalingModeAspectFit];
                self.view.frame = [[UIScreen mainScreen] bounds];
                _IJKPlayerViewController.view.frame = self.view.bounds;
                _IJKPlayerViewController.mediaControl.fullScreenLockButton.hidden = NO;
                _IJKPlayerViewController.isFullScreen = YES;
                _IJKPlayerViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth & UIViewAutoresizingFlexibleHeight;
                _IJKPlayerViewController.mediaControl.frame = self.view.frame;
                [self.view bringSubviewToFront:_IJKPlayerViewController.view];
                break;
            }
            
            case UIDeviceOrientationPortraitUpsideDown: {
                _IJKPlayerViewController.mediaControl.fullScreenLockButton.hidden = NO;
                _IJKPlayerViewController.isFullScreen = YES;
                DONG_Log(@"fullLock:%d",_isFullScreen);
            }
            
            case UIDeviceOrientationLandscapeRight: {
                [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
                [_IJKPlayerViewController.player setScalingMode:IJKMPMovieScalingModeAspectFit];
                self.view.frame = [[UIScreen mainScreen] bounds];
                _IJKPlayerViewController.view.frame = self.view.bounds;
                _IJKPlayerViewController.isFullScreen = YES;
                _IJKPlayerViewController.mediaControl.fullScreenLockButton.hidden = NO;
                _IJKPlayerViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth & UIViewAutoresizingFlexibleHeight;
                _IJKPlayerViewController.mediaControl.frame = self.view.frame;
                [self.view bringSubviewToFront:_IJKPlayerViewController.view];
                break;
            }
            
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

#pragma mark - IJK完成加载即将播放的通知
- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification
{
    NSLog(@"mediaIsPreparedToPlayDidChange\n");
    
    // 开始播放5秒后隐藏播放器控件
    [self performSelector:@selector(hideIJKPlayerMediaControlView) withObject:nil afterDelay:5.0];
    
    //在此通知里设置加载IJK时的起始播放时间
    NSInteger currentPlayTime = [DONG_UserDefaults integerForKey:kCurrentPlayTimeWhenGotoBG];

    if (currentPlayTime) {
       // 如果是从后台回来
        self.IJKPlayerViewController.player.currentPlaybackTime = currentPlayTime;
        currentPlayTime = 0;// 复位
        [DONG_UserDefaults setInteger:currentPlayTime forKey:kCurrentPlayTimeWhenGotoBG];
        [DONG_UserDefaults synchronize];
        // 加载成功seekTo指定时间后才允许下次进入后台时记录当前播放时间
        _isRecordingCurrentPlayTime = YES;
        
    } else if (_filmModel.currentPlayTime) {
        // 如果已经播放过，则从已播放时间开始播放
        DONG_Log(@"currentPlayTime:%f", _filmModel.currentPlayTime);
        self.IJKPlayerViewController.player.currentPlaybackTime = _filmModel.currentPlayTime;
    }
    _filmModel.currentPlayTime = 0.0f;
}

#pragma mark - 播放下一个节目
- (void)playNextFilm
{
    DONG_Log(@"播放下个节目");
    NSDictionary *message;
    if ([_identifier isEqualToString:@"电影"]){
        
        return;
        
    } else if ([_identifier isEqualToString:@"电视剧"]){
        
        if (VODIndex+ ++timesIndexOfVOD < self.filmSetsArr.count) {
            DONG_Log(@"VODIndex:%lu timesIndexOfVOD: %lu",(unsigned long)VODIndex,(unsigned long)timesIndexOfVOD);
            //-1.关闭正在播放的节目
            if ([self.IJKPlayerViewController.player isPlaying]) {
                [self.IJKPlayerViewController.player pause];
            }
            
            //0.获取下一个节目的model
            SCFilmSetModel *filmSetModel = self.filmSetsArr[VODIndex+timesIndexOfVOD];
            _filmModel.jiIndex = VODIndex + timesIndexOfVOD + 1;
            
            //将filmsetmodel和filmmodel关联起来，便于直接从数据库读取信息后播放
            _filmModel.filmSetModel = [[SCFilmSetModel alloc] initWithValue:filmSetModel];
            //查询数据库以更新功能区按钮视图
            [self refreshButtonStateFromQueryDatabase];
            
            //1.获取上一个节目的model
            SCFilmSetModel *lastFilmSetModel = self.filmSetsArr[VODIndex+timesIndexOfVOD-1];
            
            message = @{@"nextFilmSetModel" : filmSetModel,
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
                
                if ([PlayerViewRotate isOrientationLandscape]) { // 全屏时
                    
                    self.IJKPlayerViewController = [IJKVideoPlayerVC initIJKPlayerWithURL:self.url];
                    
                    self.view.frame = [[UIScreen mainScreen] bounds];
                    self.IJKPlayerViewController.view.frame = self.view.bounds;
                    self.IJKPlayerViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth & UIViewAutoresizingFlexibleHeight;
                    self.IJKPlayerViewController.mediaControl.frame = self.view.frame;
                    _IJKPlayerViewController.mediaControl.programNameRunLabel.titleName = [NSString stringWithFormat:@"%@ 第%lu集",_filmModel.FilmName , (unsigned long)_filmModel.jiIndex]; // 节目名称
                    [self.view addSubview:_IJKPlayerViewController.view];
                    
                } else {
                    // 竖屏时
                    
                    self.IJKPlayerViewController = [IJKVideoPlayerVC initIJKPlayerWithURL:self.url];
                    _IJKPlayerViewController.view.frame = CGRectMake(0, 20, kMainScreenWidth, kMainScreenWidth * 9 / 16);
                    //_IJKPlayerViewController.mediaControl.programNameLabel.text = _filmModel.FilmName;//节目名称
                    _IJKPlayerViewController.mediaControl.programNameRunLabel.titleName = [NSString stringWithFormat:@"%@ 第%lu集",_filmModel.FilmName , (unsigned long)_filmModel.jiIndex]; // 节目名称
                    [self.view addSubview:_IJKPlayerViewController.view];
                    
                }
                
                DONG_WeakSelf(self);
                //1.全屏锁定回调
                weakself.IJKPlayerViewController.fullScreenLockBlock = ^(BOOL isFullScreenLock){
                    DONG_StrongSelf(self);
                    strongself.fullScreenLock = isFullScreenLock;
                };
                //2.添加播放记录的回调
                weakself.IJKPlayerViewController.addWatchHistoryBlock = ^(void){
                    DONG_StrongSelf(self);
                    [strongself addWatchHistoryWithFilmModel:strongself.filmModel];
                };
                //3.推屏的回调
                weakself.IJKPlayerViewController.pushScreenBlock = ^{
                    // 未连接设备时要先扫描设备
                    if (XMPPManager.isConnected) {
                        NSString *toName = [NSString stringWithFormat:@"%@@hljvoole.com/%@", XMPPManager.uid, XMPPManager.hid];
                        NSString *xmlString = [weakself getXMLCommandWithFilmModel:weakself.filmModel];
                        //[TCPScoketManager socketWriteData:xmlString withTimeout:-1 tag:1001];
                        [XMPPManager sendMessageWithBody:xmlString andToName:toName andType:@"text"];
                        
                    } else {
                        
                        [MBProgressHUD showError:@"设备未绑定，请扫码绑定"];
                        
                        //UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"尚未绑定设备，请先扫码绑定设备" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                        //[alertView show];
                        //alertView.delegate = weakself;
                    }
                };
                // 4.暂停广告
                self.IJKPlayerViewController.mediaControl.advertisementIV.hidden = YES;
                for (SCAdvertisemetPosModel *adPosModel in self.advertisementArray) {
                    // 选择暂停广告：706
                    if ([adPosModel._pos isEqualToString:@"706"]) {
                        
                        if (adPosModel.adMediaInfoArray.count) {
                            // 暂停广告有多条
                            SCAdMediaInfo *adMediaInfo = [adPosModel.adMediaInfoArray firstObject];
                            NSURL *imageUrl = [NSURL URLWithString:adMediaInfo.__text];
                            [self.IJKPlayerViewController.mediaControl.advertisementIV sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@""]];
                            
                        } else {
                            // 暂停广告只一条
                            NSURL *imageUrl = [NSURL URLWithString:adPosModel.adMediaInfo.__text];
                            [self.IJKPlayerViewController.mediaControl.advertisementIV sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@""]];
                            
                        }
                        
                        break;
                    }
                }
                // 数据采集
                [UserInfoManager addCollectionDataWithType:@"Film" filmName:[NSString stringWithFormat:@"%@ 第%lu集",self.filmModel.FilmName , (unsigned long)self.filmModel.jiIndex] mid:_mid];
                
                [CommonFunc dismiss];
                
            } failure:^(id  _Nullable errorObject) {
                
            }];
        }
    } else if ([_identifier isEqualToString:@"综艺"]) {
        
        if (VODIndex+ ++timesIndexOfVOD < self.filmsArr.count) {
            //0.获取下一个节目的model
            SCFilmModel *atrsFilmModel = self.filmsArr[VODIndex+timesIndexOfVOD];
            //更改属性值为指定单元节目的filmModel 方便存取
            _filmModel = atrsFilmModel;
            _filmModel.jiIndex = VODIndex + timesIndexOfVOD + 1;
            
            //查询数据库以更新功能区按钮视图
            [self refreshButtonStateFromQueryDatabase];
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
                NSString *domainUrl = [_domainTransformTool getNewViedoURLByUrlString:VODUrl key:@"vodplayauth"];
                DONG_Log(@"domainUrl:%@",domainUrl);
                NSString *replacedUrl = [_hljRequest getNewViedoURLByOriginVideoURL:domainUrl];
                
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
                    //self.url = [NSURL fileURLWithPath:@"/Users/yesdgq/Downloads/IMG_0839.MOV"];
                    //1.移除播放器
                    [self.IJKPlayerViewController closePlayer];
                    
                    //2.调用播放器播放
                    if ([PlayerViewRotate isOrientationLandscape]) { // 全屏时
                        
                        self.IJKPlayerViewController = [IJKVideoPlayerVC initIJKPlayerWithURL:self.url];
                        
                        self.view.frame = [[UIScreen mainScreen] bounds];
                        self.IJKPlayerViewController.view.frame = self.view.bounds;
                        self.IJKPlayerViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth & UIViewAutoresizingFlexibleHeight;
                        self.IJKPlayerViewController.mediaControl.frame = self.view.frame;
                        self.IJKPlayerViewController.mediaControl.programNameRunLabel.titleName = self.filmModel.FilmName; // 节目名称
                        
                        [self.view addSubview:self.IJKPlayerViewController.view];
                        
                    } else {
                        // 竖屏时
                        
                        self.IJKPlayerViewController = [IJKVideoPlayerVC initIJKPlayerWithURL:self.url];
                        _IJKPlayerViewController.view.frame = CGRectMake(0, 20, kMainScreenWidth, kMainScreenWidth * 9 / 16);
                        //_IJKPlayerViewController.mediaControl.programNameLabel.text = _filmModel.FilmName;//节目名称
                        _IJKPlayerViewController.mediaControl.programNameRunLabel.titleName = _filmModel.FilmName; // 节目名称
                        [self.view addSubview:_IJKPlayerViewController.view];
                        
                    }
                    
                    DONG_WeakSelf(self);
                    // 1.全屏锁定回调
                    weakself.IJKPlayerViewController.fullScreenLockBlock = ^(BOOL isFullScreenLock){
                        DONG_StrongSelf(self);
                        strongself.fullScreenLock = isFullScreenLock;
                    };
                    // 2.添加播放记录的回调
                    weakself.IJKPlayerViewController.addWatchHistoryBlock = ^(void){
                        DONG_StrongSelf(self);
                        [strongself addWatchHistoryWithFilmModel:strongself.filmModel];
                    };
                    // 3.推屏的回调
                    weakself.IJKPlayerViewController.pushScreenBlock = ^{
                        // 未连接设备时要先扫描设备
                        if (XMPPManager.isConnected) {
                            NSString *toName = [NSString stringWithFormat:@"%@@hljvoole.com/%@", XMPPManager.uid, XMPPManager.hid];
                            NSString *xmlString = [weakself getXMLCommandWithFilmModel:weakself.filmModel];
                            //[TCPScoketManager socketWriteData:xmlString withTimeout:-1 tag:1001];
                            [XMPPManager sendMessageWithBody:xmlString andToName:toName andType:@"text"];
                            
                        } else {
                            
                            [MBProgressHUD showError:@"设备未绑定，请扫码绑定"];
                            
                            //UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"尚未绑定设备，请先扫码绑定设备" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                            //[alertView show];
                            //alertView.delegate = weakself;
                        }
                    };
                    // 4.暂停广告
                    self.IJKPlayerViewController.mediaControl.advertisementIV.hidden = YES;
                    for (SCAdvertisemetPosModel *adPosModel in self.advertisementArray) {
                        // 选择暂停广告：706
                        if ([adPosModel._pos isEqualToString:@"706"]) {
                            
                            if (adPosModel.adMediaInfoArray.count) {
                                // 暂停广告有多条
                                SCAdMediaInfo *adMediaInfo = [adPosModel.adMediaInfoArray firstObject];
                                NSURL *imageUrl = [NSURL URLWithString:adMediaInfo.__text];
                                [self.IJKPlayerViewController.mediaControl.advertisementIV sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@""]];
                                
                            } else {
                                // 暂停广告只一条
                                NSURL *imageUrl = [NSURL URLWithString:adPosModel.adMediaInfo.__text];
                                [self.IJKPlayerViewController.mediaControl.advertisementIV sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@""]];
                                
                            }
                            
                            break;
                        }
                    }
                    // 数据采集
                    [UserInfoManager addCollectionDataWithType:@"Film" filmName:_filmModel.FilmName mid:atrsFilmModel._Mid];
                    
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

static NSUInteger VODIndex; // 首页播放回看的url在_huikanPlayerUrlArray中的第几个，这个播放完后去播放index + 1的回看
static NSUInteger timesIndexOfVOD = 0; // 标记自动播放下一个节目的次数

#pragma mark - 电视剧播放列表点击事件

- (void)playNewFilm:(NSNotification *)notification
{
    NSDictionary *dic = notification.object;
    SCFilmSetModel *filmSetModel = dic[@"model"];
    _filmSetModel = filmSetModel;
    VODIndex = [self.filmSetsArr indexOfObject:filmSetModel];
    // 对jiIndex赋值
    _filmModel.jiIndex = VODIndex + 1;
    // 将filmsetmodel和filmmodel关联起来，便于直接从数据库读取信息后播放
    _filmModel.filmSetModel = [[SCFilmSetModel alloc] initWithValue:filmSetModel];
    // 查询数据库以更新功能区按钮视图
    [self refreshButtonStateFromQueryDatabase];
    DONG_Log(@">>>>>>>>>>%lu<<<<<<<<<<<",VODIndex);
    
    // 1.关闭正在播放的节目
    if ([self.IJKPlayerViewController.player isPlaying]) {
        [self.IJKPlayerViewController.player pause];
    }
    
    // 2.请求播放地址
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
        if ([PlayerViewRotate isOrientationLandscape]) { // 全屏时
            
            self.IJKPlayerViewController = [IJKVideoPlayerVC initIJKPlayerWithURL:self.url];
            
            self.view.frame = [[UIScreen mainScreen] bounds];
            self.IJKPlayerViewController.view.frame = self.view.bounds;
            self.IJKPlayerViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth & UIViewAutoresizingFlexibleHeight;
            self.IJKPlayerViewController.mediaControl.frame = self.view.frame;
            _IJKPlayerViewController.mediaControl.programNameRunLabel.titleName = [NSString stringWithFormat:@"%@ 第%lu集",_filmModel.FilmName , (unsigned long)_filmModel.jiIndex]; // 节目名称
            [self.view addSubview:_IJKPlayerViewController.view];
            
        } else {
            // 竖屏时
            
            self.IJKPlayerViewController = [IJKVideoPlayerVC initIJKPlayerWithURL:self.url];
            _IJKPlayerViewController.view.frame = CGRectMake(0, 20, kMainScreenWidth, kMainScreenWidth * 9 / 16);
            //_IJKPlayerViewController.mediaControl.programNameLabel.text = _filmModel.FilmName;//节目名称
            _IJKPlayerViewController.mediaControl.programNameRunLabel.titleName = [NSString stringWithFormat:@"%@ 第%lu集",_filmModel.FilmName , (unsigned long)_filmModel.jiIndex]; // 节目名称
            [self.view addSubview:_IJKPlayerViewController.view];
            
        }

        DONG_WeakSelf(self);
        // 1.全屏锁定回调
        weakself.IJKPlayerViewController.fullScreenLockBlock = ^(BOOL isFullScreenLock){
            DONG_StrongSelf(self);
            strongself.fullScreenLock = isFullScreenLock;
        };
        // 2.添加播放记录的回调
        weakself.IJKPlayerViewController.addWatchHistoryBlock = ^(void){
            DONG_StrongSelf(self);
            [strongself addWatchHistoryWithFilmModel:strongself.filmModel];
        };
        // 3.推屏的回调
        weakself.IJKPlayerViewController.pushScreenBlock = ^{
            // 未连接设备时要先扫描设备
            if (XMPPManager.isConnected) {
                NSString *toName = [NSString stringWithFormat:@"%@@hljvoole.com/%@", XMPPManager.uid, XMPPManager.hid];
                NSString *xmlString = [weakself getXMLCommandWithFilmModel:weakself.filmModel];
                //[TCPScoketManager socketWriteData:xmlString withTimeout:-1 tag:1001];
                [XMPPManager sendMessageWithBody:xmlString andToName:toName andType:@"text"];
                
            } else {
                
                [MBProgressHUD showError:@"设备未绑定，请扫码绑定"];
                
                //UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"尚未绑定设备，请先扫码绑定设备" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                //[alertView show];
                //alertView.delegate = weakself;
            }
        };
        // 4.暂停广告
        self.IJKPlayerViewController.mediaControl.advertisementIV.hidden = YES;
        for (SCAdvertisemetPosModel *adPosModel in self.advertisementArray) {
            // 选择暂停广告：706
            if ([adPosModel._pos isEqualToString:@"706"]) {
                
                if (adPosModel.adMediaInfoArray.count) {
                    // 暂停广告有多条
                    SCAdMediaInfo *adMediaInfo = [adPosModel.adMediaInfoArray firstObject];
                    NSURL *imageUrl = [NSURL URLWithString:adMediaInfo.__text];
                    [self.IJKPlayerViewController.mediaControl.advertisementIV sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@""]];
                    
                } else {
                    // 暂停广告只一条
                    NSURL *imageUrl = [NSURL URLWithString:adPosModel.adMediaInfo.__text];
                    [self.IJKPlayerViewController.mediaControl.advertisementIV sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@""]];
                    
                }
                
                break;
            }
        }

        // 数据采集
        [UserInfoManager addCollectionDataWithType:@"Film" filmName:[NSString stringWithFormat:@"%@ 第%lu集",self.filmModel.FilmName , (unsigned long)self.filmModel.jiIndex] mid:_mid];
        
        [CommonFunc dismiss];
        
    } failure:^(id  _Nullable errorObject) {
        [CommonFunc dismiss];
    }];
    
    timesIndexOfVOD = 0;//每次点击后将index复位为0
}

#pragma mark - 综艺播放列表点击事件

- (void)doPlayNewArtsFilmBlock
{
    DONG_WeakSelf(self);
    self.needScrollToTopPage.clickToPlayBlock = ^(NSString *urlStr,SCFilmModel *filmModel){
        DONG_StrongSelf(self);
        // 更改属性值为指定单元节目的filmModel 方便存取
        _filmModel = filmModel;
        // 查询数据库以更新功能区按钮视图
        [strongself refreshButtonStateFromQueryDatabase];
        // 1.关闭正在播放的节目
        if ([strongself.IJKPlayerViewController.player isPlaying]) {
            [strongself.IJKPlayerViewController.player pause];
        }
        
        // 请求播放地址
        [CommonFunc showLoadingWithTips:@""];
        DONG_Log(@"urlStr:%@",urlStr);
        [requestDataManager requestDataWithUrl:urlStr parameters:nil success:^(id  _Nullable responseObject){
            NSString *downLoadUrl = nil;
            if ([responseObject[@"ContentSet"][@"Content"] isKindOfClass:[NSDictionary class]]) {
                downLoadUrl = responseObject[@"ContentSet"][@"Content"][@"_DownUrl"];
            } else if ([responseObject[@"ContentSet"][@"Content"] isKindOfClass:[NSArray class]]) {
                NSArray *array = responseObject[@"ContentSet"][@"Content"];
                downLoadUrl = [array firstObject][@"_DownUrl"];
            }
            
            // 获取fid
            NSString *fidString = [[[[downLoadUrl componentsSeparatedByString:@"?"] lastObject] componentsSeparatedByString:@"&"] firstObject];
            // base64编码downloadUrl
            NSString *downloadBase64Url = [downLoadUrl stringByBase64Encoding];
            // 视频播放url
            NSString *domainUrl = [weakself.domainTransformTool getNewViedoURLByUrlString:VODUrl key:@"vodplayauth"];
            DONG_Log(@"domainUrl:%@",domainUrl);
            NSString *replacedUrl = [weakself.hljRequest getNewViedoURLByOriginVideoURL:domainUrl];
            NSString *VODStreamingUrl = [[[[[[replacedUrl stringByAppendingString:@"&mid="] stringByAppendingString:filmModel._Mid] stringByAppendingString:@"&"] stringByAppendingString:fidString] stringByAppendingString:@"&ext="] stringByAppendingString:downloadBase64Url];
            
            NSLog(@">>>>>>>>>>>downLoadUrl>>>>>>>>%@",downLoadUrl);
            NSLog(@">>>>>>>>>>>VODStreamingUrl>>>>>>>>%@",VODStreamingUrl);
            
            VODIndex = [self.filmsArr indexOfObject:filmModel];
            timesIndexOfVOD = 0; // 每次点击后将index复位为0
            // 对jiIndex赋值
            weakself.filmModel.jiIndex = VODIndex + 1;
            
            DONG_Log(@">>>>>>>>>>%lu<<<<<<<<<<<",VODIndex);
            
            // 1.移除当前的播放器
            [strongself.IJKPlayerViewController closePlayer];
            // 2.请求播放地址
            [requestDataManager requestDataWithUrl:VODStreamingUrl parameters:nil success:^(id  _Nullable responseObject) {
                //            NSLog(@"====responseObject:::%@===",responseObject);
                NSString *play_url = responseObject[@"play_url"];
                // 请求将播放地址域名转换  并拼接最终的播放地址
                NSString *newVideoUrl = [strongself.hljRequest getNewViedoURLByOriginVideoURL:play_url];
                // 1.拼接新地址
                NSString *playUrl = [NSString stringWithFormat:@"http://127.0.0.1:5656/play?url='%@'",newVideoUrl];
                strongself.url = [NSURL URLWithString:playUrl];
                //            strongself.url = [NSURL fileURLWithPath:@"/Users/yesdgq/Downloads/IMG_0839.MOV"];
                // 2.调用播放器播放
                if ([PlayerViewRotate isOrientationLandscape]) { // 全屏时
                    
                    strongself.IJKPlayerViewController = [IJKVideoPlayerVC initIJKPlayerWithURL:strongself.url];
                    
                    strongself.view.frame = [[UIScreen mainScreen] bounds];
                    strongself.IJKPlayerViewController.view.frame = strongself.view.bounds;
                    strongself.IJKPlayerViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth & UIViewAutoresizingFlexibleHeight;
                    strongself.IJKPlayerViewController.mediaControl.frame = strongself.view.frame;
                    strongself.IJKPlayerViewController.mediaControl.programNameRunLabel.titleName = strongself.filmModel.FilmName;//节目名称
                    
                    [strongself.view addSubview:strongself.IJKPlayerViewController.view];
                    
                } else {
                    // 竖屏时
                    
                    strongself.IJKPlayerViewController = [IJKVideoPlayerVC initIJKPlayerWithURL:strongself.url];
                    strongself.IJKPlayerViewController.view.frame = CGRectMake(0, 20, kMainScreenWidth, kMainScreenWidth * 9 / 16);
                    //strongself.IJKPlayerViewController.mediaControl.programNameLabel.text = strongself.filmModel.FilmName;//节目名称
                    strongself.IJKPlayerViewController.mediaControl.programNameRunLabel.titleName = strongself.filmModel.FilmName;//节目名称
                    
                    [strongself.view addSubview:strongself.IJKPlayerViewController.view];
                    
                }
                
                // 1.全屏锁定回调
                weakself.IJKPlayerViewController.fullScreenLockBlock = ^(BOOL isFullScreenLock){
                    DONG_StrongSelf(self);
                    strongself.fullScreenLock = isFullScreenLock;
                };
                // 2.添加播放记录的回调
                weakself.IJKPlayerViewController.addWatchHistoryBlock = ^(void){
                    DONG_StrongSelf(self);
                    [strongself addWatchHistoryWithFilmModel:strongself.filmModel];
                };
                // 3.推屏的回调
                strongself.IJKPlayerViewController.pushScreenBlock = ^{
                    // 未连接设备时要先扫描设备
                    if (XMPPManager.isConnected) {
                        NSString *toName = [NSString stringWithFormat:@"%@@hljvoole.com/%@", XMPPManager.uid, XMPPManager.hid];
                        NSString *xmlString = [weakself getXMLCommandWithFilmModel:weakself.filmModel];
                        //[TCPScoketManager socketWriteData:xmlString withTimeout:-1 tag:1001];
                        [XMPPManager sendMessageWithBody:xmlString andToName:toName andType:@"text"];
                        
                    } else {
                        
                        [MBProgressHUD showError:@"设备未绑定，请扫码绑定"];
                        
                        //UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"尚未绑定设备，请先扫码绑定设备" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                        //[alertView show];
                        //alertView.delegate = weakself;
                    }
                };
                // 4.暂停广告
                strongself.IJKPlayerViewController.mediaControl.advertisementIV.hidden = YES;
                for (SCAdvertisemetPosModel *adPosModel in strongself.advertisementArray) {
                    // 选择暂停广告：706
                    if ([adPosModel._pos isEqualToString:@"706"]) {
                        
                        if (adPosModel.adMediaInfoArray.count) {
                            // 暂停广告有多条
                            SCAdMediaInfo *adMediaInfo = [adPosModel.adMediaInfoArray firstObject];
                            NSURL *imageUrl = [NSURL URLWithString:adMediaInfo.__text];
                            [strongself.IJKPlayerViewController.mediaControl.advertisementIV sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@""]];
                            
                        } else {
                            // 暂停广告只一条
                            NSURL *imageUrl = [NSURL URLWithString:adPosModel.adMediaInfo.__text];
                            [strongself.IJKPlayerViewController.mediaControl.advertisementIV sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@""]];
                            
                        }
                        
                        break;
                    }
                }
                // 数据采集
                [UserInfoManager addCollectionDataWithType:@"Film" filmName:weakself.filmModel.FilmName mid:filmModel._Mid];
                
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

// 电视剧请求数据
- (void)getTeleplayData
{
    if (_filmModel._Mid) {
        _mid = _filmModel._Mid;
    }else if (_filmModel.mid){
        _mid = _filmModel.mid;
    }
    
    NSString *filmmidStr = _mid ? _mid : @"";
    //请求播放资源
    [CommonFunc showLoadingWithTips:@""];
    NSDictionary *parameters = @{@"pagesize" : @"1000",
                                 @"ctype"    : @"4",
                                 @"filmmid" : filmmidStr};
    
    // 域名获取
    _domainTransformTool = [[SCDomaintransformTool alloc] init];
    [_domainTransformTool getNewDomainByUrlString:FilmSourceUrl key:@"skdbpd" success:^(id  _Nullable newUrlString) {
        
        DONG_Log(@"newUrlString:%@",newUrlString);
        // ip转换
        _hljRequest = [HLJRequest requestWithPlayVideoURL:newUrlString];
        [_hljRequest getNewVideoURLSuccess:^(NSString *newVideoUrl) {
            
            DONG_Log(@"newVideoUrl:%@",newVideoUrl);
            
            
            [requestDataManager requestDataWithUrl:newVideoUrl parameters:parameters success:^(id  _Nullable responseObject) {
                //DONG_Log(@"====responseObject:::%@===",responseObject);
                if (responseObject) {
                    
                    NSString *mid = responseObject[@"Film"][@"_Mid"];
                    DONG_Log(@"_mid:%@",mid);
                    // 介绍页model
                    self.filmIntroduceModel  = [SCFilmIntroduceModel mj_objectWithKeyValues:responseObject[@"Film"]];
                    
                    if ([responseObject[@"ContentSet"][@"Content"] isKindOfClass:[NSDictionary class]]){
                        SCFilmSetModel *model = [SCFilmSetModel mj_objectWithKeyValues:responseObject[@"ContentSet"][@"Content"]];
                        
                        NSString *downloadUrl = responseObject[@"ContentSet"][@"Content"][@"_DownUrl"];
                        
                        // base64编码downloadUrl
                        NSString *downloadBase64Url = [downloadUrl stringByBase64Encoding];
                        
                        // 获取fid
                        NSString *fidString = [[[[downloadUrl componentsSeparatedByString:@"?"] lastObject] componentsSeparatedByString:@"&"] firstObject];
                        // base64编码downloadUrl
                        
                        // 视频播放url
                        NSString *domainUrl = [_domainTransformTool getNewViedoURLByUrlString:VODUrl key:@"vodplayauth"];
                        DONG_Log(@"domainUrl:%@",domainUrl);
                        NSString *replacedUrl = [_hljRequest getNewViedoURLByOriginVideoURL:domainUrl];
                        NSString *VODStreamingUrl = [[[[[[replacedUrl stringByAppendingString:@"&mid="] stringByAppendingString:mid] stringByAppendingString:@"&"] stringByAppendingString:fidString] stringByAppendingString:@"&ext="] stringByAppendingString:downloadBase64Url];
                        
                        model.VODStreamingUrl = VODStreamingUrl;
                        
                        //NSLog(@">>>>>>>>>>>DownUrl>>>>>>>>>>>>>%@",downloadUrl);
                        //NSLog(@">>>>>>>>>>>>VODStreamingUrl>>>>>>>>>>>%@",model.VODStreamingUrl);
                        [_filmSetsArr addObject:model];
                        
                    } else if ([responseObject[@"ContentSet"][@"Content"] isKindOfClass:[NSArray class]]){
                        
                        
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
                            NSString *domainUrl = [_domainTransformTool getNewViedoURLByUrlString:VODUrl key:@"vodplayauth"];
                            DONG_Log(@"domainUrl:%@",domainUrl);
                            NSString *replacedUrl = [_hljRequest getNewViedoURLByOriginVideoURL:domainUrl];
                            NSString *VODStreamingUrl = [[[[[[replacedUrl stringByAppendingString:@"&mid="] stringByAppendingString:mid] stringByAppendingString:@"&"] stringByAppendingString:fidString] stringByAppendingString:@"&ext="] stringByAppendingString:downloadBase64Url];
                            
                            model.VODStreamingUrl = VODStreamingUrl;
                            //NSLog(@">>>>>>>>>>>DownUrl>>>>>>>>>>>>>%@",downloadUrl);
                            //NSLog(@">>>>>>>>>>>>VODStreamingUrl>>>>>>>>>>>%@",model.VODStreamingUrl);
                            [_filmSetsArr addObject:model];
                            
                        }
                    }
                    
                    if (_filmSetsArr.count == 1) {
                        
                        self.titleArr = @[@"详情", @"精彩推荐"];
                        self.identifier = @"电影";
                        
                    } else if (_filmSetsArr.count > 1){
                        
                        self.titleArr = @[@"剧情", @"详情", @"精彩推荐"];
                        self.identifier = @"电视剧";
                        
                    }
                    // 1.添加滑动headerView
                    [self constructSlideHeaderView];
                    // 2.添加contentScrllowView
                    [self constructContentView];
                    
                    /*
                     * 如 _filmModel.jiIndex > 1 则为由观看记录进入(_filmModel.jiIndex初始值为0)
                     * 需要定位播放焦点
                     * 通过发送通知定位 _filmModel不用改变
                     */
                    SCFilmSetModel *filmSetModel = nil;
                    if (_filmModel.jiIndex > 1) {
                        if (_filmModel.jiIndex - 1 < self.filmSetsArr.count) {
                            
                            filmSetModel = self.filmSetsArr[_filmModel.jiIndex - 1];
                            SCFilmSetModel *lastFilmSetModel = self.filmSetsArr[_filmModel.jiIndex - 2];;
                            
                            
                            NSDictionary *message = @{@"nextFilmSetModel" : filmSetModel,
                                                      @"lastFilmSetModel" : lastFilmSetModel};
                            [[NSNotificationCenter defaultCenter] postNotificationName:ChangeCellStateWhenPlayNextVODFilm object:message];
                            
                            /*
                             * 比较乱
                             *
                             * VODIndex需要矫正 不矫正时VODIndex=0 自动播放下一个节目时焦点位置会出错
                             * 此时_filmModel.filmSetModel为空 需要赋值
                             */
                            VODIndex = _filmModel.jiIndex - 1;
                            //将filmsetmodel和filmmodel关联起来，便于直接从数据库读取信息后播放
                            _filmModel.filmSetModel = [[SCFilmSetModel alloc] initWithValue:filmSetModel];
                            
                        }
                        
                    } else {
                        
                        filmSetModel = [_filmSetsArr firstObject];
                        filmSetModel.onLive = YES;
                        _filmSetModel = filmSetModel;
                        _filmModel.jiIndex = 1;
                        //将filmsetmodel和filmmodel关联起来，便于直接从数据库读取信息后播放
                        _filmModel.filmSetModel = [[SCFilmSetModel alloc] initWithValue:filmSetModel];
                        
                    }
                    
                    // 请求第一集的播放地址
                    [requestDataManager requestDataWithUrl:filmSetModel.VODStreamingUrl parameters:nil success:^(id  _Nullable responseObject) {
                        //            NSLog(@"====responseObject:::%@===",responseObject);
                        NSString *play_url = responseObject[@"play_url"];
                        DONG_Log(@"responseObject:%@",play_url);
                        //请求将播放地址域名转换  并拼接最终的播放地址
                        NSString *newVideoUrl = [self.hljRequest getNewViedoURLByOriginVideoURL:play_url];
                        
                        DONG_Log(@"newVideoUrl:%@",newVideoUrl);
                        //1.拼接新地址
                        NSString *playUrl = [NSString stringWithFormat:@"http://127.0.0.1:5656/play?url='%@'",newVideoUrl];
                        self.url = [NSURL URLWithString:playUrl];
                        //self.url = [NSURL fileURLWithPath:@"/Users/yesdgq/Downloads/IMG_0839.MOV"];
                        
                        // 2.调用播放器播放
                        if ([PlayerViewRotate isOrientationLandscape]) { // 全屏时
                            
                            self.IJKPlayerViewController = [IJKVideoPlayerVC initIJKPlayerWithURL:self.url];
                            
                            self.view.frame = [[UIScreen mainScreen] bounds];
                            self.IJKPlayerViewController.view.frame = self.view.bounds;
                            self.IJKPlayerViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth & UIViewAutoresizingFlexibleHeight;
                            self.IJKPlayerViewController.mediaControl.frame = self.view.frame;
                            _IJKPlayerViewController.mediaControl.programNameRunLabel.titleName = [NSString stringWithFormat:@"%@第%lu集",_filmModel.FilmName , (unsigned long)_filmModel.jiIndex ]; // 节目名称
                            [self.view addSubview:_IJKPlayerViewController.view];
                            
                        } else {
                            // 竖屏时
                            
                            self.IJKPlayerViewController = [IJKVideoPlayerVC initIJKPlayerWithURL:self.url];
                            _IJKPlayerViewController.view.frame = CGRectMake(0, 20, kMainScreenWidth, kMainScreenWidth * 9 / 16);
                            //_IJKPlayerViewController.mediaControl.programNameLabel.text = _filmModel.FilmName;// 节目名称
                            _IJKPlayerViewController.mediaControl.programNameRunLabel.titleName = [NSString stringWithFormat:@"%@ 第%lu集",_filmModel.FilmName , (unsigned long)_filmModel.jiIndex ]; // 节目名称
                            [self.view addSubview:_IJKPlayerViewController.view];
                            
                        }
                        
                        DONG_WeakSelf(self);
                        //1.全屏锁定回调
                        weakself.IJKPlayerViewController.fullScreenLockBlock = ^(BOOL isFullScreenLock){
                            DONG_StrongSelf(self);
                            strongself.fullScreenLock = isFullScreenLock;
                        };
                        //2.添加播放记录的回调
                        weakself.IJKPlayerViewController.addWatchHistoryBlock = ^(void){
                            DONG_StrongSelf(self);
                            [strongself addWatchHistoryWithFilmModel:strongself.filmModel];
                        };
                        //3.推屏的回调
                        weakself.IJKPlayerViewController.pushScreenBlock = ^{
                            // 未连接设备时要先扫描设备
                            if (XMPPManager.isConnected) {
                                NSString *toName = [NSString stringWithFormat:@"%@@hljvoole.com/%@", XMPPManager.uid, XMPPManager.hid];
                                NSString *xmlString = [weakself getXMLCommandWithFilmModel:weakself.filmModel];
                                //[TCPScoketManager socketWriteData:xmlString withTimeout:-1 tag:1001];
                                [XMPPManager sendMessageWithBody:xmlString andToName:toName andType:@"text"];
                                
                            } else {
                                
                                [MBProgressHUD showError:@"设备未绑定，请扫码绑定"];
                                
                                //UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"尚未绑定设备，请先扫码绑定设备" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                                //[alertView show];
                                //alertView.delegate = weakself;
                            }
                        };
                        // 4.暂停广告
                        self.IJKPlayerViewController.mediaControl.advertisementIV.hidden = YES;
                        for (SCAdvertisemetPosModel *adPosModel in self.advertisementArray) {
                            // 选择暂停广告：706
                            if ([adPosModel._pos isEqualToString:@"706"]) {
                                
                                if (adPosModel.adMediaInfoArray.count) {
                                    // 暂停广告有多条
                                    SCAdMediaInfo *adMediaInfo = [adPosModel.adMediaInfoArray firstObject];
                                    NSURL *imageUrl = [NSURL URLWithString:adMediaInfo.__text];
                                    [self.IJKPlayerViewController.mediaControl.advertisementIV sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@""]];
                                    
                                } else {
                                    // 暂停广告只一条
                                    NSURL *imageUrl = [NSURL URLWithString:adPosModel.adMediaInfo.__text];
                                    [self.IJKPlayerViewController.mediaControl.advertisementIV sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@""]];
                                    
                                }
                                
                                break;
                            }
                        }
                        // 数据采集
                        [UserInfoManager addCollectionDataWithType:@"Film" filmName:[NSString stringWithFormat:@"%@ 第%lu集",_filmModel.FilmName , (unsigned long)_filmModel.jiIndex ] mid:filmmidStr];
                        
                        [CommonFunc dismiss];
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
        
    } failure:^(id  _Nullable errorObject) {
        
        [CommonFunc dismiss];
        
    }];
}

// 综艺请求数据
- (void)getArtsAndLifeData
{
    if (_filmModel._Mid) {
        _mid = _filmModel._Mid;
    } else if (_filmModel.mid){
        _mid = _filmModel.mid;
    }
    
    NSString *filmMidStr = _mid ? _mid : @"";
    
    DONG_Log(@"filmMidStr:%@",filmMidStr);
    
    NSDictionary *parameters = @{@"pagesize" : @"1000",
                                 @"ctype"    : @"102",
                                 @"filmmid" : filmMidStr};
    
    [CommonFunc showLoadingWithTips:@""];
    DONG_WeakSelf(self);
    
    // 域名获取
    _domainTransformTool = [[SCDomaintransformTool alloc] init];
    [_domainTransformTool getNewDomainByUrlString:ArtsAndLifeSourceUrl key:@"skdbpd" success:^(id  _Nullable newUrlString) {
        
        DONG_Log(@"newUrlString:%@",newUrlString);
        // ip转换
        _hljRequest = [HLJRequest requestWithPlayVideoURL:newUrlString];
        [_hljRequest getNewVideoURLSuccess:^(NSString *newVideoUrl) {
            
            DONG_Log(@"newVideoUrl:%@",newVideoUrl);
            
            [requestDataManager requestDataWithUrl:newVideoUrl parameters:parameters success:^(id  _Nullable responseObject) {
                DONG_StrongSelf(self);
//                            DONG_Log(@"====responseObject======%@===",responseObject);
                [strongself.filmsArr removeAllObjects];
                if (responseObject) {
                    
                    // 介绍页model
                    strongself.filmIntroduceModel  = [SCFilmIntroduceModel mj_objectWithKeyValues:responseObject[@"ParentFilm"]];
                    
                    if ([responseObject[@"Film"] isKindOfClass:[NSDictionary class]]){
                        
                        SCFilmModel *model = [SCFilmModel mj_objectWithKeyValues:responseObject[@"Film"]];
                        model.onLive = YES;
                        [strongself.filmsArr addObject:model];
                        
                    } else if ([responseObject[@"Film"] isKindOfClass:[NSArray class]]){
                        
                        [responseObject[@"Film"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            
                            NSDictionary *dic = obj;
                            SCFilmModel *model = [SCFilmModel mj_objectWithKeyValues:dic];
                            //                        if (idx == 0) {
                            //                            model.onLive = YES;
                            //                        }
                            [strongself.filmsArr addObject:model];
                        }];
                    }
                }
                strongself.titleArr = @[@"剧情", @"详情"];
                strongself.identifier = @"综艺";
                
                //4.添加滑动headerView
                [strongself constructSlideHeaderView];
                [strongself constructContentView];
                
                SCFilmModel *artsFilmModel = nil;
                
                /*
                 * 如 jiIndex > 1 则为由观看记录进入(_filmModel.jiIndex初始值为0)
                 * 需要定位播放焦点
                 * 通过发送通知定位 _filmModel不用改变
                 */
                if (_filmModel.jiIndex > 1) {
                    if (_filmModel.jiIndex - 1 < self.filmsArr.count) {
                        
                        artsFilmModel = self.filmsArr[_filmModel.jiIndex - 1];
                        NSString *VODIndex2 = [NSString stringWithFormat:@"%lu",_filmModel.jiIndex - 1];
                        
                        NSDictionary *message = @{@"filmModel" : artsFilmModel,
                                                  @"VODIndex" : VODIndex2};
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:ChangeCellStateWhenPlayNextVODFilm object:message];
                        
                        /*
                         * 比较乱
                         *
                         * 当从观看记录播放时，filmModel是没有SourceURL的，如果此时添加到收藏或者节目单 再从收藏或节目单播放时，
                         * filmModel.SourceURL为空则无法播放，所以这里要给filmModel.SourceURL赋值
                         *
                         * VODIndex需要矫正 不矫正时VODIndex=0 自动播放下一个节目时焦点位置会出错
                         *
                         */
                        
                        _filmModel.SourceURL = artsFilmModel.SourceURL;
                        VODIndex = _filmModel.jiIndex - 1;
                    }
                    
                } else {
                    
                    artsFilmModel = [strongself.filmsArr firstObject];
                    artsFilmModel.onLive = YES;
                    _filmModel = artsFilmModel;
                    _filmModel.jiIndex = 1;
                }
                
                //请求播放地址
                NSString *urlStr = [artsFilmModel.SourceURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                //获取downLoadUrl
                [requestDataManager requestDataWithUrl:urlStr parameters:nil success:^(id  _Nullable responseObject) {
                    
                    
                    //DONG_Log(@"responseObject:%@", responseObject[@"ContentSet"][@"Content"]);
                    
                    NSString *downLoadUrl = nil;
                    
                    if ([responseObject[@"ContentSet"][@"Content"] isKindOfClass:[NSDictionary class]]) {
                        
                        downLoadUrl  = responseObject[@"ContentSet"][@"Content"][@"_DownUrl"];
                        
                    } else if ([responseObject[@"ContentSet"][@"Content"] isKindOfClass:[NSArray class]]) {
                        
                        downLoadUrl  = [responseObject[@"ContentSet"][@"Content"] firstObject][@"_DownUrl"];
                        
                    }
                    //获取fid
                    NSString *fidString = [[[[downLoadUrl componentsSeparatedByString:@"?"] lastObject] componentsSeparatedByString:@"&"] firstObject];
                    //base64编码downloadUrl
                    NSString *downloadBase64Url = [downLoadUrl stringByBase64Encoding];
                    //这只是个请求视频播放流的url地址
                    NSString *domainUrl = [_domainTransformTool getNewViedoURLByUrlString:VODUrl key:@"vodplayauth"];
                    DONG_Log(@"domainUrl:%@",domainUrl);
                    //视频播放url
                    NSString *replacedUrl = [strongself.hljRequest getNewViedoURLByOriginVideoURL:domainUrl];
                    NSString *VODStreamingUrl = [[[[[[replacedUrl stringByAppendingString:@"&mid="] stringByAppendingString:artsFilmModel._Mid] stringByAppendingString:@"&"] stringByAppendingString:fidString] stringByAppendingString:@"&ext="] stringByAppendingString:downloadBase64Url];
                    //获取play_url
                    [requestDataManager requestDataWithUrl:VODStreamingUrl parameters:nil success:^(id  _Nullable responseObject) {
                        //            NSLog(@"====responseObject:::%@===",responseObject);
                        NSString *play_url = responseObject[@"play_url"];
                        DONG_Log(@"responseObject:%@",play_url);
                        //请求将播放地址域名转换  并拼接最终的播放地址
                        NSString *newVideoUrl = [strongself.hljRequest getNewViedoURLByOriginVideoURL:play_url];
                        DONG_Log(@"newVideoUrl:%@",newVideoUrl);
                        // 1.拼接新地址
                        NSString *playUrl = [NSString stringWithFormat:@"http://127.0.0.1:5656/play?url='%@'",newVideoUrl];
                        strongself.url = [NSURL URLWithString:playUrl];
                        // 2.调用播放器播放
                        if ([PlayerViewRotate isOrientationLandscape]) { // 全屏时
                            
                            strongself.IJKPlayerViewController = [IJKVideoPlayerVC initIJKPlayerWithURL:strongself.url];
                            
                            strongself.view.frame = [[UIScreen mainScreen] bounds];
                            strongself.IJKPlayerViewController.view.frame = strongself.view.bounds;
                            strongself.IJKPlayerViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth & UIViewAutoresizingFlexibleHeight;
                            strongself.IJKPlayerViewController.mediaControl.frame = strongself.view.frame;
                            strongself.IJKPlayerViewController.mediaControl.programNameRunLabel.titleName = strongself.filmModel.FilmName;//节目名称
                            [strongself.view addSubview:strongself.IJKPlayerViewController.view];
                            
                        } else {
                            
                            // 竖屏时
                            strongself.IJKPlayerViewController = [IJKVideoPlayerVC initIJKPlayerWithURL:strongself.url];
                            strongself.IJKPlayerViewController.view.frame = CGRectMake(0, 20, kMainScreenWidth, kMainScreenWidth * 9 / 16);
                            //strongself.IJKPlayerViewController.mediaControl.programNameLabel.text = strongself.filmModel.FilmName;//节目名称
                            strongself.IJKPlayerViewController.mediaControl.programNameRunLabel.titleName = strongself.filmModel.FilmName;//节目名称
                            [strongself.view addSubview:strongself.IJKPlayerViewController.view];
                            
                        }
                        
                        //1.全屏锁定回调
                        strongself.IJKPlayerViewController.fullScreenLockBlock = ^(BOOL isFullScreenLock){
                            DONG_StrongSelf(self);
                            strongself.fullScreenLock = isFullScreenLock;
                        };
                        //2.添加播放记录的回调
                        strongself.IJKPlayerViewController.addWatchHistoryBlock = ^(void){
                            DONG_StrongSelf(self);
                            [strongself addWatchHistoryWithFilmModel:strongself.filmModel];
                        };
                        //3.推屏的回调
                        strongself.IJKPlayerViewController.pushScreenBlock = ^{
                            // 未连接设备时要先扫描设备
                            if (XMPPManager.isConnected) {
                                NSString *toName = [NSString stringWithFormat:@"%@@hljvoole.com/%@", XMPPManager.uid, XMPPManager.hid];
                                NSString *xmlString = [weakself getXMLCommandWithFilmModel:weakself.filmModel];
                                //[TCPScoketManager socketWriteData:xmlString withTimeout:-1 tag:1001];
                                [XMPPManager sendMessageWithBody:xmlString andToName:toName andType:@"text"];
                                
                            } else {
                                
                                [MBProgressHUD showError:@"设备未绑定，请扫码绑定"];
                                
                                //UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"尚未绑定设备，请先扫码绑定设备" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                                //[alertView show];
                                //alertView.delegate = weakself;
                            }
                        };
                        // 4.暂停广告
                        strongself.IJKPlayerViewController.mediaControl.advertisementIV.hidden = YES;
                        for (SCAdvertisemetPosModel *adPosModel in strongself.advertisementArray) {
                            // 选择暂停广告：706
                            if ([adPosModel._pos isEqualToString:@"706"]) {
                                
                                if (adPosModel.adMediaInfoArray.count) {
                                    // 暂停广告有多条
                                    SCAdMediaInfo *adMediaInfo = [adPosModel.adMediaInfoArray firstObject];
                                    NSURL *imageUrl = [NSURL URLWithString:adMediaInfo.__text];
                                    [strongself.IJKPlayerViewController.mediaControl.advertisementIV sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@""]];
                                    
                                } else {
                                    // 暂停广告只一条
                                    NSURL *imageUrl = [NSURL URLWithString:adPosModel.adMediaInfo.__text];
                                    [strongself.IJKPlayerViewController.mediaControl.advertisementIV sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@""]];
                                    
                                }
                                break;
                            }
                        }
                        // 数据采集
                        [UserInfoManager addCollectionDataWithType:@"Film" filmName:self.filmModel.FilmName mid:filmMidStr];
                        
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
        
        
    } failure:^(id  _Nullable errorObject) {
        
        [CommonFunc dismiss];
        
    }];
    
}

// 电影请求数据
- (void)getMovieData
{
    [CommonFunc showLoadingWithTips:@""];
    
    if (_filmModel._Mid) {
        _mid = _filmModel._Mid;
    }else if (_filmModel.mid){
        _mid = _filmModel.mid;
    }
    
    _filmModel.jiIndex = -1;
    NSString *filmmidStr = _mid ? _mid : @"";
    
    NSDictionary *parameters = @{@"pagesize" : @"1000",
                                 @"ctype"    : @"4",
                                 @"filmmid"  : filmmidStr};
    
    DONG_WeakSelf(self);
    
    // 域名获取
    _domainTransformTool = [[SCDomaintransformTool alloc] init];
    [_domainTransformTool getNewDomainByUrlString:FilmSourceUrl key:@"skdbpd" success:^(id  _Nullable newUrlString) {
        
        DONG_Log(@"newUrlString:%@",newUrlString);
        // ip转换
        _hljRequest = [HLJRequest requestWithPlayVideoURL:newUrlString];
        [_hljRequest getNewVideoURLSuccess:^(NSString *newVideoUrl) {
            
            DONG_Log(@"newVideoUrl:%@",newVideoUrl);
            
            // 请求film详细信息
            [requestDataManager requestDataWithUrl:newVideoUrl parameters:parameters success:^(id  _Nullable responseObject) {
                //            DONG_Log(@"====responseObject:::%@===",responseObject);
                
                DONG_StrongSelf(self);
                // 介绍页model
                strongself.filmIntroduceModel  = [SCFilmIntroduceModel mj_objectWithKeyValues:responseObject[@"Film"]];
                
                // 坑：：单片不同film竟然数据结构不同 服了！
                // downloadUrl
                NSString *downloadUrl;
                if ([responseObject[@"ContentSet"][@"Content"] isKindOfClass:[NSDictionary class]]){
                    
                    downloadUrl = responseObject[@"ContentSet"][@"Content"][@"_DownUrl"];
                    
                }else if ([responseObject[@"ContentSet"][@"Content"] isKindOfClass:[NSArray class]]){
                    
                    downloadUrl = [responseObject[@"ContentSet"][@"Content"] firstObject][@"_DownUrl"];
                }
                
                //base64编码downloadUrl
                NSString *downloadBase64Url = [downloadUrl stringByBase64Encoding];
                
                DONG_Log(@">>>>>>>>>>>>filmmid>>>>>>>>>>%@",filmmidStr);
                DONG_Log(@">>>>>>>>>>>>downloadUrl>>>>>>>>>>%@",downloadUrl);
                DONG_Log(@">>>>>>>>>>>>downloadBase64Url>>>>>>>>>>%@",downloadBase64Url);
                
                
                //获取fid
                NSString *fidString = [[[[downloadUrl componentsSeparatedByString:@"?"] lastObject] componentsSeparatedByString:@"&"] firstObject];
                
                //这只是个请求视频播放流的url地址
                NSString *domainUrl = [_domainTransformTool getNewViedoURLByUrlString:VODUrl key:@"vodplayauth"];
                DONG_Log(@"domainUrl:%@",domainUrl);
                
                NSString *replacedUrl = [strongself.hljRequest getNewViedoURLByOriginVideoURL:domainUrl];
                
                DONG_Log(@"replacedUrl:%@",replacedUrl);
                
                // 拼接出认证地址
                NSString *VODStreamingUrl = [[[[[[replacedUrl stringByAppendingString:@"&mid="] stringByAppendingString:filmmidStr] stringByAppendingString:@"&"] stringByAppendingString:fidString] stringByAppendingString:@"&ext="] stringByAppendingString:downloadBase64Url];
                
                
                
                //                DONG_Log(@">>>>>>>>>>>replacedUrl>>>>>>>>>>%@",replacedUrl);
                //                DONG_Log(@">>>>>>>>>>>filmmidStr>>>>>>>>>>%@",filmmidStr);
                //                DONG_Log(@">>>>>>>>>>>fidString>>>>>>>>>>%@",fidString);
//               DONG_Log(@"downloadBase64Url：%@",downloadBase64Url);
               DONG_Log(@"影片认证地址>>>VODStreamingUrl：%@",VODStreamingUrl);
                
                strongself.titleArr = @[@"详情", @"精彩推荐"];
                strongself.identifier = @"电影";
                
                // 4.添加滑动headerView
                [strongself constructSlideHeaderView];
                [strongself constructContentView];
                
                
                //请求播放地址
                [requestDataManager requestDataWithUrl:VODStreamingUrl parameters:nil success:^(id  _Nullable responseObject) {
                    //DONG_Log(@"====responseObject:::%@===",responseObject);
                    
                    // 处理广告信息
                    NSDictionary *adinfoDic = responseObject[@"adinfo"];
                    [_advertisementArray removeAllObjects];
                    
                    if (adinfoDic) {
                        if ([adinfoDic[@"adpos"] isKindOfClass:[NSArray class]]) {
                            
                            NSArray *adposArray = adinfoDic[@"adpos"];
                            if (adposArray.count) {
                                for (NSDictionary *adUnitDic in adposArray) {
                                    
                                    SCAdvertisemetPosModel *adPosModel = [SCAdvertisemetPosModel mj_objectWithKeyValues:adUnitDic];
                                    
                                    [_advertisementArray addObject:adPosModel];
                                    
                                    DONG_Log(@"adPosModel:%@", adPosModel.adMediaInfo.__text);
                                }
                            }
                            
                        } else if ([adinfoDic[@"adpos"] isKindOfClass:[NSDictionary class]]) {
                            
                            SCAdvertisemetPosModel *adPosModel = [SCAdvertisemetPosModel mj_objectWithKeyValues:adinfoDic[@"adpos"]];
                            
                            [_advertisementArray addObject:adPosModel];
                            
                        }
                    }
                    
                    NSString *play_url = responseObject[@"play_url"];
                    DONG_Log(@"play_url:%@",play_url);
                    //请求将播放地址域名转换  并拼接最终的播放地址
                    NSString *newVideoUrl = [strongself.hljRequest getNewViedoURLByOriginVideoURL:play_url];
                    
                    DONG_Log(@"newVideoUrl:%@",newVideoUrl);
                    //1.拼接新地址
                    NSString *playUrl = [NSString stringWithFormat:@"http://127.0.0.1:5656/play?url='%@'",newVideoUrl];
                    strongself.url = [NSURL URLWithString:playUrl];
                    
                    if ([PlayerViewRotate isOrientationLandscape]) { // 全屏时
                        
                        //2.调用播放器播放
                        strongself.IJKPlayerViewController = [IJKVideoPlayerVC initIJKPlayerWithURL:strongself.url];
                        strongself.view.frame = [[UIScreen mainScreen] bounds];
                        strongself.IJKPlayerViewController.view.frame = strongself.view.bounds;
                        strongself.IJKPlayerViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth & UIViewAutoresizingFlexibleHeight;
                        strongself.IJKPlayerViewController.mediaControl.frame = strongself.view.frame;
                        [strongself.view addSubview:strongself.IJKPlayerViewController.view];
                        [strongself.view bringSubviewToFront:strongself.IJKPlayerViewController.view];
                        
                    } else {
                        
                        // 2.调用播放器播放
                        strongself.IJKPlayerViewController = [IJKVideoPlayerVC initIJKPlayerWithURL:strongself.url];
                        strongself.IJKPlayerViewController.view.frame = CGRectMake(0, 20, kMainScreenWidth, kMainScreenWidth * 9 / 16);
                        
                        [strongself.view addSubview:strongself.IJKPlayerViewController.view];
                    }
                    
                    NSString *filmName;
                    if (strongself.filmModel.FilmName) {
                        filmName = strongself.filmModel.FilmName;
                    }else if (strongself.filmModel.cnname){
                        filmName = strongself.filmModel.cnname;
                    }
                    
                    strongself.IJKPlayerViewController.mediaControl.programNameRunLabel.titleName = filmName;
                    
                    // 1.全屏锁定回调
                    strongself.IJKPlayerViewController.fullScreenLockBlock = ^(BOOL isFullScreenLock){
                        DONG_StrongSelf(self);
                        strongself.fullScreenLock = isFullScreenLock;
                    };
                    // 2.添加播放记录的回调
                    strongself.IJKPlayerViewController.addWatchHistoryBlock = ^(void){
                        DONG_StrongSelf(self);
                        [strongself addWatchHistoryWithFilmModel:strongself.filmModel];
                    };
                    // 3.推屏的回调
                    strongself.IJKPlayerViewController.pushScreenBlock = ^{
                        // 未连接设备时要先扫描设备
                        if (XMPPManager.isConnected) {
                            NSString *toName = [NSString stringWithFormat:@"%@@hljvoole.com/%@", XMPPManager.uid, XMPPManager.hid];
                            NSString *xmlString = [weakself getXMLCommandWithFilmModel:weakself.filmModel];
                            //[TCPScoketManager socketWriteData:xmlString withTimeout:-1 tag:1001];
                            [XMPPManager sendMessageWithBody:xmlString andToName:toName andType:@"text"];
                            
                        } else {
                            
                            [MBProgressHUD showError:@"设备未绑定，请扫码绑定"];
                            
                            //UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"尚未绑定设备，请先扫码绑定设备" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                            //[alertView show];
                            //alertView.delegate = weakself;
                        }
                    };
                    // 4.暂停广告
                    strongself.IJKPlayerViewController.mediaControl.advertisementIV.hidden = YES;
                    
                    for (SCAdvertisemetPosModel *adPosModel in strongself.advertisementArray) {
                        // 选择暂停广告：706
                        if ([adPosModel._pos isEqualToString:@"706"]) {
                            
                            if (adPosModel.adMediaInfoArray.count) {
                                // 暂停广告有多条
                                SCAdMediaInfo *adMediaInfo = [adPosModel.adMediaInfoArray firstObject];
                                NSURL *imageUrl = [NSURL URLWithString:adMediaInfo.__text];
                                [strongself.IJKPlayerViewController.mediaControl.advertisementIV sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@""]];
                                
                            } else {
                                // 暂停广告只一条
                                NSURL *imageUrl = [NSURL URLWithString:adPosModel.adMediaInfo.__text];
                                [strongself.IJKPlayerViewController.mediaControl.advertisementIV sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@""]];
                                
                            }
                            
                            break;
                        }
                    }
                    
                    // 数据采集
                    [UserInfoManager addCollectionDataWithType:@"Film" filmName:filmName mid:filmmidStr];
                    
                    [CommonFunc dismiss];
                    
                } failure:^(id  _Nullable errorObject) {
                    [CommonFunc dismiss];
                }];
                
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
        //扫描连接设备
        //        SCSearchDeviceVC *searchDeviceVC = DONG_INSTANT_VC_WITH_ID(@"Discovery", @"SCSearchDeviceVC");
        //        searchDeviceVC.entrance = @"player";
        //        searchDeviceVC.hidesBottomBarWhenPushed = YES;
        //        [self.navigationController pushViewController:searchDeviceVC animated:YES];
        
        SCScanQRCodesVC *scanQRCodesVC = DONG_INSTANT_VC_WITH_ID(@"Discovery", @"SCScanQRCodesVC");
        scanQRCodesVC.entrance = @"player";
        scanQRCodesVC.isQQSimulator = YES;
        scanQRCodesVC.isVideoZoom = YES;
        scanQRCodesVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:scanQRCodesVC animated:YES];
        
    }
}

#pragma mark - XMLCommandConstruction 推屏

- (NSString *)getXMLCommandWithFilmModel:(SCFilmModel *)filmModel
{
    NSString *filmName;
    if (filmModel.FilmName) {
        filmName = filmModel.FilmName;
    }else if (filmModel.cnname){
        filmName = filmModel.cnname;
    }
    
    NSString *mid;
    if (filmModel._Mid) {
        mid = filmModel._Mid;
    }else if (filmModel.mid){
        mid = filmModel.mid;
    }
    
    NSString *sid       = [NSString stringWithFormat:@"%ld", filmModel.jiIndex];
    NSString *tvId      = filmModel._TvId;
    NSString *startTime = @"";
    NSString *endTime   = @"";
    NSString *currentPlayTime = [NSString stringWithFormat:@"%.0f", self.IJKPlayerViewController.player.currentPlaybackTime * 1000];
    
    NSString *xmlString = [self getXMLStringCommandWithFilmName:filmName mid:mid sid:sid tvId:tvId currentPlayTime:currentPlayTime startTime:startTime endTime:endTime];
    DONG_Log(@"currentPlayTime:%@",currentPlayTime);
    return xmlString;
}

- (NSString *) getXMLStringCommandWithFilmName:(NSString *)filmName mid:(NSString *)mid sid:(NSString *)sid tvId:(NSString *)tvId currentPlayTime:(NSString *)currentPlayTime startTime:(NSString *)startTime endTime:(NSString *)endTime
{
    NSString *targetName   = @"epg.vurc.action";
    NSString *messageType  = @"sendContent2TV";
    NSString *deviceType   = @"TV";
    NSString *playingType  = @"dianbo";
    NSString *currentIndex = @"";
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


#pragma mark - setter
- (void)setFullScreenLock:(BOOL)fullScreenLock {
    _fullScreenLock = fullScreenLock;
    [self shouldAutorotate];
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
