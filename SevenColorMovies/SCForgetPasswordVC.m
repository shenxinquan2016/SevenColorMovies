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
    
    self.leftBBI.text = @"忘记密码";
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
    [self sendShortMsgNetworkRequest];
}


- (IBAction)submitInfo:(id)sender
{
    [self verificationShortMsgNetworkRequest];
}

#pragma mark - Network Request

// 下发短信
- (void)sendShortMsgNetworkRequest
{
    if (_mobilePhoneTF.text.length <= 0) {
        [MBProgressHUD showError:@"请输入手机号！"];
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"phoneNO" : _mobilePhoneTF.text,
                                 @"appID"   : @"1012",
                                 @"msg"     : @"尊敬的用户您好，修改密码验证码为：xxxx，有效期为5分钟, 客服热线96396。"
                                 };
    [CommonFunc showLoadingWithTips:@""];
    [requestDataManager requestDataByPostWithUrlString:SendShortMsg parameters:parameters success:^(id  _Nullable responseObject) {
        DONG_Log(@"responseObject-->%@", responseObject);
        
        NSInteger resultCode = [responseObject[@"ResultCode"] integerValue];
        
        if (resultCode == 1) {
            [MBProgressHUD showSuccess:@"验证码发送成功！"];
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
    if (_mobilePhoneTF.text.length <= 0) {
        [MBProgressHUD showError:@"请输入手机号！"];
        return;
    }
    if (_password.text.length <= 0) {
        [MBProgressHUD showError:@"请输入新密码！"];
        return;
    }
    if (_confirmPasswordTF.text.length <= 0) {
        [MBProgressHUD showError:@"请输入确认密码！"];
        return;
    }
    if (![_password.text isEqualToString:_confirmPasswordTF.text]) {
        [MBProgressHUD showSuccess:@"两次输入的密码不一致！"];
        return;
    }
    if (_verificationCode.text.length <= 0) {
        [MBProgressHUD showError:@"请输入验证码！"];
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"phoneNO" : _mobilePhoneTF.text,
                                 @"appID" : @"1012"
                                 };
    
    [CommonFunc showLoadingWithTips:@""];
    [requestDataManager requestDataByPostWithUrlString:VerificaionShortMsg parameters:parameters success:^(id  _Nullable responseObject) {
        DONG_Log(@"responseObject-->%@", responseObject);
        
        NSInteger resultCode = [responseObject[@"ResultCode"] integerValue];
        
        if (resultCode == 0) {
            
            if ([responseObject[@"ResultMessage"] isEqualToString:_verificationCode.text]) {
                // 修改密码
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

// 修改密码
- (void)submitChangePasswordInfoNetworkRequest
{
    NSDictionary *parameters = @{
                                 @"phoneNO" : _mobilePhoneTF.text,
                                 @"appID" : @""
                                 };
    
    [CommonFunc showLoadingWithTips:@""];
    [requestDataManager requestDataByPostWithUrlString:ChangePassword parameters:parameters success:^(id  _Nullable responseObject) {
        DONG_Log(@"responseObject-->%@", responseObject);
        NSInteger resultCode = [responseObject[@"ResultCode"] integerValue];
        
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
