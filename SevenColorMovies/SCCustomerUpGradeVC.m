//
//  SCCustomerUpGradeVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/8/2.
//  Copyright © 2017年 yesdgq. All rights reserved.
//  用户升级

#import "SCCustomerUpGradeVC.h"

@interface SCCustomerUpGradeVC ()

@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTF;

@end

@implementation SCCustomerUpGradeVC
{
    NSString *_serviceCode; // 服务编码 CA卡号
    NSString *_oldCustomerLevel; // 用户等级
    NSArray *_oldProductListArr; // 老用户产品列表
    NSString *_nowCustomerLevel; // 新用户等级
    NSString *_customerId; // 用户id
    NSArray *_nowProductListArr; // 新用户产品列表
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.leftBBI.text = @"用户升级";
    _verificationCodeTF.keyboardType = UIKeyboardTypeNumberPad;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

// 下发短信
- (IBAction)sendShortMsg:(id)sender
{
    [self sendShortMsgNetworkRequest];
}

// 短信校验
- (IBAction)submitChanges:(id)sender
{
//    [self verificationShortMsgNetworkRequest];
    [self queryCustomerInfoByMobilePhone];
}

// json格式字符串转array：
- (NSArray *)arrayWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&err];
    if(err) {
        DONG_Log(@"json解析失败：%@",err);
        return nil;
    }
    return dict;
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
                // 升级
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

/* 业务逻辑
 
 1、通过手机号获取用户信息（这里边的用户等级，是老等级）
 2、通过老等级 获取 产品列表（老产品）
 3、通过1取到的用户服务编码，获取用户信息，取（用户新等级+用户ID）
 4、通过新等级 获取 产品列表 （新产品）
 
 5、调用变更接口：
 
 */

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
            _oldCustomerLevel = infoArr[infoArr.count-2];
            _serviceCode = infoArr[infoArr.count-3];
            // 根据用户等级查询赠送产品
            [self queryProductListByCustomerLevel:_oldCustomerLevel identifier:@"old"];
            
        } else {
            
            [MBProgressHUD showSuccess:responseObject[@"ResultMessage"]];
            [CommonFunc dismiss];
        }
        
        
    } failure:^(id  _Nullable errorObject) {
        
        DONG_Log(@"errorObject-->%@", errorObject);
        [CommonFunc dismiss];
    }];
}

// 2.1 根据用户等级查询赠送产品
- (void)queryProductListByCustomerLevel:(NSString *)customerLevel identifier:(NSString *)identifier
{
    NSDictionary *parameters = @{
                                 @"userLevel" : _oldCustomerLevel,
                                 };
    
    [requestDataManager requestDataByPostWithUrlString:QueryProductListByLevel parameters:parameters success:^(id  _Nullable responseObject) {
        DONG_Log(@"responseObject-->%@", responseObject);
        // 返回数据又变成了json 原有解析错误 将就着用
        NSInteger resultCode = [responseObject[@"ResultCode"] integerValue];
        
        if (resultCode == 0) {
            
            if ([identifier isEqualToString:@"old"]) {
                // 获取老的产品列表
                _oldProductListArr = [self arrayWithJsonString:responseObject[@"__text"] ] ;
               
                // 根据绑定的服务号码查询用户信息查询接口
                [self queryCustomerInfoByByServiceCode];
                for (NSDictionary * dict in _oldProductListArr) {
                    DONG_Log(@"infoStr-->%@", dict);
                }
                
            } else if ([identifier isEqualToString:@"new"]) {
                
                // 获取新的产品列表
                _nowProductListArr = [self arrayWithJsonString:responseObject[@"__text"]];
                
                // 变更绑定接口
//                [self submitCustomerUpGradeInfoNetworkRequest];
                for (NSDictionary * dict in _nowProductListArr) {
                    DONG_Log(@"infoStr-->%@", dict);
                }
            }
            
        } else {
            
            [CommonFunc dismiss];
            [MBProgressHUD showSuccess:responseObject[@"ResultMessage"]];
        }
        
        
        
    } failure:^(id  _Nullable errorObject) {
        
        DONG_Log(@"errorObject-->%@", errorObject);
        [CommonFunc dismiss];
    }];
 
}

// 2.2 根据绑定的服务号码查询用户信息查询接口
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
            
            // 2.1 根据用户等级查询赠送产品
            [self queryProductListByCustomerLevel:_nowCustomerLevel identifier:@"new"];
            
        } else {
            
            [CommonFunc dismiss];
            [MBProgressHUD showSuccess:responseObject[@"ResultMessage"]];
        }
        
    } failure:^(id  _Nullable errorObject) {
        
        DONG_Log(@"errorObject-->%@", errorObject);
        [CommonFunc dismiss];
    }];
}

// 变更绑定接口 --> 升级
- (void)submitCustomerUpGradeInfoNetworkRequest
{
    NSDictionary *parameters = @{
                                 @"mobile"              : UserInfoManager.mobilePhone,
                                 @"bindType"            : @"02",
                                 @"systemType"          : @"02",
                                 @"oldBindType"         : @"02",
                                 @"oldBindServiceCode"  : UserInfoManager.serviceCode,
                                 @"pinCode"             : @"1012",
                                 @"productList"         : @[
                                                            @{},
                                                            @{}
                                                            ],
                                 @"oldProductList"      : @[
                                                            @{},
                                                            @{}
                                                            ]
                                 
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
