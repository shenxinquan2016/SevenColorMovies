//
//  SCSearchViewController.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/20.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCSearchViewController.h"
#import "SCSearchBarView.h"

@interface SCSearchViewController ()

@end

@implementation SCSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //1.返回按钮
    [self addLeftBBI];
    //添加搜索框
    [self addSearchBBI];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark- private methods
- (void)addSearchBBI {
    SCSearchBarView *searchView = [[SCSearchBarView alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    
    UIButton *btn = (UIButton *)searchView;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    UIBarButtonItem *rightNegativeSpacer = [[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                            target:nil action:nil];
    rightNegativeSpacer.width = -5;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:rightNegativeSpacer,item, nil];
    _searchBBI = btn;
    
}
- (void)addLeftBBI {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 60, 22);
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [btn setImage:[UIImage imageNamed:@"Back_Arrow"] forState:UIControlStateNormal];
    [btn setTitle: @"搜索" forState: UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize: 19.0];
    [btn setTitleColor:[UIColor colorWithHex:@"#878889"]forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftNegativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
    leftNegativeSpacer.width = -6;
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:leftNegativeSpacer,item, nil];
    _leftBBI = btn;
    
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
