//
//  SCForgetPasswordVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/7/14.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import "SCForgetPasswordVC.h"

@interface SCForgetPasswordVC ()

@property (weak, nonatomic) IBOutlet UITextField *mobilePhoneTF;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordAgainTF;

@end

@implementation SCForgetPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.leftBBI.text = @"忘记密码";
    
    _mobilePhoneTF.keyboardType = UIKeyboardTypePhonePad;
    _nameTF.keyboardType = UIKeyboardTypeDefault;
    _passwordTF.keyboardType = UIKeyboardTypeEmailAddress;
    _passwordAgainTF.keyboardType = UIKeyboardTypeEmailAddress;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)findBackPassword:(id)sender
{
    [self findBackThePasswordNetwordRequest];
}

- (void)findBackThePasswordNetwordRequest
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

    
    if (![self verificationPhoneNum:_mobilePhoneTF.text]) return;
    if (!(_nameTF.text.length > 0)) {
        [MBProgressHUD showError:@"请输入姓名！"];
        return;
    }
    if (!(_passwordTF.text.length > 0)) {
        [MBProgressHUD showError:@"请输入密码！"];
        return;
    }
    if (!(_passwordAgainTF.text.length > 0)) {
        [MBProgressHUD showError:@"请输入确认密码！"];
        return;
    }
    
    if (![_passwordTF.text isEqualToString:_passwordAgainTF.text]) {
        [MBProgressHUD showError:@"两次输入的密码不一致！"];
        return;
    }
    
    
    NSDictionary *parameters = @{@"number" : _mobilePhoneTF.text? _mobilePhoneTF.text : @"",
                                 @"userName" : _nameTF.text? _nameTF.text : @"",
                                 @"password" : _passwordTF.text? _passwordTF.text : @"",
                                 };
    [CommonFunc showLoadingWithTips:@""];
    [requestDataManager getRequestJsonDataWithUrl:LovelyBabyForgetPassword parameters:parameters success:^(id  _Nullable responseObject) {
        DONG_Log(@"responseObject-->%@",responseObject);
       
        NSString *resultCode = responseObject[@"resultCode"];
        
        if ([resultCode isEqualToString:@"true"]) {

            [self.navigationController popViewControllerAnimated:YES];
            
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



@end
