//
//  SCLovelyBabyCenterVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/6/15.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import "SCLovelyBabyCenterVC.h"
#import "SCSearchBarView.h"

@interface SCLovelyBabyCenterVC ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *searchHeaderView;
/** 搜索textField */
@property (nonatomic, strong) UITextField *searchTF;

@end

@implementation SCLovelyBabyCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.leftBBI.text = @"萌娃";
    // 添加搜索框
    [self addSearchBBI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _searchHeaderView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - 搜索框

- (void)addSearchBBI
{
    SCSearchBarView *searchView = [[SCSearchBarView alloc] initWithFrame:CGRectMake(0, 0, 190, 29)];
    searchView.searchTF.userInteractionEnabled = NO;
    searchView.searchTF.placeholder = @"请输入要搜索的人名";
    UITapGestureRecognizer *searchTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSearchBtn)];
    [searchView addGestureRecognizer:searchTap];
    
    UIButton *btn = (UIButton *)searchView;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    UIBarButtonItem *rightNegativeSpacer = [[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                            target:nil action:nil];
    rightNegativeSpacer.width = -4;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:rightNegativeSpacer,item, nil];

    _searchHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 44)];
    _searchHeaderView.backgroundColor = [UIColor colorWithHex:@"#F1F1F1"];
    [self.navigationController.navigationBar addSubview:_searchHeaderView];
    
    SCSearchBarView *searchView2 = [[SCSearchBarView alloc] initWithFrame:CGRectMake(20, 7, kMainScreenWidth-80, 29)];
    searchView2.searchTF.placeholder = @"请输入要搜索的人名";
    self.searchTF = searchView2.searchTF;
    _searchTF.delegate = self;
    _searchTF.returnKeyType =  UIReturnKeySearch;
    [_searchHeaderView addSubview:searchView2];
    
    UIButton *button = [[UIButton alloc] init];
    [button setTitleColor:[UIColor colorWithHex:@"#6798FC"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickBotton) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [_searchHeaderView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 30));
        make.right.equalTo(_searchHeaderView).offset(0);
        make.centerY.equalTo(_searchHeaderView.mas_centerY);
    }];
    
    _searchHeaderView.hidden = YES;
}

- (void)clickSearchBtn
{
    [self.navigationController.navigationBar bringSubviewToFront:_searchHeaderView];
    [_searchTF becomeFirstResponder];
    _searchHeaderView.hidden = NO;
}

- (void)clickBotton
{
    [_searchTF resignFirstResponder];
    _searchHeaderView.hidden = YES;
}

@end
