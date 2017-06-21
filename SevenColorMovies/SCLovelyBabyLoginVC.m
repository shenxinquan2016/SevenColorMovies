//
//  SCLovelyBabyLoginVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/6/21.
//  Copyright © 2017年 yesdgq. All rights reserved.
//  萌娃登录

#import "SCLovelyBabyLoginVC.h"
#import "SCLovelyBabyRegisterVC.h"

@interface SCLovelyBabyLoginVC ()

@end

@implementation SCLovelyBabyLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)gobackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)loginClick:(id)sender
{
    
}

- (IBAction)registerAction:(id)sender
{
    SCLovelyBabyRegisterVC *registerVC = DONG_INSTANT_VC_WITH_ID(@"LovelyBaby", @"SCLovelyBabyRegisterVC");
    [self.navigationController pushViewController:registerVC animated:YES];
}

@end
