//
//  SCLoginView.h
//  SevenColorMovies
//
//  Created by yesdgq on 2017/7/31.
//  Copyright © 2017年 yesdgq. All rights reserved.
//  登录窗口

#import <UIKit/UIKit.h>

typedef void(^LoginBlock)(NSString *mobile, NSString *password);
typedef void(^RegisterBlock)();
typedef void(^ForgetPasswordBlock)();

@interface SCLoginView : UIView

@property (weak, nonatomic) IBOutlet UITextField *mobileTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@property (nonatomic, copy) LoginBlock loginBlock;
@property (nonatomic, copy) RegisterBlock registerBlock;
@property (nonatomic, copy) ForgetPasswordBlock forgetPasswordBlock;

@end
