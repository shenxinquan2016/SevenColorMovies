//
//  SCNewsViewController.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/18.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCNewsViewController.h"

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// 禁止旋转屏幕
- (BOOL)shouldAutorotate{
    return NO;
}


@end
