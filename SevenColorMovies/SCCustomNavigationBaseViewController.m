//
//  SCCustomNavigationBaseViewController.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/6/15.
//  Copyright © 2017年 yesdgq. All rights reserved.
//  自定义导航栏的Base VC

#import "SCCustomNavigationBaseViewController.h"

@interface SCCustomNavigationBaseViewController ()

/** 返回标题 */
@property (nonatomic, copy) NSString *_title;

@end

@implementation SCCustomNavigationBaseViewController


#pragma mark- Initialize

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHex:@"#dddddd"];
    [self setupNavigationBar];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)setupNavigationBar
{
    // 导航栏
    UIView *navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 64)];
    navBar.backgroundColor = [UIColor colorWithHex:@"#F1F1F1"];
    _navBar = navBar;
    
    // 返回点击区域
    UIView *leftBarItemView = [[UIView alloc] initWithFrame:CGRectMake(10, 25, 150, 32)];
//        leftBarItemView.backgroundColor = [UIColor redColor];
    // 返回箭头
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Back_Arrow"]];
    [leftBarItemView addSubview:imgView];
    //    imgView.backgroundColor = [UIColor grayColor];
    [imgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftBarItemView);
        make.centerY.equalTo(leftBarItemView);
        make.size.mas_equalTo(imgView.image.size);
        
    }];
    // 返回标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 125, 22)];
    //    titleLabel.backgroundColor = [UIColor greenColor];
    titleLabel.text = __title;
    titleLabel.textColor = [UIColor colorWithHex:@"#878889"];
    titleLabel.font = [UIFont systemFontOfSize: 19.0];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    _leftBBI = titleLabel;
    [leftBarItemView addSubview:titleLabel];
    [titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(leftBarItemView);
        make.left.equalTo(imgView.mas_right).offset(0);
        make.size.mas_equalTo(CGSizeMake(125, 22));
        
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    [leftBarItemView addGestureRecognizer:tap];
    
    [navBar addSubview:leftBarItemView];
    [self.view addSubview:navBar];
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
