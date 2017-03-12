//
//  SCSecondLevelVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/3/12.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import "SCSecondLevelVC.h"
#import "SCThirdLevelVC.h"
#import "SCFourthViewController.h"

@interface SCSecondLevelVC ()

@end

@implementation SCSecondLevelVC

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
    if ([self._title isEqualToString:@"水费"]) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"水1"]];
        imageView.frame = CGRectMake(0, 22, kMainScreenWidth, kMainScreenHeight-22);
        [self.view addSubview:imageView];
        
        // 文本框
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, kMainScreenHeight-530, kMainScreenWidth-20, 50)];
        textField.textColor = [UIColor colorWithHex:@"#414141"];
        textField.placeholder = @" 请输入购水金额";
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
        
    } else if ([self._title isEqualToString:@"电费"]) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"电费1"]];
        imageView.frame = CGRectMake(0, 22, kMainScreenWidth, kMainScreenHeight-22);
        [self.view addSubview:imageView];
        
        // 文本框
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, kMainScreenHeight-530, kMainScreenWidth-20, 50)];
        textField.textColor = [UIColor colorWithHex:@"#414141"];
        textField.placeholder = @" 请输入购电金额";
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

        
    } else if ([self._title isEqualToString:@"燃气费"]) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"燃气费1"]];
        imageView.frame = CGRectMake(0, 22, kMainScreenWidth, kMainScreenHeight-22);
        [self.view addSubview:imageView];
        
        // 文本框
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, kMainScreenHeight-530, kMainScreenWidth-20, 50)];
        textField.textColor = [UIColor colorWithHex:@"#414141"];
        textField.placeholder = @" 请输入购燃气费金额";
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

    } else if ([self._title isEqualToString:@"有线电视"]) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"有线电视1"]];
        imageView.frame = CGRectMake(0, 22, kMainScreenWidth, kMainScreenHeight-22);
        [self.view addSubview:imageView];
        
        // 文本框
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(90, kMainScreenHeight-408, kMainScreenWidth-100, 40)];
        textField.textColor = [UIColor colorWithHex:@"#414141"];
        textField.backgroundColor = [UIColor whiteColor];
        textField.placeholder = @" 请输入智能卡号";
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
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"固话宽带1"]];
        imageView.frame = CGRectMake(0, 22, kMainScreenWidth, kMainScreenHeight-22);
        [self.view addSubview:imageView];
        
        // 文本框
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(90, kMainScreenHeight-408, kMainScreenWidth-100, 40)];
        textField.textColor = [UIColor colorWithHex:@"#414141"];
        textField.backgroundColor = [UIColor whiteColor];
        textField.placeholder = @" 请输入固话号码";
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
  
        
    } else if ([self._title isEqualToString:@"物业费"]) {
        
    } else if ([self._title isEqualToString:@"交通违章"]) {
        
    }
   
    
}

- (void)goNextVC
{
    DONG_Log(@"下一步");
    if ([self._title isEqualToString:@"有线电视"]) {
        
        SCFourthViewController *fourthLevel = [[SCFourthViewController alloc] initWithWithTitle:self._title];
        [self.navigationController pushViewController:fourthLevel animated:YES];
        
    } else  if ([self._title isEqualToString:@"固话宽带"]) {
        
        SCFourthViewController *fourthLevel = [[SCFourthViewController alloc] initWithWithTitle:self._title];
        [self.navigationController pushViewController:fourthLevel animated:YES];
        
    }
    
    else {
        
        SCThirdLevelVC *thirdLevel  = [[SCThirdLevelVC alloc] initWithWithTitle:self._title];
        [self.navigationController pushViewController:thirdLevel animated:YES];
        
    }
    
}

@end
