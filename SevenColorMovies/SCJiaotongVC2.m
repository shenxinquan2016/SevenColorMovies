//
//  SCJiaotongVC2.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/3/12.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import "SCJiaotongVC2.h"
#import "SCSecondLevelVC.h"

@interface SCJiaotongVC2 ()

@end

@implementation SCJiaotongVC2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"便民服务";
    
    [self setupViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupViews
{
    // 抬头
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"交通违章2"]];
    imageView.frame = CGRectMake(0, 22, kMainScreenWidth, kMainScreenHeight-22);
    [self.view addSubview:imageView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 64, kMainScreenWidth-15, 53)];
    self.titleLabel.backgroundColor = [UIColor colorWithHex:@"#EEEFF4"];
    self.titleLabel.text = self.titleStr;
    [self.view addSubview:self.titleLabel];
    
    // 身份证号
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(90, kMainScreenHeight-537, kMainScreenWidth-100, 35)];
    textField.textColor = [UIColor colorWithHex:@"#414141"];
    textField.placeholder = @"请输入身份证号";
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.clearButtonMode = UITextFieldViewModeAlways;
    textField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textField];
    
    // 处罚
    UITextField *textField2 = [[UITextField alloc] initWithFrame:CGRectMake(130, kMainScreenHeight-450, kMainScreenWidth-140, 35)];
    textField2.textColor = [UIColor colorWithHex:@"#414141"];
    textField2.placeholder = @"请输入身份证号";
    textField2.keyboardType = UIKeyboardTypeNumberPad;
    textField2.clearButtonMode = UITextFieldViewModeAlways;
    textField2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textField2];
    
    // 下一步
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, kMainScreenHeight-400, kMainScreenWidth-20, 45)];
    btn.backgroundColor = [UIColor colorWithHex:@"#1F90E6"];
    [btn setTitle:@"下一步" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goNextVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}


- (void)goNextVC
{
    DONG_Log(@"下一步");
    SCSecondLevelVC *thirdLevel  = [[SCSecondLevelVC alloc] initWithWithTitle:self._title];
    [self.navigationController pushViewController:thirdLevel animated:YES];
    
}

// 禁止旋转屏幕
- (BOOL)shouldAutorotate {
    return NO;
}

@end
