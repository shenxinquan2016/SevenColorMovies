//
//  SCLivePlayerVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/24.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  直播播放页控制器

#import "SCLivePlayerVC.h"
#import "IJKVideoPlayerVC.h"

@interface SCLivePlayerVC ()

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
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}









@end
