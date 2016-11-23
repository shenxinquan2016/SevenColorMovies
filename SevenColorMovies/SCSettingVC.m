//
//  SCSettingVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/11/23.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCSettingVC.h"

@interface SCSettingVC ()

@end

@implementation SCSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [CommonFunc noDataOrNoNetTipsString:@"功能建设中..." addView:self.view];}

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

@end
