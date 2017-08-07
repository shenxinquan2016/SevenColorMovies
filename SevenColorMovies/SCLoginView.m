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
    if (_loginBlock) {
        _loginBlock(_mobileTF.text, _passwordTF.text);
    }
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

@end
