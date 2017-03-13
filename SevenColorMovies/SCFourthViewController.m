//
//  SCFourthViewController.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/3/12.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import "SCFourthViewController.h"
#import "SCThirdLevelVC.h"

@interface SCFourthViewController ()

@end

@implementation SCFourthViewController

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
    if ([self._title isEqualToString:@"有线电视"]) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"有线电视2"]];
        imageView.frame = CGRectMake(0, 22, kMainScreenWidth, kMainScreenHeight-22);
        [self.view addSubview:imageView];
        
        // 文本框
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, kMainScreenHeight-530, kMainScreenWidth-20, 50)];
        textField.textColor = [UIColor colorWithHex:@"#414141"];
        textField.placeholder = @" 请输入缴费金额";
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.clearButtonMode = UITextFieldViewModeAlways;
        textField.layer.borderWidth = 1.5;
        textField.layer.borderColor = [UIColor colorWithHex:@"#E5E5E5"].CGColor;
        [self.view addSubview:textField];
        
        // 下一步
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, kMainScreenHeight-280, kMainScreenWidth-20, 45)];
        btn.backgroundColor = [UIColor colorWithHex:@"#1F90E6"];
        [btn setTitle:@"下一步" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(goNextVC) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        
    } else if ([self._title isEqualToString:@"固话宽带"]) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"固话宽带2"]];
        imageView.frame = CGRectMake(0, 22, kMainScreenWidth, kMainScreenHeight-22);
        [self.view addSubview:imageView];
        
        // 文本框
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, kMainScreenHeight-530, kMainScreenWidth-20, 50)];
        textField.backgroundColor = [UIColor whiteColor];
        textField.textColor = [UIColor colorWithHex:@"#414141"];
        textField.placeholder = @" 请输入缴费金额";
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.clearButtonMode = UITextFieldViewModeAlways;
        textField.layer.borderWidth = 1.5;
        textField.layer.borderColor = [UIColor colorWithHex:@"#E5E5E5"].CGColor;
        [self.view addSubview:textField];
        
        // 下一步
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, kMainScreenHeight-280, kMainScreenWidth-20, 45)];
        btn.backgroundColor = [UIColor colorWithHex:@"#1F90E6"];
        [btn setTitle:@"下一步" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(goNextVC) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        
    }  else if ([self._title isEqualToString:@"交通违章"]) {
        
        
    }
}

- (void)goNextVC
{
    DONG_Log(@"下一步");
    SCThirdLevelVC *thirdLevel  = [[SCThirdLevelVC alloc] initWithWithTitle:self._title];
    
    [self.navigationController pushViewController:thirdLevel animated:YES];
}

// 禁止旋转屏幕
- (BOOL)shouldAutorotate {
    return NO;
}

@end
