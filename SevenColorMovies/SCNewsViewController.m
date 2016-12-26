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
    [Dong_NullDataView addImage:[UIImage imageNamed:@"NoBanner"] text:@"HTML" view:self.view];
    [Dong_NullDataView addTapAction:self action:@selector(jkdljlj) view:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)jkdljlj {
    DONG_Log(@"测试");
    SCHTMLViewController *htmlVC = [[SCHTMLViewController alloc] init];
    htmlVC.hidesBottomBarWhenPushed = YES;
    htmlVC.urlString = @"www.qq.com";
    [self.navigationController pushViewController:htmlVC animated:YES];
}

// 禁止旋转屏幕
- (BOOL)shouldAutorotate {
    return NO;
}


@end
