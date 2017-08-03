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
    NSString *_customerLevel; // 用户等级
    NSArray *_productArr; // 用户产品列表
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
                [self submitCustomerUpGradeInfoNetworkRequest];
                
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

// 变更绑定接口
- (void)submitCustomerUpGradeInfoNetworkRequest
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
            [CommonFunc dismiss];
        }
        
    } failure:^(id  _Nullable errorObject) {
        
        DONG_Log(@"errorObject-->%@", errorObject);
        [CommonFunc dismiss];
    }];
    
}

// 根据注册的手机号查询用户信息查询接口
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
            
            NSString *infoStr = responseObject[@"Info"];
            NSArray *infoArr = [infoStr componentsSeparatedByString:@"^"];
            _customerLevel = infoArr[infoArr.count-2];
            _serviceCode = infoArr[infoArr.count-3];
            // 根据用户等级查询赠送产品
            [self queryProductListByCustomerLevel];
            
        } else {
            
            [MBProgressHUD showSuccess:responseObject[@"ResultMessage"]];
            [CommonFunc dismiss];
        }
        
        
    } failure:^(id  _Nullable errorObject) {
        
        DONG_Log(@"errorObject-->%@", errorObject);
        [CommonFunc dismiss];
    }];
}

// 根据用户等级查询赠送产品
- (void)queryProductListByCustomerLevel
{
    NSDictionary *parameters = @{
                                 @"userLevel" : _customerLevel,
                                 };
    
    [requestDataManager requestDataByPostWithUrlString:QueryProductListByLevel parameters:parameters success:^(id  _Nullable responseObject) {
        DONG_Log(@"responseObject-->%@", responseObject);
        // 返回数据又变成了json 原有解析错误 将就着用
        NSInteger resultCode = [responseObject[@"ResultCode"] integerValue];
        
        if (resultCode == 0) {
            
            _productArr = [self arrayWithJsonString:responseObject[@"__text"] ] ;
            
            for (NSDictionary * dict in _productArr) {
               DONG_Log(@"infoStr-->%@", dict);
            }
            
            
        } else {
            
            [MBProgressHUD showSuccess:responseObject[@"ResultMessage"]];
        }
        
        [CommonFunc dismiss];
        
    } failure:^(id  _Nullable errorObject) {
        
        DONG_Log(@"errorObject-->%@", errorObject);
        [CommonFunc dismiss];
    }];
 
}

// 根据绑定的服务号码查询用户信息查询接口
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
            [MBProgressHUD showSuccess:responseObject[@"ResultMessage"]];
            NSString *infoStr = responseObject[@"Info"];
            NSArray *infoArr = [infoStr componentsSeparatedByString:@"^"];
            DONG_Log(@"-->%@", infoArr[3]);
            
            
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
