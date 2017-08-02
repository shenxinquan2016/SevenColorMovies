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
    _passwordTF.keyboardType = UIKeyboardTypeEmailAddress;
    _confirmPasswordTF.keyboardType = UIKeyboardTypeEmailAddress;
    _verificationCodeTF.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 下发短信
- (IBAction)sendVerificationCode:(id)sender
{
    [self sendShortMsgNetworkRequest];
}

// 短信校验
- (IBAction)submitChanges:(id)sender
{
    [self verificationShortMsgNetworkRequest];
    
}

#pragma mark - Network Request

// 下发短信
- (void)sendShortMsgNetworkRequest
{
    NSDictionary *parameters = @{
                                 @"phoneNO" : UserInfoManager.mobilePhone? UserInfoManager.mobilePhone : @"",
                                 @"appID"   : @"1012",
                                 @"msg"     : @"尊敬的用户您好，用户升级验证码为：xxxx，有效期为5分钟, 客服热线96396。"
                                 };
    [CommonFunc showLoadingWithTips:@""];
    [requestDataManager postRequestJsonDataWithUrl:SendShortMsg parameters:parameters success:^(id  _Nullable responseObject) {
        DONG_Log(@"responseObject-->%@", responseObject);
        
        NSInteger resultCode = [responseObject[@"ResultMessage"] integerValue];
        if (resultCode == 0) {
            [MBProgressHUD showSuccess:@"发送成功！"];
        } else {
            [MBProgressHUD showSuccess:responseObject[@"ResultMessage"]];
        }
        
        [CommonFunc dismiss];
        
    } failure:^(id  _Nullable errorObject) {
        
        DONG_Log(@"errorObject-->%@", errorObject);
        [CommonFunc dismiss];
    }];
}

// 短信校验
- (void)verificationShortMsgNetworkRequest
{
    if (_passwordTF.text.length <= 0) {
        [MBProgressHUD showError:@"请输入新密码！"];
        return;
    }
    if (_confirmPasswordTF.text.length <= 0) {
        [MBProgressHUD showError:@"请输入确认密码！"];
        return;
    }
    if (_verificationCodeTF.text.length <= 0) {
        [MBProgressHUD showError:@"请输入验证码！"];
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"phoneNO" : @"",
                                 @"appID" : @"1012"
                                 };
    [CommonFunc showLoadingWithTips:@""];
    [requestDataManager postRequestJsonDataWithUrl:VerificaionShortMsg parameters:parameters success:^(id  _Nullable responseObject) {
        DONG_Log(@"responseObject-->%@", responseObject);
        
        NSInteger resultCode = [responseObject[@"ResultMessage"] integerValue];
        if (resultCode == 0) {
            
            if ([responseObject[@"ResultMessage"] isEqualToString:_verificationCodeTF.text]) {
                // 注册
                [self submitChangePasswordInfoNetworkRequest];
                
            } else {
                
                [MBProgressHUD showSuccess:@"输入的验证码错误!"];
                [CommonFunc dismiss];
            }
            
        } else {
            
            [MBProgressHUD showSuccess:responseObject[@"ResultMessage"]];
            [CommonFunc dismiss];
        }
        
    } failure:^(id  _Nullable errorObject) {
        DONG_Log(@"errorObject-->%@", errorObject);
        [CommonFunc dismiss];
        
    }];
}

- (void)submitChangePasswordInfoNetworkRequest
{
    NSDictionary *parameters = @{
                                 @"mobile"      : UserInfoManager.mobilePhone,
                                 @"password"    : _passwordTF.text
                                 };
    
    [requestDataManager postRequestJsonDataWithUrl:ChangePassword parameters:parameters success:^(id  _Nullable responseObject) {
        DONG_Log(@"responseObject-->%@", responseObject);
        
        NSInteger resultCode = [responseObject[@"ResultMessage"] integerValue];
        if (resultCode == 0) {
            
        } else {
            [MBProgressHUD showSuccess:responseObject[@"ResultMessage"]];
        }
        
        [CommonFunc dismiss];
        
    } failure:^(id  _Nullable errorObject) {
        
        DONG_Log(@"errorObject-->%@", errorObject);
        [CommonFunc dismiss];
    }];
}


@end
