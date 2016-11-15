//
//  SCHuikanPlayerViewController.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/10/12.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  搜索-->回看 简介播放器

#import "SCHuikanPlayerViewController.h"
#import "IJKVideoPlayerVC.h"
#import "SCLiveProgramModel.h"
#import "SCFilmModel.h"

@interface SCHuikanPlayerViewController ()

@property (nonatomic, strong) SCLiveProgramModel *programModel;
@property (nonatomic, strong) SCFilmModel *filmModel;
@property (nonatomic, strong) IJKVideoPlayerVC *IJKPlayerViewController;/** 播放器控制器 */
@property (nonatomic, strong) HLJRequest *hljRequest;/** 域名替换工具 */
@property (nonatomic, strong) NSURL *url;

@end

@implementation SCHuikanPlayerViewController


#pragma mark - Initialize
// 由我的节目单进入
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
        //电影 电视剧 少儿 少儿剧场 动漫 纪录片 游戏 专题
        SCHuikanPlayerViewController *player = [[SCHuikanPlayerViewController alloc] init];
        [player playFilmWithFilmModel:filmModel];
        return player;
    }
    
}

//由回看搜索进入
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
    //2.调用播放器播放
    player.IJKPlayerViewController = [IJKVideoPlayerVC initIJKPlayerWithURL:filePathUrl];
    [player.IJKPlayerViewController.player setScalingMode:IJKMPMovieScalingModeAspectFit];
    player.IJKPlayerViewController.view.frame = CGRectMake(0, 20, kMainScreenWidth, kMainScreenWidth * 9 / 16);
    player.IJKPlayerViewController.mediaControl.fullScreenButton.hidden = YES;
    player.IJKPlayerViewController.mediaControl.programNameLabel.text = name;//节目名称
    [player.view addSubview:player.IJKPlayerViewController.view];
    
    //进入全屏模式
    [UIView animateWithDuration:0.2 animations:^{
        
        player.IJKPlayerViewController.view.transform = CGAffineTransformRotate(player.view.transform, M_PI_2);
        player.IJKPlayerViewController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        player.IJKPlayerViewController.mediaControl.frame = CGRectMake(0, 0, kMainScreenHeight, kMainScreenWidth);
        [player.view bringSubviewToFront:player.IJKPlayerViewController.view];
        
    }];

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
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc{
    NSLog(@"🔴%s 第%d行 \n",__func__, __LINE__);
}

#pragma mark - private method
// 播放电影 电视剧
- (void)playFilmWithFilmModel:(SCFilmModel *)filmModel{
    [CommonFunc showLoadingWithTips:@""];
    
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
            
            //请求播放地址
            [requestDataManager requestDataWithUrl:filmModel.filmSetModel.VODStreamingUrl parameters:nil success:^(id  _Nullable responseObject) {
                DONG_StrongSelf(self);
                //NSLog(@"====responseObject:::%@===",responseObject);
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
                strongself.IJKPlayerViewController.mediaControl.fullScreenButton.hidden = YES;
                [strongself.view addSubview:strongself.IJKPlayerViewController.view];
                
                //进入全屏模式
                [UIView animateWithDuration:0.2 animations:^{
                    
                    strongself.IJKPlayerViewController.view.transform = CGAffineTransformRotate(strongself.view.transform, M_PI_2);
                    strongself.IJKPlayerViewController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
                    strongself.IJKPlayerViewController.mediaControl.frame = CGRectMake(0, 0, kMainScreenHeight, kMainScreenWidth);
                    [strongself.view bringSubviewToFront:strongself.IJKPlayerViewController.view];
                    
                }];
                
                // 名称
                NSString *filmName;
                if (filmModel.FilmName) {
                    filmName = [NSString stringWithFormat:@"%@ 第%@集",filmModel.FilmName,filmModel.filmSetModel._ContentIndex];
                }else if (filmModel.cnname){
                    filmName = [NSString stringWithFormat:@"%@ 第%@集",filmModel.cnname,filmModel.filmSetModel._ContentIndex];
                }
                
                strongself.IJKPlayerViewController.mediaControl.programNameLabel.text = filmName;//节目名称
                
                [CommonFunc dismiss];
                
            } failure:^(id  _Nullable errorObject) {
                [CommonFunc dismiss];
            }];
            
        }else{// 电影
            
            [requestDataManager requestDataWithUrl:newVideoUrl parameters:parameters success:^(id  _Nullable responseObject) {
                //        DONG_Log(@"====responseObject:::%@===",responseObject);
                
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
                    strongself.IJKPlayerViewController.mediaControl.fullScreenButton.hidden = YES;
                    [strongself.view addSubview:strongself.IJKPlayerViewController.view];
                    
                    //进入全屏模式
                    [UIView animateWithDuration:0.2 animations:^{
                        
                        strongself.IJKPlayerViewController.view.transform = CGAffineTransformRotate(strongself.view.transform, M_PI_2);
                        strongself.IJKPlayerViewController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
                        strongself.IJKPlayerViewController.mediaControl.frame = CGRectMake(0, 0, kMainScreenHeight, kMainScreenWidth);
                        [strongself.view bringSubviewToFront:strongself.IJKPlayerViewController.view];
                        
                    }];
                    
                    // 名称
                    NSString *filmName;
                    if (filmModel.FilmName) {
                        filmName = filmModel.FilmName;
                    }else if (filmModel.cnname){
                        filmName = filmModel.cnname;
                    }
                    
                    strongself.IJKPlayerViewController.mediaControl.programNameLabel.text = filmName;//节目名称
                    
                    [CommonFunc dismiss];
                    
                } failure:^(id  _Nullable errorObject) {
                    [CommonFunc dismiss];
                }];
                
                
            } failure:^(id  _Nullable errorObject) {
                
                [CommonFunc dismiss];
            }];
            
        }
        
    } failure:^(NSError *error) {
        [CommonFunc dismiss];
        
    }];
    
}

// 播放综艺
- (void)playArtAndLifeFilmWithFilmModel:(SCFilmModel *)filmModel{
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
        NSString *VODStreamingUrl = [[[[[[VODUrl stringByAppendingString:@"&mid="] stringByAppendingString:filmModel._Mid] stringByAppendingString:@"&"] stringByAppendingString:fidString] stringByAppendingString:@"&ext="] stringByAppendingString:downloadBase64Url];
        
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
                strongself.IJKPlayerViewController.mediaControl.fullScreenButton.hidden = YES;
                [strongself.view addSubview:strongself.IJKPlayerViewController.view];
                
                //进入全屏模式
                [UIView animateWithDuration:0.2 animations:^{
                    
                    strongself.IJKPlayerViewController.view.transform = CGAffineTransformRotate(strongself.view.transform, M_PI_2);
                    strongself.IJKPlayerViewController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
                    strongself.IJKPlayerViewController.mediaControl.frame = CGRectMake(0, 0, kMainScreenHeight, kMainScreenWidth);
                    [strongself.view bringSubviewToFront:strongself.IJKPlayerViewController.view];
                    
                }];
                
                // 名称
                NSString *filmName;
                if (filmModel.FilmName) {
                    filmName = filmModel.FilmName;
                }else if (filmModel.cnname){
                    filmName = filmModel.cnname;
                }
                
                strongself.IJKPlayerViewController.mediaControl.programNameLabel.text = filmName;//节目名称
                
                [CommonFunc dismiss];
                
            } failure:^(NSError *error) {
                
                [CommonFunc dismiss];
                
            }];
            
        } failure:^(id  _Nullable errorObject) {
            
            [CommonFunc dismiss];
            
        }];
        
    } failure:^(id  _Nullable errorObject) {
        
        [CommonFunc dismiss];
    }];
    
}

// 播放搜索回看
- (void)playFilmWithProgramModel:(SCLiveProgramModel *)programModel{
    //获取时间戳字符串
    NSString *startTime = [NSString stringWithFormat:@"%lu", [NSDate timeStampFromString:programModel.forecastdate format:@"yyyy-MM-dd HH:mm:ss"]];
    NSString *endTime =  [NSString stringWithFormat:@"%lu", [NSDate timeStampFromString:programModel.endtime format:@"yyyy-MM-dd HH:mm:ss"]];
    
    NSString *extStr = [NSString stringWithFormat:@"stime=%@&etime=%@&port=5656&ext=oid:30050",startTime,endTime];
    NSString *ext = [extStr stringByBase64Encoding];
    NSString *fid = [NSString stringWithFormat:@"%@_%@",_programModel.tvid,_programModel.tvid];
    DONG_Log(@"ext：%@ \nfid:%@",ext,fid);
    
    NSDictionary *parameters = @{@"fid" : fid,
                                 @"ext"  : ext };
    //IP替换
    [CommonFunc showLoadingWithTips:@""];
    DONG_WeakSelf(self);
    _hljRequest = [HLJRequest requestWithPlayVideoURL:ToGetProgramHavePastVideoSignalFlowUrl];
    [_hljRequest getNewVideoURLSuccess:^(NSString *newVideoUrl) {
        DONG_Log(@"newVideoUrl：%@ ",newVideoUrl);
        
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
            strongself.IJKPlayerViewController.mediaControl.programNameLabel.text = strongself.programModel.program;
            strongself.IJKPlayerViewController.mediaControl.fullScreenButton.hidden = YES;
            [strongself.view addSubview:strongself.IJKPlayerViewController.view];
            
            //进入全屏模式
            [UIView animateWithDuration:0.2 animations:^{
                
                strongself.IJKPlayerViewController.view.transform = CGAffineTransformRotate(strongself.view.transform, M_PI_2);
                strongself.IJKPlayerViewController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
                strongself.IJKPlayerViewController.mediaControl.frame = CGRectMake(0, 0, kMainScreenHeight, kMainScreenWidth);
                [strongself.view bringSubviewToFront:strongself.IJKPlayerViewController.view];
                
            }];
            
            [CommonFunc dismiss];
        } failure:^(id  _Nullable errorObject) {
            [CommonFunc dismiss];
            
        }];
        
    } failure:^(NSError *error) {
        
        [CommonFunc dismiss];
    }];
    
}
// 禁止旋转屏幕
- (BOOL)shouldAutorotate{
    return NO;
}


@end
