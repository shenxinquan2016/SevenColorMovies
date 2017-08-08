//
//  SCLoginView.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/7/31.
//  Copyright © 2017年 yesdgq. All rights reserved.
//  登录窗口

#import "SCLoginView.h"

@interface SCLoginView ()

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end

@implementation SCLoginView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.7];
    _deleteButton.enlargedEdge = 10.f;
    _mobileTF.keyboardType = UIKeyboardTypePhonePad;
    _passwordTF.keyboardType = UIKeyboardTypeEmailAddress;
    _passwordTF.secureTextEntry = YES;
}

// 关闭登录对话框
- (IBAction)hideLoginView:(id)sender
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
    }];
}

// 登录
- (IBAction)login:(id)sender
{
    [self loginNetworkRequest];
}

// 注册
- (IBAction)registerCustometInfo:(id)sender
{
    if (_registerBlock) {
        _registerBlock();
    }
}

// 找回密码
- (IBAction)findBackPassword:(id)sender
{
    if (_forgetPasswordBlock) {
        _forgetPasswordBlock();
    }
}

#pragma mark - Network Request

// 登录
- (void)loginNetworkRequest
{
    if (_mobileTF.text.length <= 0) {
        [MBProgressHUD showError:@"请输入手机号！"];
        return;
    }
    if (_passwordTF.text.length <= 0) {
        [MBProgressHUD showError:@"请输入密码！"];
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"mobile"      : _mobileTF.text,
                                 @"password"    : _passwordTF.text,
                                 @"systemType"  : @"1",
                                 };
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [CommonFunc showLoadingWithTips:@""];
    [requestDataManager requestDataByPostWithUrlString:LoginLogin parameters:parameters success:^(id  _Nullable responseObject) {
        DONG_Log(@"responseObject-->%@", responseObject);
        
        NSInteger resultCode = [responseObject[@"ResultCode"] integerValue];
        
        if (resultCode == 0) {
            // 登录成功后 查询下用户等级和用户服务码
            [self queryCustomerInfoByMobilePhone:_mobileTF.text];
            
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
- (void)queryCustomerInfoByMobilePhone:(NSString *)mobilePhone
{
    NSDictionary *parameters = @{
                                 @"mobile" : mobilePhone,
                                 @"systemType" : @"1",
                                 };
    
    [requestDataManager requestDataByPostWithUrlString:QueryUserInfo parameters:parameters success:^(id  _Nullable responseObject) {
        DONG_Log(@"responseObject-->%@", responseObject);
        
        NSInteger resultCode = [responseObject[@"ResultCode"] integerValue];
        
        if (resultCode == 0) {
            // 获取老的用户等级 和 CA卡号
            NSString *infoStr = responseObject[@"Info"];
            NSArray *infoArr = [infoStr componentsSeparatedByString:@"^"];
            NSString *oldCustomerLevel = infoArr[infoArr.count-2];
            NSString *serviceCode = infoArr[infoArr.count-3];
            NSString *productList = infoArr.lastObject;
            productList = [productList stringByReplacingOccurrencesOfString:@"|" withString:@","];
            
            if (serviceCode) {
                UserInfoManager.serviceCode = serviceCode;
            }
            if (oldCustomerLevel) {
                UserInfoManager.customerLevel = oldCustomerLevel;
            }
            if (productList) {
                UserInfoManager.productList = productList;
            }
            
            // 查询用户是否有全部点播播放权限
            [self queryCustomerVODAuthorityByProductList];
 
        } else {
            
           [CommonFunc dismiss];
            [MBProgressHUD showError:responseObject[@"ResultMessage"]];
        }
        
        
    } failure:^(id  _Nullable errorObject) {
        
        DONG_Log(@"errorObject-->%@", errorObject);
        [CommonFunc dismiss];
    }];
}

// 查询用户是否有全部点播播放权限
- (void)queryCustomerVODAuthorityByProductList
{
    NSDictionary *parameters = @{
                                 @"authIds" : UserInfoManager.productList? UserInfoManager.productList : @"",
                                 };
    
    [requestDataManager getRequestJsonDataWithUrl:QueryCustomerAllVODAuthority parameters:parameters success:^(id  _Nullable responseObject) {
        DONG_Log(@"responseObject-->%@", responseObject);
        
        NSString *resultCode = responseObject[@"resultCode"];
        
        if ([resultCode isEqualToString:@"true"]) { // 有
            
            UserInfoManager.isVODUnrivaled = YES;
            [UIView animateWithDuration:0.2 animations:^{
                self.alpha = 0;
            } completion:^(BOOL finished) {
                
                UserInfoManager.isLogin = YES;
                UserInfoManager.mobilePhone = _mobileTF.text;
                [MBProgressHUD showSuccess:@"登录成功"];
                [self removeFromSuperview];
                if (_loginSuccessBlock) {
                    _loginSuccessBlock(nil,nil);
                }
            }];
            
        } else if ([resultCode isEqualToString:@"false"]) { // 没有
            
            UserInfoManager.isVODUnrivaled = NO;
            [UIView animateWithDuration:0.2 animations:^{
                self.alpha = 0;
            } completion:^(BOOL finished) {
                
                UserInfoManager.isLogin = YES;
                UserInfoManager.mobilePhone = _mobileTF.text;
                [MBProgressHUD showSuccess:@"登录成功"];
                [self removeFromSuperview];
                if (_loginSuccessBlock) {
                    _loginSuccessBlock(nil,nil);
                }
            }];
            
        } else if ([resultCode isEqualToString:@"exception"]) { // 异常
            
            UserInfoManager.isVODUnrivaled = NO;
            [MBProgressHUD showSuccess:@"登录失败"];
        }
        
        [CommonFunc dismiss];
        
    } failure:^(id  _Nullable errorObject) {
        
        DONG_Log(@"errorObject-->%@", errorObject);
        [CommonFunc dismiss];
    }];

}

@end
