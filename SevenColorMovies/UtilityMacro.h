//
//  UtilityMacro.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/23.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#ifndef UtilityMacro_h
#define UtilityMacro_h

// 常用尺寸
#define kMainScreenWidth    [[UIScreen mainScreen] bounds].size.width
#define kMainScreenHeight   [[UIScreen mainScreen] bounds].size.height

#define kApplecationScreenWidth  [[UIScreen mainScreen] applicationFrame].size.width
#define kApplecationScreenHeight [[UIScreen mainScreen] applicationFrame].size.height

//3.5寸屏幕
#define ThreePointFiveInch ([UIScreen mainScreen].bounds.size.height == 480.0)
//4.0寸屏幕
#define FourInch ([UIScreen mainScreen].bounds.size.height == 568.0)
//4.7寸屏幕
#define FourPointSevenInch ([UIScreen mainScreen].bounds.size.height == 667.0)
//5.5寸屏幕
#define FivePointFiveSevenInch ([UIScreen mainScreen].bounds.size.height == 736.0)

#define iPhone6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242.0f, 2208.0f), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750.0f, 1334.0f), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640.0f, 1136.0f), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640.0f, 960.0f), [[UIScreen mainScreen] currentMode].size) : NO)

//iOS7系统
#define iOS7 ([UIDevice currentDevice].systemVersion.doubleValue >= 7.0  && [UIDevice currentDevice].systemVersion.doubleValue < 8.0)
//iOS8系统
#define iOS8 ([UIDevice currentDevice].systemVersion.doubleValue >= 8.0  && [UIDevice currentDevice].systemVersion.doubleValue < 9.0)
//iOS9系统
#define iOS9 ([UIDevice currentDevice].systemVersion.doubleValue >= 9.0)

// storyboard实例化
#define DONG_STORYBOARD(storyboardName)          [UIStoryboard storyboardWithName:storyboardName bundle:nil]
#define DONG_INSTANT_VC_WITH_ID(storyboardName,vcIdentifier)  [DONG_STORYBOARD(storyboardName) instantiateViewControllerWithIdentifier:vcIdentifier]

/************************************** UIAlertView *************************************/
//弹出信息
#define ALERT(msg) [[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil] show]
// 带占字符弹出信息(format, ## __VA_ARGS__)
#define ALERT_FORMAT(format, ...) [[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:format, ## __VA_ARGS__] delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil] show]
#define ALERT_TITLE(title, msg) [[[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil] show]

// NSLog(...)
#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif

//获取view的frame某值
#define ViewWidth(v)                        v.frame.size.width
#define ViewHeight(v)                       v.frame.size.height
#define ViewX(v)                            v.frame.origin.x
#define ViewY(v)                            v.frame.origin.y

//color
#define RGB(r, g, b)             [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
#define RGBAlpha(r, g, b, a)     [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]

// weakself & strongself
#define DONGWeakSelf(type)  __weak typeof(type) weak##type = type
#define DONGStrongSelf(type)  __strong typeof(weak##type) strong##type = weak##type

#define DONGToast(str) [NSString stringWithFormat:@"%@",@#str]
#define DONGNSLog(str) NSLog:@"%@",DONGToast(str)


//  主要单例
#define TL_UserDefaults                        [NSUserDefaults standardUserDefaults]
#define TL_NotificationCenter                  [NSNotificationCenter defaultCenter]
//收到通知后执行什么操作
#define TL_RecevieNotification(name,expression) [[TL_NotificationCenter rac_addObserverForName:name object:nil] subscribeNext:^(NSNotification *noteification) {expression;}];





#define TL_ANIMATION(time,expression)\
[UIView animateWithDuration:time animations:^{expression}];

#define TL_ANIMATION_COMPLETION(time,expresiion,COMPLETION)\
[UIView animateWithDuration:time animations:^{expresiion} completion:^(BOOL finished){COMPLETION}];

#define TL_AFTER(time,expression)\
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{expression;});

#define TL_RAC_AFTER(time,expression)\
[[RACScheduler mainThreadScheduler] afterDelay:time schedule:^{expression;}];

#define TL_FONT(FLOAT) [UIFont systemFontOfSize:FLOAT]
#define TL_FONT_NAME(NAME,SIZE)  [UIFont fontWithName:NAME size:SIZE]












#endif /* UtilityMacro_h */
