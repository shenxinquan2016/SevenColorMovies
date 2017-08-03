//
//  SCChangeBindVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/8/2.
//  Copyright © 2017年 yesdgq. All rights reserved.
//  修改绑定控制器

#import "SCChangeBindVC.h"

@interface SCChangeBindVC ()

@property (weak, nonatomic) IBOutlet UITextField *caCardNoTF;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTF;

@end

@implementation SCChangeBindVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.leftBBI.text = @"绑定变更";
    _caCardNoTF.keyboardType = UIKeyboardTypeNumberPad;
    _verificationCodeTF.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

// 下发验证码
- (IBAction)sendVerificationCode:(id)sender
{
    [self sendShortMsgNetworkRequest];
}

// 提交修改
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
                                 @"msg"     : @"尊敬的用户您好，绑定变更验证码为：xxxx，有效期为5分钟, 客服热线96396。"
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
    if (_caCardNoTF.text.length <= 0) {
        [MBProgressHUD showError:@"请输入新绑定的智能卡号！"];
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
    [requestDataManager requestDataByPostWithUrlString:VerificaionShortMsg parameters:parameters success:^(id  _Nullable responseObject) {
        DONG_Log(@"responseObject-->%@", responseObject);
        
        NSInteger resultCode = [responseObject[@"ResultCode"] integerValue];
        if (resultCode == 0) {
            
            if ([responseObject[@"ResultMessage"] isEqualToString:_verificationCodeTF.text]) {
                // 注册
                [self submitChangeBindInfoNetworkRequest];
                
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

- (void)submitChangeBindInfoNetworkRequest
{
    NSDictionary *parameters = @{
                                
                                 @"appID" : @"1012"
                                 };
    
    [requestDataManager requestDataByPostWithUrlString:ChangeBind parameters:parameters success:^(id  _Nullable responseObject) {
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
