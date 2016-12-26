//
//  SCNewsViewController.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/18.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCNewsViewController.h"
#import "Dong_NullDataView.h"


@interface SCNewsViewController ()

@end

@implementation SCNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [CommonFunc noDataOrNoNetTipsString:@"功能建设中..." addView:self.view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// 禁止旋转屏幕
- (BOOL)shouldAutorotate {
    return NO;
}


@end
