//
//  SCLovelyBabyCenterVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/6/13.
//  Copyright © 2017年 yesdgq. All rights reserved.
//  萌娃中心

#import "SCLovelyBabyCenterVC.h"
#import "SCSearchBarView.h"


@interface SCLovelyBabyCenterVC () <UITextFieldDelegate>

/** 搜索 */
@property (nonatomic,strong) UIButton *searchBBI;
/** 搜索textField */
@property (nonatomic, strong) UITextField *searchTF;

@end

@implementation SCLovelyBabyCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.leftBBI.text = @"萌娃";
    // 2.添加搜索框
    [self addSearchBBI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark- private methods

- (void)addSearchBBI
{
    SCSearchBarView *searchView = [[SCSearchBarView alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    
    UIButton *btn = (UIButton *)searchView;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    UIBarButtonItem *rightNegativeSpacer = [[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                            target:nil action:nil];
    rightNegativeSpacer.width = -5;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:rightNegativeSpacer,item, nil];
    self.searchTF = searchView.searchTF;
    _searchTF.delegate = self;
    _searchTF.returnKeyType =  UIReturnKeySearch;
    _searchBBI = btn;
    
}

@end
