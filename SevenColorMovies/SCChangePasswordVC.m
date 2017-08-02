//
//  SCChangePasswordVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/8/2.
//  Copyright © 2017年 yesdgq. All rights reserved.
//  修改密码

#import "SCChangePasswordVC.h"

@interface SCChangePasswordVC ()

@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTF;


@end

@implementation SCChangePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.leftBBI.text = @"修改密码";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendVerificationCode:(id)sender
{
    
    
}

- (IBAction)submitChanges:(id)sender
{
    
    
}


@end
