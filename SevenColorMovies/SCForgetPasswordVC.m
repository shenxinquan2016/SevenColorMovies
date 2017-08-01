//
//  SCForgetPasswordVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/7/31.
//  Copyright © 2017年 yesdgq. All rights reserved.
//  忘记密码页

#import "SCForgetPasswordVC.h"

@interface SCForgetPasswordVC ()

@property (weak, nonatomic) IBOutlet UITextField *mobilePhoneTF;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *verificationCode;

@end

@implementation SCForgetPasswordVC

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configKeyboardType];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)configKeyboardType
{
    _mobilePhoneTF.keyboardType = UIKeyboardTypePhonePad;
    _password.keyboardType = UIKeyboardTypeEmailAddress;
    _confirmPasswordTF.keyboardType = UIKeyboardTypeEmailAddress;
    _verificationCode.keyboardType = UIKeyboardTypeNumberPad;
 
}

// 下发短验
- (IBAction)sendShortMessage:(id)sender
{
    
    
}


- (IBAction)submitInfo:(id)sender
{
    
    
}

@end
