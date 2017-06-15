//
//  SCBaseViewController.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/20.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  商户商标和搜索基类

#import "SCBaseViewController.h"
#import "SCSearchBarView.h"
#import "SCSearchViewController.h"
#import "SCPlayerViewController.h"

@interface SCBaseViewController ()

@end

@implementation SCBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.添加商户商标
    [self addLeftBBI];
    // 2.添加搜索框
    [self addSearchBBI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark- private methods

- (void)addLeftBBI
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 105, 27);
    [btn setBackgroundImage:[UIImage imageNamed:@"BusinessLogo"] forState:UIControlStateNormal];
//    btn.backgroundColor = [UIColor redColor];
    btn.userInteractionEnabled = NO;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    UIBarButtonItem *leftNegativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
    leftNegativeSpacer.width = -5;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:leftNegativeSpacer,item, nil];
    
    _leftBBI = btn;
}

- (void)addSearchBBI
{
    SCSearchBarView *searchView = [[SCSearchBarView alloc] initWithFrame:CGRectMake(0, 0, 190, 29)];
    searchView.searchTF.userInteractionEnabled = NO;
    UITapGestureRecognizer *searchTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSearchBtn)];
    [searchView addGestureRecognizer:searchTap];
    
    UIButton *btn = (UIButton *)searchView;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    UIBarButtonItem *rightNegativeSpacer = [[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                            target:nil action:nil];
    rightNegativeSpacer.width = -4;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:rightNegativeSpacer,item, nil];
    _SearchBBI = btn;
    
    
    
}

- (void)clickSearchBtn
{
    SCSearchViewController *searchVC = [[SCSearchViewController alloc] initWithWithTitle:@"搜索"];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}

@end
