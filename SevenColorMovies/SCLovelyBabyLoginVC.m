//
//  SCLovelyBabyLoginVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/6/21.
//  Copyright © 2017年 yesdgq. All rights reserved.
//  萌娃登录

#import "SCLovelyBabyLoginVC.h"
#import "SCLovelyBabyRegisterVC.h"
#import "SCMyLovelyBabyVC.h"

@interface SCLovelyBabyLoginVC ()

@property (weak, nonatomic) IBOutlet UIView *activityRulesView; // 底部视图

@property (weak, nonatomic) IBOutlet UILabel *signUpCondition;
@property (weak, nonatomic) IBOutlet UILabel *singUpConditionLabel2;
@property (weak, nonatomic) IBOutlet UILabel *signUpTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *signUpTimeLabel2;
@property (weak, nonatomic) IBOutlet UILabel *uploadTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *uploadTimeLabel2;
@property (weak, nonatomic) IBOutlet UILabel *pullSupportTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *pullSupportTimeLabel2;
@property (weak, nonatomic) IBOutlet UILabel *releaseTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseTimeLabel2;

@property (weak, nonatomic) IBOutlet UITextField *mobilePhoneTF;
@property (weak, nonatomic) IBOutlet UITextField *passWordTF;


@end

@implementation SCLovelyBabyLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _activityRulesView.hidden = YES;
    // 活动规则label属性设置
    [self initializeLabelConfiguration];
    _mobilePhoneTF.keyboardType = UIKeyboardTypePhonePad;
    _passWordTF.keyboardType = UIKeyboardTypeEmailAddress;
    _passWordTF.secureTextEntry = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)initializeLabelConfiguration
{
    [_signUpCondition setFont :[UIFont fontWithName :@"Helvetica-Bold" size :13.f]];
    [_signUpTimeLabel setFont :[UIFont fontWithName :@"Helvetica-Bold" size :13.f]];
    [_uploadTimeLabel setFont :[UIFont fontWithName :@"Helvetica-Bold" size :13.f]];
    [_pullSupportTimeLabel setFont :[UIFont fontWithName :@"Helvetica-Bold" size :13.f]];
    [_releaseTimeLabel setFont :[UIFont fontWithName :@"Helvetica-Bold" size :13.f]];
    
}

- (IBAction)gobackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 登录
- (IBAction)loginClick:(id)sender
{
    [self requestLoginData];
}

// 注册
- (IBAction)registerAction:(id)sender
{
    SCLovelyBabyRegisterVC *registerVC = DONG_INSTANT_VC_WITH_ID(@"LovelyBaby", @"SCLovelyBabyRegisterVC");
    [self.navigationController pushViewController:registerVC animated:YES];
}

#pragma mark - NetRequest

- (void)requestLoginData
{
    if (![self verificationPhoneNum:_mobilePhoneTF.text]) return;
    if (!(_passWordTF.text.length > 0)) {
        [MBProgressHUD showError:@"请输入密码！"];
        return;
    }
    
    [_mobilePhoneTF resignFirstResponder];
    [_passWordTF resignFirstResponder];
    
    NSDictionary *parameters = @{@"number" : _mobilePhoneTF.text? _mobilePhoneTF.text : @"",
                                 @"password" : _passWordTF.text? _passWordTF.text : @""
                                 };
    [CommonFunc showLoadingWithTips:@""];
    [requestDataManager getRequestJsonDataWithUrl:LovelyBabyLogin parameters:parameters success:^(id  _Nullable responseObject) {
//                DONG_Log(@"responseObject-->%@",responseObject);
        NSString *resultCode = responseObject[@"resultCode"];
        
        if ([resultCode isEqualToString:@"success"]) {
            
            UserInfoManager.lovelyBabyToken = responseObject[@"data"][@"token"];
            UserInfoManager.lovelyBabyMemberId = responseObject[@"data"][@"memberCode"];
            UserInfoManager.lovelyBabyMobilePhone = _mobilePhoneTF.text;
            UserInfoManager.lovelyBabyIsLogin = YES;
            [MBProgressHUD showSuccess:responseObject[@"msg"]];
            
            SCMyLovelyBabyVC *myVideoVC = DONG_INSTANT_VC_WITH_ID(@"LovelyBaby", @"SCMyLovelyBabyVC");
            [self.navigationController pushViewController:myVideoVC animated:YES];
            
        } else {
            [MBProgressHUD showSuccess:responseObject[@"msg"]];
        }
        [CommonFunc dismiss];
        
    } failure:^(id  _Nullable errorObject) {
        
        [CommonFunc dismiss];
    }];
}

#pragma mark - 手机号校验

// 验证手机号
- (BOOL)verificationPhoneNum:(NSString *)phoneNum
{
    BOOL isValidphoneNumber = [self verifyPhone:phoneNum];
    if (_mobilePhoneTF.text.length == 0) {
        [MBProgressHUD showError:@"请输入手机号！"];
        return NO;
    } else if (phoneNum.length > 0 && !isValidphoneNumber){
        [MBProgressHUD showError:@"手机号码格式不正确！"];
        return NO;
    }
    return YES;
}

// 校验手机号
- (BOOL)verifyPhone:(NSString *)input
{
    NSString *regex = @"^((13[0-9])|(14[0-9])|(15[0-9])|(17[0-9])|(18[0-9]))\\d{8}$";
    NSPredicate *phonePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [phonePredicate evaluateWithObject:input];
}

// 禁止旋转屏幕
- (BOOL)shouldAutorotate
{
    return NO;
}

@end
