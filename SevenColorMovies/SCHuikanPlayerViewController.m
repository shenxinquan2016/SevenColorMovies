//
//  SCHuikanPlayerViewController.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/10/12.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  搜索-->回看 简洁播放器

#import "SCHuikanPlayerViewController.h"
#import "IJKVideoPlayerVC.h"
#import "SCLiveProgramModel.h"
#import "SCFilmModel.h"
#import "PlayerViewRotate.h"//横竖屏强制转换
#import "AppDelegate.h"
@interface SCHuikanPlayerViewController ()

@property (nonatomic, strong) SCLiveProgramModel *programModel;
@property (nonatomic, strong) SCFilmModel *filmModel;
@property (nonatomic, strong) SCLiveProgramModel *liveProgramModel;
@property (nonatomic, strong) IJKVideoPlayerVC *IJKPlayerViewController;/** 播放器控制器 */
@property (nonatomic, strong) HLJRequest *hljRequest;/** 域名替换工具 */
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, assign) BOOL isProhibitRotate;/** 是否禁止旋转 */

@end

@implementation SCHuikanPlayerViewController

#pragma mark - Initialize

/** 直播拉屏 */
+ (instancetype)initPlayerWithLiveProgramModel:(SCLiveProgramModel *)liveProgramModel
{
    SCHuikanPlayerViewController *player = [[SCHuikanPlayerViewController alloc] init];
    [player playLiveVideoWithLiveProgramModel:liveProgramModel];
    return player;
}

/** 由我的节目/点播飞屏拉屏单进入(点播) */
+ (instancetype)initPlayerWithFilmModel:(SCFilmModel *)filmModel{
    
    NSString *mtype;
    if (filmModel._Mtype) {
        
        mtype = filmModel._Mtype;
        
    }else if (filmModel.mtype){
        
        mtype = filmModel.mtype;
    }
    
    // 综艺 生活
    if ([mtype isEqualToString:@"7"] ||
        [mtype isEqualToString:@"9"])
    {
        SCHuikanPlayerViewController *player = [[SCHuikanPlayerViewController alloc] init];
        [player playArtAndLifeFilmWithFilmModel:filmModel];
        return player;
        
    }else {
        
        //电影 电视剧 少儿 少儿剧场 动漫 纪录片 游戏 专题  拉屏时因为没有mType信息，也会走此通道
        SCHuikanPlayerViewController *player = [[SCHuikanPlayerViewController alloc] init];
        [player playFilmWithFilmModel:filmModel];
        return player;
    }
    
}

/** 由回看搜索单进入(直播回看) */
+ (instancetype)initPlayerWithProgramModel:(SCLiveProgramModel *)programModel{
    SCHuikanPlayerViewController *player = [[SCHuikanPlayerViewController alloc] init];
    player.programModel = programModel;
    [player playFilmWithProgramModel:programModel];
    return player;
}

// 播放本地文件
+ (instancetype)initPlayerWithFilePath:(NSString *)filePath {
    
    SCHuikanPlayerViewController *player = [[SCHuikanPlayerViewController alloc] init];
    NSURL *filePathUrl = [NSURL fileURLWithPath:filePath];
    NSString *name = [[filePath componentsSeparatedByString:@"/"] lastObject];
    
    // 2.调用播放器播放
    player.IJKPlayerViewController = [IJKVideoPlayerVC initIJKPlayerWithURL:filePathUrl];
    [player.IJKPlayerViewController.player setScalingMode:IJKMPMovieScalingModeAspectFit];
    player.IJKPlayerViewController.view.frame = CGRectMake(0, 0, kMainScreenHeight, kMainScreenWidth);
    player.IJKPlayerViewController.mediaControl.frame = CGRectMake(0, 0, kMainScreenHeight, kMainScreenWidth);
    player.IJKPlayerViewController.mediaControl.fullScreenButton.hidden = YES;
    player.IJKPlayerViewController.isSinglePlayerView = YES;
    player.isProhibitRotate = YES;
    // 3.播放器返回按钮的回调 刷新本页是否支持旋转状态
    DONG_WeakSelf(player);
    player.IJKPlayerViewController.supportRotationBlock = ^(BOOL isProhibitRotate) {
        weakplayer.isProhibitRotate = isProhibitRotate;
    };
    
    //player.IJKPlayerViewController.mediaControl.programNameLabel.text = name;//节目名称
    player.IJKPlayerViewController.mediaControl.programNameRunLabel.titleName = name;//节目名称
    [player.view addSubview:player.IJKPlayerViewController.view];
    
    //进入全屏模式
    //    [UIView animateWithDuration:0.2 animations:^{
    //
    //        player.IJKPlayerViewController.view.transform = CGAffineTransformRotate(player.view.transform, M_PI_2);
    //        player.IJKPlayerViewController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    //        player.IJKPlayerViewController.mediaControl.frame = CGRectMake(0, 0, kMainScreenHeight, kMainScreenWidth);
    //        [player.view bringSubviewToFront:player.IJKPlayerViewController.view];
    //
    //    }];
    
    //3.播放器返回按钮的回调 刷新本页是否支持旋转状态
    //    DONG_WeakSelf(player);
    //    player.IJKPlayerViewController.supportRotationBlock = ^(BOOL isProhibitRotate) {
    //
    //        weakplayer.isProhibitRotate = isProhibitRotate;
    //        [weakplayer shouldAutorotate];
    //    };
    //
    //    //4.强制旋转进入全屏 旋转后使该控制器不支持旋转 达到锁定全屏的功能
    //    [PlayerViewRotate forceOrientation:UIInterfaceOrientationLandscapeRight];
    //    player.IJKPlayerViewController.isFullScreen = YES;
    //    player.isProhibitRotate = YES;
    //    [player shouldAutorotate];
    
    return player;
    
    
}


+ (instancetype)initPlayerWithPullInFilmModel:(SCFilmModel *)filmModel
{
    
    SCHuikanPlayerViewController *player = [[SCHuikanPlayerViewController alloc] init];
    [player playWithFilmModel:filmModel];
    return player;
    
    
    
}

#pragma mark -  ViewLife Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    [self registerNotification];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    //注销所有通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {
    NSLog(@"🔴%s 第%d行 \n",__func__, __LINE__);
}

#pragma mark - 屏幕旋转的监听
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
            //此方向为正常竖屏方向，当禁止旋转下设备旋转至此方向时，屏幕虽然不显示StatusBar，但会留出StatusBar位置，所以调整IJKPlayer的位置
            if (_isProhibitRotate) {
                self.view.frame = [[UIScreen mainScreen] bounds];
                _IJKPlayerViewController.view.frame = self.view.bounds;
                _IJKPlayerViewController.isFullScreen = YES;
                [_IJKPlayerViewController.player setScalingMode:IJKMPMovieScalingModeAspectFit];
                _IJKPlayerViewController.mediaControl.frame = self.view.bounds;
                _IJKPlayerViewController.mediaControl.fullScreenLockButton.hidden = YES;
                
            } else {
                
                [_IJKPlayerViewController.player setScalingMode:IJKMPMovieScalingModeAspectFit];
                _IJKPlayerViewController.view.frame = CGRectMake(0, 20, kMainScreenWidth, kMainScreenWidth * 9 / 16);
                _IJKPlayerViewController.mediaControl.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenWidth * 9 / 16);
                _IJKPlayerViewController.mediaControl.fullScreenLockButton.hidden = YES;
            }
            break;
        }
            
        case UIDeviceOrientationLandscapeLeft: {
            [_IJKPlayerViewController.player setScalingMode:IJKMPMovieScalingModeAspectFit];
            self.view.frame = [[UIScreen mainScreen] bounds];
            _IJKPlayerViewController.view.frame = self.view.bounds;
            _IJKPlayerViewController.mediaControl.fullScreenLockButton.hidden = YES;
            _IJKPlayerViewController.isFullScreen = YES;
            _IJKPlayerViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth & UIViewAutoresizingFlexibleHeight;
            _IJKPlayerViewController.mediaControl.frame = self.view.frame;
            [self.view bringSubviewToFront:_IJKPlayerViewController.view];
            break;
        }
            
        case UIDeviceOrientationPortraitUpsideDown: {
            _IJKPlayerViewController.mediaControl.fullScreenLockButton.hidden = YES;
            _IJKPlayerViewController.isFullScreen = YES;
            
        }
            
        case UIDeviceOrientationLandscapeRight: {
            [_IJKPlayerViewController.player setScalingMode:IJKMPMovieScalingModeAspectFit];
            self.view.frame = [[UIScreen mainScreen] bounds];
            _IJKPlayerViewController.view.frame = self.view.bounds;
            _IJKPlayerViewController.isFullScreen = YES;
            _IJKPlayerViewController.mediaControl.fullScreenLockButton.hidden = YES;
            _IJKPlayerViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth & UIViewAutoresizingFlexibleHeight;
            _IJKPlayerViewController.mediaControl.frame = self.view.frame;
            [self.view bringSubviewToFront:_IJKPlayerViewController.view];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - private method
// 播放电影 电视剧
- (void)playFilmWithFilmModel:(SCFilmModel *)filmModel{
    [CommonFunc showLoadingWithTips:@""];
    _filmModel = filmModel;
    
    NSString *mid;
    if (filmModel._Mid) {
        mid = filmModel._Mid;
    }else if (filmModel.mid){
        mid = filmModel.mid;
    }
    
    NSString *filmmidStr = mid ? mid : @"";
    
    NSDictionary *parameters = @{@"pagesize" : @"1000",
                                 @"filmmid" : filmmidStr};
    
    DONG_WeakSelf(self);
    //请求film详细信息
    self.hljRequest = [HLJRequest requestWithPlayVideoURL:FilmSourceUrl];
    [_hljRequest getNewVideoURLSuccess:^(NSString *newVideoUrl) {
        
        if (filmModel.filmSetModel) {// 电视剧 系列影片通道
            
            //睡一会以解决屏幕旋转时的bug
            [NSThread sleepForTimeInterval:.5f];
            
            //请求播放地址
            [requestDataManager requestDataWithUrl:filmModel.filmSetModel.VODStreamingUrl parameters:nil success:^(id  _Nullable responseObject) {
                DONG_StrongSelf(self);
                //                NSLog(@"====responseObject:::%@===",responseObject);
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
                [strongself.IJKPlayerViewController.player setScalingMode:IJKMPMovieScalingModeAspectFit];
                strongself.IJKPlayerViewController.view.frame = CGRectMake(0, 20, kMainScreenWidth, kMainScreenWidth * 9 / 16);
                strongself.IJKPlayerViewController.isSinglePlayerView = YES;
                strongself.IJKPlayerViewController.mediaControl.fullScreenButton.hidden = YES;
                strongself.IJKPlayerViewController.mediaControl.pushScreenButton.hidden = YES;
                strongself.IJKPlayerViewController.mediaControl.totalDurationLabelTrailingSpaceConstraint.constant = -60;
                [strongself.view addSubview:strongself.IJKPlayerViewController.view];
                
                //3.播放器返回按钮的回调 刷新本页是否支持旋转状态
                strongself.IJKPlayerViewController.supportRotationBlock = ^(BOOL isProhibitRotate) {
                    DONG_StrongSelf(self);
                    strongself.isProhibitRotate = isProhibitRotate;
                };
                
                //4.强制旋转进入全屏 旋转后使该控制器不支持旋转 达到锁定全屏的功能
                [PlayerViewRotate forceOrientation:UIInterfaceOrientationLandscapeRight];
                strongself.IJKPlayerViewController.isFullScreen = YES;
                strongself.isProhibitRotate = YES;
                
                // 名称
                NSString *filmName;
                if (filmModel.FilmName) {
                    filmName = [NSString stringWithFormat:@"%@ 第%@集",filmModel.FilmName,filmModel.filmSetModel._ContentIndex];
                }else if (filmModel.cnname){
                    filmName = [NSString stringWithFormat:@"%@ 第%@集",filmModel.cnname,filmModel.filmSetModel._ContentIndex];
                }
                
                //strongself.IJKPlayerViewController.mediaControl.programNameLabel.text = filmName;//节目名称
                strongself.IJKPlayerViewController.mediaControl.programNameRunLabel.titleName = filmName;//节目名称
                
                [CommonFunc dismiss];
                //[CommonFunc noDataOrNoNetTipsString:@"数据加载失败，右划返回上一级页面" addView:self.view];
                
            } failure:^(id  _Nullable errorObject) {
                [CommonFunc dismiss];
                //[CommonFunc noDataOrNoNetTipsString:@"数据加载失败，右划返回上一级页面" addView:self.view];
            }];
            
        }else{// 电影
            
            //拉屏时即使是电视剧，因为filmModel.filmSetModel为空，所以也会走此通道 可以根据filmModel.jiIndex做判断，若filmModel.jiIndex>1则按电视剧处理  综艺的jiIndex=1,又有自己的mid，都按单个影片处理
            
            [requestDataManager requestDataWithUrl:newVideoUrl parameters:parameters success:^(id  _Nullable responseObject) {
                //DONG_Log(@"====responseObject:::%@===",responseObject);
                DONG_StrongSelf(self);
                
                //睡一会以解决屏幕旋转时的bug
                [NSThread sleepForTimeInterval:.1f];
                
                
                    // 坑：：单片不同film竟然数据结构不同 服了！
                    //downloadUrl
                    NSString *downloadUrl;
                    if ([responseObject[@"ContentSet"][@"Content"] isKindOfClass:[NSDictionary class]]){
                        
                        downloadUrl = responseObject[@"ContentSet"][@"Content"][@"_DownUrl"];
                        
                    } else if ([responseObject[@"ContentSet"][@"Content"] isKindOfClass:[NSArray class]]) {
                        
                        NSArray *filmsArray = responseObject[@"ContentSet"][@"Content"];
                                                  
                        if (filmModel.jiIndex <= 1)
                        {//电影 综艺 电视剧第一集
                           downloadUrl = [filmsArray firstObject][@"_DownUrl"];
                        }
                        else
                        {//电视剧第二集以后
                            
                            if (filmModel.jiIndex-1 < filmsArray.count) {
                                
                                downloadUrl = [filmsArray objectAtIndex:(filmModel.jiIndex -1)][@"_DownUrl"];
            
                            }
                        }
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
                        [strongself.IJKPlayerViewController.player setScalingMode:IJKMPMovieScalingModeAspectFit];
                        strongself.IJKPlayerViewController.view.frame = CGRectMake(0, 20, kMainScreenWidth, kMainScreenWidth * 9 / 16);
                        strongself.IJKPlayerViewController.isSinglePlayerView = YES;
                        strongself.IJKPlayerViewController.mediaControl.fullScreenButton.hidden = YES;
                        strongself.IJKPlayerViewController.mediaControl.pushScreenButton.hidden = YES;
                        strongself.IJKPlayerViewController.mediaControl.totalDurationLabelTrailingSpaceConstraint.constant = -60;
                        [strongself.view addSubview:strongself.IJKPlayerViewController.view];
                        
                        //3.播放器返回按钮的回调 刷新本页是否支持旋转状态
                        strongself.IJKPlayerViewController.supportRotationBlock = ^(BOOL isProhibitRotate) {
                            DONG_StrongSelf(self);
                            strongself.isProhibitRotate = isProhibitRotate;
                        };
                        
                        //4.强制旋转进入全屏 旋转后使该控制器不支持旋转 达到锁定全屏的功能
                        strongself.IJKPlayerViewController.isFullScreen = YES;
                        [PlayerViewRotate forceOrientation:UIInterfaceOrientationLandscapeRight];
                        strongself.isProhibitRotate = YES;
                        
                        //同时旋转statusBar和navigation才能旋转彻底(使系统视图(音量图标)一起旋转) 但是返回时有问题😅😅😅😅转不回来了
                        //                    UIInterfaceOrientation orientation = UIInterfaceOrientationLandscapeRight;
                        //                    [[UIApplication sharedApplication] setStatusBarOrientation:orientation];
                        //                    //计算旋转角度
                        //                    float arch;
                        //                    if (orientation == UIInterfaceOrientationLandscapeLeft)  {
                        //                        arch = -M_PI_2;
                        //                    }  else if (orientation == UIInterfaceOrientationLandscapeRight) {
                        //                        arch = M_PI_2;
                        //                    } else {
                        //                        arch = 0;
                        //                    }
                        //
                        //                    [UIView animateWithDuration:0.2 animations:^{
                        //
                        //                    //对navigationController.view 进行强制旋转
                        //                    strongself.navigationController.view.transform = CGAffineTransformMakeRotation(arch);
                        //                    strongself.navigationController.view.bounds = UIInterfaceOrientationIsLandscape(orientation) ? CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight) : CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
                        //                    strongself.IJKPlayerViewController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
                        //                    strongself.IJKPlayerViewController.mediaControl.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
                        //
                        //                    }];
                        
                        
                        // 名称
                        NSString *filmName;
                        if (filmModel.FilmName) {
                            if (filmModel.jiIndex > 1) {
                                filmName = [NSString stringWithFormat:@"%@ 第%ld集",filmModel.FilmName, (long)filmModel.jiIndex];
                            } else {
                                filmName = filmModel.FilmName;
                            }
                            
                        }else if (filmModel.cnname){
                            if (filmModel.jiIndex > 1) {
                                filmName = [NSString stringWithFormat:@"%@ 第%ld集",filmModel.cnname, (long)filmModel.jiIndex];
                            } else {
                                filmName = filmModel.cnname;
                            }
                        }
                        
                        strongself.IJKPlayerViewController.mediaControl.programNameRunLabel.titleName = filmName;//节目名称
                        
                        [CommonFunc dismiss];
                        
                    } failure:^(id  _Nullable errorObject) {
                        [CommonFunc dismiss];
                        //[CommonFunc noDataOrNoNetTipsString:@"数据加载失败，右划返回上一级页面" addView:self.view];
                    }];
                    
                
            } failure:^(id  _Nullable errorObject) {
                [CommonFunc dismiss];
                //[CommonFunc noDataOrNoNetTipsString:@"数据加载失败，右划返回上一级页面" addView:self.view];
            }];
            
        }
        
    } failure:^(NSError *error) {
        [CommonFunc dismiss];
        //[CommonFunc noDataOrNoNetTipsString:@"数据加载失败，右划返回上一级页面" addView:self.view];
    }];
    
}

// 播放综艺
- (void)playArtAndLifeFilmWithFilmModel:(SCFilmModel *)filmModel
{
    NSString *filmMidStr = nil;
    if (filmModel._Mid) {
        filmMidStr = filmModel._Mid;
    }else if (filmModel.mid){
        filmMidStr = filmModel.mid;
    }
    
    //请求播放地址
    [CommonFunc showLoadingWithTips:@""];
    DONG_WeakSelf(self);
    //请求播放地址
    NSString *urlStr = [filmModel.SourceURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [requestDataManager requestDataWithUrl:urlStr parameters:nil success:^(id  _Nullable responseObject){
        NSString *downLoadUrl = responseObject[@"ContentSet"][@"Content"][@"_DownUrl"];
        //获取fid
        NSString *fidString = [[[[downLoadUrl componentsSeparatedByString:@"?"] lastObject] componentsSeparatedByString:@"&"] firstObject];
        //base64编码downloadUrl
        NSString *downloadBase64Url = [downLoadUrl stringByBase64Encoding];
        //视频播放url
        NSString *VODStreamingUrl = [[[[[[VODUrl stringByAppendingString:@"&mid="] stringByAppendingString:filmMidStr] stringByAppendingString:@"&"] stringByAppendingString:fidString] stringByAppendingString:@"&ext="] stringByAppendingString:downloadBase64Url];
        
        //2.请求播放地址
        [requestDataManager requestDataWithUrl:VODStreamingUrl parameters:nil success:^(id  _Nullable responseObject) {
            DONG_StrongSelf(self);
            //DONG_Log(@"====responseObject:::%@===",responseObject);
            NSString *play_url = responseObject[@"play_url"];
            
            //请求将播放地址域名转换  并拼接最终的播放地址
            [[HLJRequest requestWithPlayVideoURL:play_url] getNewVideoURLSuccess:^(NSString *newVideoUrl) {
                //1.拼接新地址
                NSString *playUrl = [NSString stringWithFormat:@"http://127.0.0.1:5656/play?url='%@'",newVideoUrl];
                strongself.url = [NSURL URLWithString:playUrl];
                //            strongself.url = [NSURL fileURLWithPath:@"/Users/yesdgq/Downloads/IMG_0839.MOV"];
                DONG_Log(@"====url:::%@===",strongself.url);
                
                //2.调用播放器播放
                strongself.IJKPlayerViewController = [IJKVideoPlayerVC initIJKPlayerWithURL:strongself.url];
                [strongself.IJKPlayerViewController.player setScalingMode:IJKMPMovieScalingModeAspectFit];
                strongself.IJKPlayerViewController.view.frame = CGRectMake(0, 20, kMainScreenWidth, kMainScreenWidth * 9 / 16);
                strongself.IJKPlayerViewController.isSinglePlayerView = YES;
                strongself.IJKPlayerViewController.mediaControl.fullScreenButton.hidden = YES;
                strongself.IJKPlayerViewController.mediaControl.pushScreenButton.hidden = YES;
                strongself.IJKPlayerViewController.mediaControl.totalDurationLabelTrailingSpaceConstraint.constant = -60;
                [strongself.view addSubview:strongself.IJKPlayerViewController.view];
                
                //3.播放器返回按钮的回调 刷新本页是否支持旋转状态
                strongself.IJKPlayerViewController.supportRotationBlock = ^(BOOL isProhibitRotate) {
                    DONG_StrongSelf(self);
                    strongself.isProhibitRotate = isProhibitRotate;
                };
                
                //4.强制旋转进入全屏 旋转后使该控制器不支持旋转 达到锁定全屏的功能
                [PlayerViewRotate forceOrientation:UIInterfaceOrientationLandscapeRight];
                strongself.IJKPlayerViewController.isFullScreen = YES;
                strongself.isProhibitRotate = YES;
                
                // 名称
                NSString *filmName;
                if (filmModel.FilmName) {
                    filmName = filmModel.FilmName;
                }else if (filmModel.cnname){
                    filmName = filmModel.cnname;
                }
                
                //strongself.IJKPlayerViewController.mediaControl.programNameLabel.text = filmName;//节目名称
                strongself.IJKPlayerViewController.mediaControl.programNameRunLabel.titleName = filmName;//节目名称
                
                [CommonFunc dismiss];
                //[CommonFunc noDataOrNoNetTipsString:@"数据加载失败，右划返回上一级页面" addView:self.view];
                
            } failure:^(NSError *error) {
                [CommonFunc dismiss];
                //[CommonFunc noDataOrNoNetTipsString:@"数据加载失败，右划返回上一级页面" addView:self.view];
            }];
            
        } failure:^(id  _Nullable errorObject) {
            [CommonFunc dismiss];
            //[CommonFunc noDataOrNoNetTipsString:@"数据加载失败，右划返回上一级页面" addView:self.view];
        }];
        
    } failure:^(id  _Nullable errorObject) {
        [CommonFunc dismiss];
        //[CommonFunc noDataOrNoNetTipsString:@"数据加载失败，右划返回上一级页面" addView:self.view];
    }];
    
}

// 播放搜索回看
- (void)playFilmWithProgramModel:(SCLiveProgramModel *)programModel{
    //获取时间戳字符串
    NSString *startTime = [NSString stringWithFormat:@"%lu", [NSDate timeStampFromString:programModel.forecastdate format:@"yyyy-MM-dd HH:mm:ss"]];
    NSString *endTime =  [NSString stringWithFormat:@"%lu", [NSDate timeStampFromString:programModel.endTime format:@"yyyy-MM-dd HH:mm:ss"]];
    
    NSString *extStr = [NSString stringWithFormat:@"stime=%@&etime=%@&port=5656&ext=oid:30050",startTime,endTime];
    NSString *ext = [extStr stringByBase64Encoding];
    NSString *fid = [NSString stringWithFormat:@"%@_%@",_programModel.tvid,_programModel.tvid];
    
    DONG_Log(@"startTime：%@ \n endTime:%@",startTime, endTime);
    
    DONG_Log(@"ext：%@ \nfid:%@",ext,fid);
    
    NSDictionary *parameters = @{@"fid" : fid,
                                 @"ext"  : ext };
    //IP替换
    [CommonFunc showLoadingWithTips:@""];
    DONG_WeakSelf(self);
    _hljRequest = [HLJRequest requestWithPlayVideoURL:ToGetProgramHavePastVideoSignalFlowUrl];
    [_hljRequest getNewVideoURLSuccess:^(NSString *newVideoUrl) {
        DONG_Log(@"newVideoUrl：%@ ",newVideoUrl);
        
        //睡一会以解决屏幕旋转时的bug
        [NSThread sleepForTimeInterval:.5f];
        
        [requestDataManager requestDataWithUrl:newVideoUrl parameters:parameters success:^(id  _Nullable responseObject) {
            //                     NSLog(@"====responseObject:::%@===",responseObject);
            DONG_StrongSelf(self);
            NSString *liveUrl = responseObject[@"play_url"];
            
            NSString *playUrl = [strongself.hljRequest getNewViedoURLByOriginVideoURL:liveUrl];
            
            DONG_Log(@"playUrl：%@ ",playUrl);
            //strongself.url = [NSURL fileURLWithPath:@"/Users/yesdgq/Downloads/IMG_0839.MOV"];
            strongself.url= [NSURL URLWithString:playUrl];
            
            //2.调用播放器播放
            strongself.IJKPlayerViewController = [IJKVideoPlayerVC initIJKPlayerWithURL:strongself.url];
            [strongself.IJKPlayerViewController.player setScalingMode:IJKMPMovieScalingModeAspectFit];
            strongself.IJKPlayerViewController.view.frame = CGRectMake(0, 20, kMainScreenWidth, kMainScreenWidth * 9 / 16);
            strongself.IJKPlayerViewController.isSinglePlayerView = YES;
            strongself.IJKPlayerViewController.mediaControl.fullScreenButton.hidden = YES;
            strongself.IJKPlayerViewController.mediaControl.pushScreenButton.hidden = YES;
            strongself.IJKPlayerViewController.mediaControl.totalDurationLabelTrailingSpaceConstraint.constant = -60;
            [strongself.view addSubview:strongself.IJKPlayerViewController.view];
            
            //3.播放器返回按钮的回调 刷新本页是否支持旋转状态
            strongself.IJKPlayerViewController.supportRotationBlock = ^(BOOL isProhibitRotate) {
                DONG_StrongSelf(self);
                strongself.isProhibitRotate = isProhibitRotate;
            };
            
            //4.强制旋转进入全屏 旋转后使该控制器不支持旋转 达到锁定全屏的功能
            [PlayerViewRotate forceOrientation:UIInterfaceOrientationLandscapeRight];
            strongself.IJKPlayerViewController.isFullScreen = YES;
            strongself.isProhibitRotate = YES;
            
            [CommonFunc dismiss];
        } failure:^(id  _Nullable errorObject) {
            [CommonFunc dismiss];
            
        }];
        
    } failure:^(NSError *error) {
        
        [CommonFunc dismiss];
    }];
}

/** 直播拉屏 */
- (void)playLiveVideoWithLiveProgramModel:(SCLiveProgramModel *)liveProgramModel
{
    
    // 3.请求播放地址url
    NSString *fidStr = [[liveProgramModel.tvid stringByAppendingString:@"_"] stringByAppendingString:liveProgramModel.tvid];
    //hid = 设备的mac地址
    
    NSDictionary *parameters = @{@"fid" : fidStr,
                                 @"hid" : @""};
    self.hljRequest = [HLJRequest requestWithPlayVideoURL:ToGetLiveVideoSignalFlowUrl];
    [_hljRequest getNewVideoURLSuccess:^(NSString *newVideoUrl) {
        
        [requestDataManager requestDataWithUrl:newVideoUrl parameters:parameters success:^(id  _Nullable responseObject) {
            NSLog(@"====responseObject:::%@===",responseObject);
            
            NSString *liveUrl = responseObject[@"play_url"];
            
            NSLog(@">>>>>>ToGetLiveVideoSignalFlowUrl>>>>>%@>>>>>>>",liveUrl);
        
            //睡一会以解决屏幕旋转时的bug
            [NSThread sleepForTimeInterval:.5f];
            // 5.开始播放直播
            self.url = [NSURL URLWithString:liveUrl];
            //2.调用播放器播放
            self.IJKPlayerViewController = [IJKVideoPlayerVC initIJKPlayerWithURL:self.url];
            [self.IJKPlayerViewController.player setScalingMode:IJKMPMovieScalingModeAspectFit];
            self.IJKPlayerViewController.view.frame = CGRectMake(0, 20, kMainScreenWidth, kMainScreenWidth * 9 / 16);
            self.IJKPlayerViewController.isSinglePlayerView = YES;
            self.IJKPlayerViewController.mediaControl.fullScreenButton.hidden = YES;
            self.IJKPlayerViewController.mediaControl.pushScreenButton.hidden = YES;
            self.IJKPlayerViewController.mediaControl.totalDurationLabelTrailingSpaceConstraint.constant = -60;
            [self.view addSubview:self.IJKPlayerViewController.view];
            
            [MBProgressHUD showError:fidStr];
            
            //3.播放器返回按钮的回调 刷新本页是否支持旋转状态
            DONG_WeakSelf(self);
            self.IJKPlayerViewController.supportRotationBlock = ^(BOOL isProhibitRotate) {
                DONG_StrongSelf(self);
                strongself.isProhibitRotate = isProhibitRotate;
            };
            
            //4.强制旋转进入全屏 旋转后使该控制器不支持旋转 达到锁定全屏的功能
            [PlayerViewRotate forceOrientation:UIInterfaceOrientationLandscapeRight];
            self.IJKPlayerViewController.isFullScreen = YES;
            self.isProhibitRotate = YES;

            
            [CommonFunc dismiss];
        } failure:^(id  _Nullable errorObject) {
            [CommonFunc dismiss];
            
        }];
    } failure:^(NSError *error) {
        
        [CommonFunc dismiss];
    }];
    
    
}

- (void)playWithFilmModel:(SCFilmModel *)filmModel {
    
    [CommonFunc showLoadingWithTips:@""];
    _filmModel = filmModel;
    
    NSString *mid;
    if (filmModel._Mid) {
        mid = filmModel._Mid;
    }else if (filmModel.mid){
        mid = filmModel.mid;
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
            
            //睡一会以解决屏幕旋转时的bug
            [NSThread sleepForTimeInterval:.1f];
            
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
                [strongself.IJKPlayerViewController.player setScalingMode:IJKMPMovieScalingModeAspectFit];
                strongself.IJKPlayerViewController.view.frame = CGRectMake(0, 20, kMainScreenWidth, kMainScreenWidth * 9 / 16);
                strongself.IJKPlayerViewController.isSinglePlayerView = YES;
                strongself.IJKPlayerViewController.mediaControl.fullScreenButton.hidden = YES;
                strongself.IJKPlayerViewController.mediaControl.pushScreenButton.hidden = YES;
                strongself.IJKPlayerViewController.mediaControl.totalDurationLabelTrailingSpaceConstraint.constant = -60;
                [strongself.view addSubview:strongself.IJKPlayerViewController.view];
                
                //3.播放器返回按钮的回调 刷新本页是否支持旋转状态
                strongself.IJKPlayerViewController.supportRotationBlock = ^(BOOL isProhibitRotate) {
                    DONG_StrongSelf(self);
                    strongself.isProhibitRotate = isProhibitRotate;
                };
                
                //4.强制旋转进入全屏 旋转后使该控制器不支持旋转 达到锁定全屏的功能
                strongself.IJKPlayerViewController.isFullScreen = YES;
                [PlayerViewRotate forceOrientation:UIInterfaceOrientationLandscapeRight];
                strongself.isProhibitRotate = YES;
                
                
                
                
                // 名称
                NSString *filmName;
                if (filmModel.FilmName) {
                    filmName = filmModel.FilmName;
                }else if (filmModel.cnname){
                    filmName = filmModel.cnname;
                }
                
                strongself.IJKPlayerViewController.mediaControl.programNameRunLabel.titleName = filmName;//节目名称
                
                [CommonFunc dismiss];
                
            } failure:^(id  _Nullable errorObject) {
                [CommonFunc dismiss];
                //[CommonFunc noDataOrNoNetTipsString:@"数据加载失败，右划返回上一级页面" addView:self.view];
            }];
            
        } failure:^(id  _Nullable errorObject) {
            [CommonFunc dismiss];
            //[CommonFunc noDataOrNoNetTipsString:@"数据加载失败，右划返回上一级页面" addView:self.view];
        }];
        
        
    } failure:^(NSError *error) {
        
        [CommonFunc dismiss];
    }];
    
    
    
    
}



- (void)registerNotification
{
    //1.监听屏幕旋转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    //2.第一次加载成功准备播放
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:nil];
}

#pragma mark - IJK完成加载即将播放的通知

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification
{
    NSLog(@"mediaIsPreparedToPlayDidChange\n");
    // 开始播放5秒后隐藏播放器控件
    [self performSelector:@selector(hideIJKPlayerMediaControlView) withObject:nil afterDelay:5.0];
    
    //在此通知里设置加载IJK时的起始播放时间
    //如果已经播放过，则从已播放时间开始播放
        if (_filmModel.currentPlayTime) {
            DONG_Log(@"currentPlayTime:%f", _filmModel.currentPlayTime);
            self.IJKPlayerViewController.player.currentPlaybackTime = _filmModel.currentPlayTime / 1000;
        } else if (_programModel.currentPlayTime) {
            self.IJKPlayerViewController.player.currentPlaybackTime = _programModel.currentPlayTime / 1000;
        }
    
    _filmModel.currentPlayTime = 0.0f;
    _programModel.currentPlayTime = 0.f;
}

- (void)hideIJKPlayerMediaControlView
{
    [_IJKPlayerViewController.mediaControl hide];
}

// 禁止旋转屏幕
- (BOOL)shouldAutorotate {
    DONG_Log(@"(self.isProhibitRotate:%d",self.isProhibitRotate);
    if (self.isProhibitRotate) {
        return NO;
    } else {
        return YES;
    }
}

- (void)setIsProhibitRotate:(BOOL)isProhibitRotate {
    _isProhibitRotate = isProhibitRotate;
    [self shouldAutorotate];
}

@end
