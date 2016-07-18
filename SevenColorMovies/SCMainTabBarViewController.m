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

@interface SCMainTabBarViewController ()

@property (nonatomic, strong) SCHomePageViewController *homeVC;
@property (nonatomic, strong) SCDiscoveryViewController *discoveryVC;
@property (nonatomic, strong) SCNewsViewController *newsVC;
@property (nonatomic, strong) SCMineViewController *mineVC;

@end

@implementation SCMainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //实例化
    _homeVC = DD_INSTANT_VC_WITH_ID(@"HomePage", @"SCHomePageNavController");
    _discoveryVC = DD_INSTANT_VC_WITH_ID(@"Discovery", @"SCDiscoveryNavController");
    _newsVC = DD_INSTANT_VC_WITH_ID(@"News", @"SCNewsNavController");
    _mineVC = DD_INSTANT_VC_WITH_ID(@"Mine", @"SCMineNavController");
    
     // tabBar item的图片在 Main.storyboard 中修改
    self.tabBar.tintColor = [UIColor redColor];
    self.tabBar.backgroundColor = [UIColor whiteColor];
//    self.tabBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    self.viewControllers = @[_homeVC,_discoveryVC,_newsVC,_mineVC];
    
    
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}





@end
