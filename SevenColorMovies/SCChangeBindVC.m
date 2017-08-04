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
{
    NSString *_serviceCode; // 服务编码 CA卡号
    NSString *_nowCustomerLevel; // 新用户等级
    NSString *_customerId; // 用户id
    NSString *_idNumber; // 用户身份证号
}

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
//    [self verificationShortMsgNetworkRequest];
    [self queryCustomerInfoByMobilePhone];
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
                                 @"phoneNO" : UserInfoManager.mobilePhone,
                                 @"appID" : @"1012"
                                 };
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [CommonFunc showLoadingWithTips:@""];
    [requestDataManager requestDataByPostWithUrlString:VerificaionShortMsg parameters:parameters success:^(id  _Nullable responseObject) {
        DONG_Log(@"responseObject-->%@", responseObject);
        
        NSInteger resultCode = [responseObject[@"ResultCode"] integerValue];
        
        if (resultCode == 0) {
            
            if ([responseObject[@"ResultMessage"] isEqualToString:_verificationCodeTF.text]) {
                // 修改绑定
                [self queryCustomerInfoByMobilePhone];
                
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

// 1. 根据注册的手机号查询用户信息查询接口
- (void)queryCustomerInfoByMobilePhone
{
    NSDictionary *parameters = @{
                                 @"mobile" : UserInfoManager.mobilePhone,
                                 @"systemType" : @"1",
                                 };
    
    [CommonFunc showLoadingWithTips:@""];
    [requestDataManager requestDataByPostWithUrlString:QueryUserInfo parameters:parameters success:^(id  _Nullable responseObject) {
        DONG_Log(@"responseObject-->%@", responseObject);
        
        NSInteger resultCode = [responseObject[@"ResultCode"] integerValue];
        
        if (resultCode == 0) {
            // 获取老的用户等级 和 CA卡号
            NSString *infoStr = responseObject[@"Info"];
            NSArray *infoArr = [infoStr componentsSeparatedByString:@"^"];
            _serviceCode = infoArr[3];
            
            if (_serviceCode) {
                UserInfoManager.serviceCode = _serviceCode;
            }
            // 2. 根据绑定的服务号码查询用户信息查询接口
            [self queryCustomerInfoByByServiceCode];
            
        } else {
            
            [MBProgressHUD showSuccess:responseObject[@"ResultMessage"]];
            [CommonFunc dismiss];
        }
        
        
    } failure:^(id  _Nullable errorObject) {
        
        DONG_Log(@"errorObject-->%@", errorObject);
        [CommonFunc dismiss];
    }];
}

// 2. 根据绑定的服务号码查询用户信息查询接口
- (void)queryCustomerInfoByByServiceCode
{
    NSDictionary *parameters = @{
                                 @"serviceCode" : _serviceCode,
                                 @"serviceType"  : @"02",
                                 };
    
    [requestDataManager requestDataByPostWithUrlString:QureyUserInfoByServiceCode parameters:parameters success:^(id  _Nullable responseObject) {
        DONG_Log(@"responseObject-->%@", responseObject);
        
        NSInteger resultCode = [responseObject[@"ResultCode"] integerValue];
        
        if (resultCode == 0) {
            
            // 获取新用户等级 和 新用户id
            NSString *infoStr = responseObject[@"Info"];
            NSArray *infoArr = [infoStr componentsSeparatedByString:@"^"];
            _customerId = infoArr[0];
            _nowCustomerLevel = infoArr[3];
            _idNumber = infoArr[4];
            
            if (_nowCustomerLevel) {
                UserInfoManager.customerLevel = _nowCustomerLevel;
            }
            
            [self submitChangeBindInfoNetworkRequest];
            
        } else {
            
            [CommonFunc dismiss];
            [MBProgressHUD showSuccess:responseObject[@"ResultMessage"]];
        }
        
    } failure:^(id  _Nullable errorObject) {
        
        DONG_Log(@"errorObject-->%@", errorObject);
        [CommonFunc dismiss];
    }];
}


- (void)submitChangeBindInfoNetworkRequest
{
    NSDictionary *parameters = @{
                                 @"mobile"              : UserInfoManager.mobilePhone,
                                 @"systemType"          : @"02",
                                 @"oldBindType"         : @"02",
                                 @"bindServiceCode"     : _caCardNoTF.text,
                                 @"oldBindServiceCode"  : _serviceCode, // 老服务编码
                                 @"pinCode"             : _idNumber
                                 };
    
    [requestDataManager requestDataByPostWithUrlString:ChangeBind parameters:parameters success:^(id  _Nullable responseObject) {
        DONG_Log(@"responseObject-->%@", responseObject);
        
        NSInteger resultCode = [responseObject[@"ResultCode"] integerValue];
        
        if (resultCode == 0) {
            
           [MBProgressHUD showSuccess:responseObject[@"ResultMessage"]];
            [self.navigationController popViewControllerAnimated:YES];
            
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
