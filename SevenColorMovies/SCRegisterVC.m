//
//  SCRegisterVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/7/31.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import "SCRegisterVC.h"

@interface SCRegisterVC ()

@property (weak, nonatomic) IBOutlet UITextField *mobilePhoneTF;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *caNoTF; // 智能卡号
@property (weak, nonatomic) IBOutlet UITextField *documentNoTF; // 证件号码

@end

@implementation SCRegisterVC

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.leftBBI.text = @"注册";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 下发短验
- (IBAction)sendShortMessage:(id)sender
{
    
    
}

// 注册
- (IBAction)submitRegistration:(id)sender
{
    
}

@end
