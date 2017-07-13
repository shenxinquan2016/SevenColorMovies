//
//  SCLovelyBabyRegisterVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/6/21.
//  Copyright © 2017年 yesdgq. All rights reserved.
//  萌娃注册

#import "SCLovelyBabyRegisterVC.h"
#import "SCMyLovelyBabyVC.h"

@interface SCLovelyBabyRegisterVC () <UITextFieldDelegate>

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
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UIButton *maleBtn;
@property (weak, nonatomic) IBOutlet UIButton *femaleBtn;
@property (weak, nonatomic) IBOutlet UITextField *ageTF;
@property (weak, nonatomic) IBOutlet UITextField *cityTF; // 市
@property (weak, nonatomic) IBOutlet UITextField *countyTF; // 县
@property (weak, nonatomic) IBOutlet UITextField *schoolTF;
@property (weak, nonatomic) IBOutlet UITextField *spareInfo; // 备用联系方式



@end

@implementation SCLovelyBabyRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _activityRulesView.hidden = YES;
    // 活动规则label属性设置
    [self initializeLabelConfiguration];
    
    _mobilePhoneTF.delegate = self;
    _mobilePhoneTF.keyboardType = UIKeyboardTypePhonePad;
    _passWordTF.keyboardType = UIKeyboardTypeEmailAddress;
    _passWordTF.secureTextEntry = YES;
    _ageTF.keyboardType = UIKeyboardTypeNumberPad;
    _spareInfo.keyboardType = UIKeyboardTypeNumberPad;
    
   
    
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
    
    // 单选框
    [_maleBtn setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateSelected];
    [_maleBtn setImage:[UIImage imageNamed:@"Unselect"] forState:UIControlStateNormal];
    [_femaleBtn setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateSelected];
    [_femaleBtn setImage:[UIImage imageNamed:@"Unselect"] forState:UIControlStateNormal];

    _maleBtn.selected = YES;
    _femaleBtn.selected = NO;
}

// 返回键
- (IBAction)gobackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 性别男
- (IBAction)selectMale:(id)sender
{
    _maleBtn.selected = YES;
    _femaleBtn.selected = NO;
}

// 性别女
- (IBAction)selectFemale:(id)sender
{
    _maleBtn.selected = NO;
    _femaleBtn.selected = YES;
}

// 提交注册
- (IBAction)SubmitRegistration:(id)sender
{
    [self requestRegisterData];
}

#pragma mark - NetRequest

- (void)requestRegisterData
{
    if (![self verificationPhoneNum:_mobilePhoneTF.text]) return;
    if (!(_passWordTF.text.length > 0)) {
        [MBProgressHUD showError:@"请输入密码！"];
        return;
    }
    if (!(_nameTF.text.length > 0)) {
        [MBProgressHUD showError:@"请输入姓名！"];
        return;
    }
    if (!(_ageTF.text.length > 0)) {
        [MBProgressHUD showError:@"请输入年龄！"];
        return;
    } else {
        NSInteger age = [_ageTF.text integerValue];
        if (age < 4 || age > 12) {
            [MBProgressHUD showError:@"你的年龄不符合活动要求！"];
            return;
        }
    }
    if (!(_cityTF.text.length > 0)) {
        [MBProgressHUD showError:@"请输入市！"];
        return;
    }
    if (!(_countyTF.text.length > 0)) {
        [MBProgressHUD showError:@"请输入县！"];
        return;
    }
    if (!(_schoolTF.text.length > 0)) {
        [MBProgressHUD showError:@"请输入学校！"];
        return;
    }
    if (!(_spareInfo.text.length > 0)) {
        [MBProgressHUD showError:@"请输入备用联系方式！"];
        return;
    }
   
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    NSString *gender = @"0";
    if (_maleBtn.isSelected) {
        gender = @"1";
    }
    NSString *schoolName = [NSString stringWithFormat:@"%@%@%@", _cityTF.text, _countyTF.text, _schoolTF.text];
    
    NSDictionary *parameters = @{@"number" : _mobilePhoneTF.text? _mobilePhoneTF.text : @"",
                                 @"password" : _passWordTF.text? _passWordTF.text : @"",
                                 @"terminalName" : _nameTF.text, // 姓名
                                 @"terminalType" : gender, // 性别
                                 @"terminalAddress" : schoolName, // 学校
                                 @"field1" : _ageTF.text // 年龄
                                 };
    [CommonFunc showLoadingWithTips:@""];
    [requestDataManager getRequestJsonDataWithUrl:LovelyBabyRegister parameters:parameters success:^(id  _Nullable responseObject) {
//        DONG_Log(@"responseObject-->%@",responseObject);
        NSString *resultCode = responseObject[@"resultCode"];
        
        if ([resultCode isEqualToString:@"success"]) {
            
            UserInfoManager.lovelyBabyToken = responseObject[@"data"][@"token"];
            UserInfoManager.lovelyBabyMemberId = responseObject[@"data"][@"memberCode"];
            UserInfoManager.lovelyBabyMobilePhone = _mobilePhoneTF.text;
            UserInfoManager.lovelyBabyIsLogin = YES;
            [MBProgressHUD showSuccess:responseObject[@"msg"]];
            
            SCMyLovelyBabyVC *myVideoVC = DONG_INSTANT_VC_WITH_ID(@"LovelyBaby", @"SCMyLovelyBabyVC");
            [self.navigationController pushViewController:myVideoVC animated:YES];
            
        }  else {
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

#pragma mark - UITextfieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

// 禁止旋转屏幕
- (BOOL)shouldAutorotate
{
    return NO;
}

@end
