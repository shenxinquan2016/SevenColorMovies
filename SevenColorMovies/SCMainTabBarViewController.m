//
//  SCMainTabBarViewController.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/18.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCMainTabBarViewController.h"
#import "SCHomePageViewController.h"
#import "SCDiscoveryViewController.h"
#import "SCNewsViewController.h"
#import "SCMineViewController.h"

@interface SCMainTabBarViewController ()<UITabBarControllerDelegate>

@property (nonatomic, strong) SCHomePageViewController *homeVC;
@property (nonatomic, strong) SCDiscoveryViewController *discoveryVC;
@property (nonatomic, strong) SCNewsViewController *newsVC;
@property (nonatomic, strong) SCMineViewController *mineVC;

@end

@implementation SCMainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //实例化
    _homeVC = DONG_INSTANT_VC_WITH_ID(@"HomePage", @"SCHomePageNavController");
    _discoveryVC = DONG_INSTANT_VC_WITH_ID(@"Discovery", @"SCDiscoveryNavController");
    _newsVC = DONG_INSTANT_VC_WITH_ID(@"News", @"SCNewsNavController");
    _mineVC = DONG_INSTANT_VC_WITH_ID(@"Mine", @"SCMineNavController");
    
     // tabBar item的图片在 Main.storyboard 中修改
//    self.tabBar.tintColor = [UIColor redColor];
    self.tabBar.backgroundColor = [UIColor whiteColor];
    [self.tabBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    self.viewControllers = @[_homeVC,_discoveryVC,_newsVC,_mineVC];
    
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
    if (item.tag == 0) {
        //1.添加统计
//        ALERT(@"首页");
    } else if (item.tag == 1) {
        //2.添加统计
//        ALERT(@"发现");

        
    } else if (item.tag == 2) {
        //3.添加统计
//        ALERT(@"新闻");

    } else if (item.tag == 3) {
        //4.添加统计
//        ALERT(@"我的");

    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}





@end
