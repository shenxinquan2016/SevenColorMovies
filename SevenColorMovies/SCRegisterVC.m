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
    _caNoTF.keyboardType = UIKeyboardTypeEmailAddress;
    _documentNoTF.keyboardType = UIKeyboardTypeEmailAddress;
}

// 下发短验
- (IBAction)sendShortMessage:(id)sender
{
    
    [self sendShortMsgNetworkRequest];
}

// 注册
- (IBAction)submitRegistration:(id)sender
{
    
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
    [requestDataManager postRequestJsonDataWithUrl:SendShortMsg parameters:parameters success:^(id  _Nullable responseObject) {
        
        DONG_Log(@"responseObject-->%@", responseObject);
        
    } failure:^(id  _Nullable errorObject) {
        
        DONG_Log(@"errorObject-->%@", errorObject);
    }];
}

// 短信验证
- (void)verificationShortMsgNetworkRequest
{
    NSDictionary *parameters = @{
                                 @"phoneNO" : _mobilePhoneTF.text,
                                 @"appID" : @""
                                 };
    [requestDataManager postRequestJsonDataWithUrl:VerificaionShortMsg parameters:parameters success:^(id  _Nullable responseObject) {
        DONG_Log(@"responseObject-->%@", responseObject);
        
    } failure:^(id  _Nullable errorObject) {
        DONG_Log(@"errorObject-->%@", errorObject);
        
    }];
}



@end
