//
//  SCRegisterVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/7/31.
//  Copyright © 2017年 yesdgq. All rights reserved.
//  注册页

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
    
    [self configKeyboardType];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configKeyboardType
{
    _mobilePhoneTF.keyboardType = UIKeyboardTypePhonePad;
    _verificationCodeTF.keyboardType = UIKeyboardTypeNumberPad;
    _passwordTF.keyboardType = UIKeyboardTypeEmailAddress;
    _confirmPasswordTF.keyboardType = UIKeyboardTypeEmailAddress;
    _caNoTF.keyboardType = UIKeyboardTypeNumberPad;
    _documentNoTF.keyboardType = UIKeyboardTypeNumberPad;
}

// 下发短验
- (IBAction)sendShortMessage:(id)sender
{
    [self sendShortMsgNetworkRequest];
}

// 注册
- (IBAction)submitRegistration:(id)sender
{
    // 先短验 再注册
    [self verificationShortMsgNetworkRequest];
}

#pragma mark - Network Request

// 下发短信
- (void)sendShortMsgNetworkRequest
{
    NSDictionary *parameters = @{
                                 @"phoneNO" : _mobilePhoneTF.text,
                                 @"appID"   : @"1012",
                                 @"msg"     : @"尊敬的用户您好，注册验证码为：xxxx，有效期为5分钟, 客服热线96396。"
                                 };
    [CommonFunc showLoadingWithTips:@""];
    [requestDataManager postRequestJsonDataWithUrl:SendShortMsg parameters:parameters success:^(id  _Nullable responseObject) {
        
        DONG_Log(@"responseObject-->%@", responseObject);
        
        [CommonFunc dismiss];
        
    } failure:^(id  _Nullable errorObject) {
        
        DONG_Log(@"errorObject-->%@", errorObject);
        [CommonFunc dismiss];
    }];
}

// 短信验证
- (void)verificationShortMsgNetworkRequest
{
    if (_mobilePhoneTF.text.length <= 0) {
        [MBProgressHUD showError:@"请输入手机号！"];
        return;
    }
    if (_verificationCodeTF.text.length <= 0) {
        [MBProgressHUD showError:@"请输入验证码！"];
        return;
    }
    if (_passwordTF.text.length <= 0) {
        [MBProgressHUD showError:@"请输入密码！"];
        return;
    }
    if (_confirmPasswordTF.text.length <= 0) {
        [MBProgressHUD showError:@"请输入确认密码！"];
        return;
    }
    if (![_confirmPasswordTF.text isEqualToString:_passwordTF.text]) {
        [MBProgressHUD showError:@"两次输入的密码不一致！"];
        return;
    }
    if (_caNoTF.text.length <= 0) {
        [MBProgressHUD showError:@"请输入只能卡号！"];
        return;
    }
    if (_documentNoTF.text.length <= 0) {
        [MBProgressHUD showError:@"请输入证件号！"];
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"phoneNO" : _mobilePhoneTF.text,
                                 @"appID" : @""
                                 };
    [CommonFunc showLoadingWithTips:@""];
    [requestDataManager postRequestJsonDataWithUrl:VerificaionShortMsg parameters:parameters success:^(id  _Nullable responseObject) {
        DONG_Log(@"responseObject-->%@", responseObject);
        
        // 注册
        [self submitRegisterInfoNetworkRequest];
        
    } failure:^(id  _Nullable errorObject) {
        DONG_Log(@"errorObject-->%@", errorObject);
        [CommonFunc dismiss];
        
    }];
}

// 提交注册
- (void)submitRegisterInfoNetworkRequest
{
    NSDictionary *parameters = @{
                                 @"phoneNO" : _mobilePhoneTF.text,
                                 @"appID" : @""
                                 };
    
    [CommonFunc showLoadingWithTips:@""];
    [requestDataManager postRequestJsonDataWithUrl:RegisterRegister parameters:parameters success:^(id  _Nullable responseObject) {
        DONG_Log(@"responseObject-->%@", responseObject);
        
        [CommonFunc dismiss];
        
    } failure:^(id  _Nullable errorObject) {
        DONG_Log(@"errorObject-->%@", errorObject);
        [CommonFunc dismiss];
        
    }];
}

@end
