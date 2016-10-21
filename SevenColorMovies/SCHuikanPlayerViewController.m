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
+ (instancetype)playFilmWithFilmModel:(SCFilmModel *)filmModel{
    SCHuikanPlayerViewController *player = [[SCHuikanPlayerViewController alloc] init];
    [player playFilmFromProgramList];
    return player;
}

//由回看搜索进入
+ (instancetype)playHUIKANProgramWithProgramModel:(SCLiveProgramModel *)programModel{
    SCHuikanPlayerViewController *player = [[SCHuikanPlayerViewController alloc] init];
    player.programModel = programModel;
    [player playHUIKANFromSearch];
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
- (void)playFilmFromProgramList{
    
    
}

- (void)playHUIKANFromSearch{
    //获取时间戳字符串
    NSString *startTime = [NSString stringWithFormat:@"%lu", [NSDate timeStampFromString:_programModel.forecastdate format:@"yyyy-MM-dd HH:mm:ss"]];
    NSString *endTime =  [NSString stringWithFormat:@"%lu", [NSDate timeStampFromString:_programModel.endtime format:@"yyyy-MM-dd HH:mm:ss"]];
    
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
