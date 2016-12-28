//
//  SCNewsViewController.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/18.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCNewsViewController.h"
#import "Dong_NullDataView.h"
#import "SCHTMLViewController.h"

@interface SCNewsViewController ()

@end

@implementation SCNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [CommonFunc noDataOrNoNetTipsString:@"功能建设中..." addView:self.view];
//    [Dong_NullDataView addImage:[UIImage imageNamed:@"NoBanner"] text:@"HTML" view:self.view];
//    [Dong_NullDataView addTapAction:self action:@selector(jkdljlj) view:self.view];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://10.177.4.25/mobile/"]];
    // 取出当前的导航控制器
    DONG_MAIN_AFTER(0.5, UITabBarController *tabBarVC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                    tabBarVC.selectedIndex = 0;);
    
//    [self loadHtml5View];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadHtml5View
{
    SCHTMLViewController *htmlVC = [[SCHTMLViewController alloc] init];
    htmlVC.hidesBottomBarWhenPushed = YES;
    htmlVC.urlString = @"http://10.177.4.25/mobile/";
    [self.navigationController pushViewController:htmlVC animated:YES];
    
}

// 禁止旋转屏幕
- (BOOL)shouldAutorotate {
    return NO;
}


@end
