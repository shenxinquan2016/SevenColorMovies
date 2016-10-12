//
//  SCHuikanPlayerViewController.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/10/12.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCHuikanPlayerViewController.h"
#import "IJKVideoPlayerVC.h"

@interface SCHuikanPlayerViewController ()

@property (nonatomic, strong) IJKVideoPlayerVC *IJKPlayerViewController;/** 播放器控制器 */
@property (nonatomic, strong) HLJRequest *hljRequest;/** 域名替换工具 */
@property (nonatomic, strong) NSURL *url;

@end

@implementation SCHuikanPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //1.拼接新地址
    //    NSString *playUrl = [NSString stringWithFormat:@"http://127.0.0.1:5656/play?url='%@'",newVideoUrl];
    //    self.url = [NSURL URLWithString:playUrl];
    self.url = [NSURL fileURLWithPath:@"/Users/yesdgq/Downloads/IMG_0839.MOV"];
    
    //2.调用播放器播放
    self.IJKPlayerViewController = [IJKVideoPlayerVC initIJKPlayerWithURL:self.url];
    [_IJKPlayerViewController.player setScalingMode:IJKMPMovieScalingModeAspectFit];
    _IJKPlayerViewController.view.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenWidth * 9 / 16);
    [self.view addSubview:_IJKPlayerViewController.view];
    
    [_IJKPlayerViewController.player setScalingMode:IJKMPMovieScalingModeAspectFit];
   // [self setNeedsStatusBarAppearanceUpdate];
    
    //进入全屏模式
    [UIView animateWithDuration:0.2 animations:^{
        
        _IJKPlayerViewController.view.transform = CGAffineTransformRotate(self.view.transform, M_PI_2);
        _IJKPlayerViewController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        _IJKPlayerViewController.mediaControl.frame = CGRectMake(0, 0, kMainScreenHeight, kMainScreenWidth);
        [self.view bringSubviewToFront:_IJKPlayerViewController.view];
        
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    NSLog(@"🔴%s 第%d行 \n",__func__, __LINE__);
    [self.navigationController setNavigationBarHidden:NO animated:NO];

}

- (BOOL)prefersStatusBarHidden{
    return YES;//隐藏状态栏
}

// 禁止旋转屏幕
- (BOOL)shouldAutorotate{
    return NO;
}


@end
