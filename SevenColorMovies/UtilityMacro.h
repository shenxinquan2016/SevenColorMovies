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

//获取rect中某值
#define RectX(rect)                            rect.origin.x
#define RectY(rect)                            rect.origin.y
#define RectWidth(rect)                        rect.size.width
#define RectHeight(rect)                       rect.size.height

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
// 弹出信息
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

#ifdef DEBUG
#define DONG_Log2(...) NSLog(@"🔴%s 第%d行 \n %@\n\n",__func__, __LINE__, [NSString stringWithFormat:__VA_ARGS__])
#else
#define DONG_Log2(...)

#endif

#ifdef DEBUG
#define DONG_Log(...) printf("%s %s 🔴 第%d行: %s\n", [[NSDate getNowDateStr] UTF8String], [[NSString stringWithFormat:@"%s", __FILE__].lastPathComponent UTF8String] ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);

#else
#define DONG_Log(...)
#endif

#define DONG_Toast(str) [NSString stringWithFormat:@"%@",@#str]
#define DONG_NSLog(str) NSLog(@"🔴%s 第%d行 \n %@\n\n",__func__, __LINE__, [NSString stringWithFormat:@#str])

//获取view的frame某值
#define ViewWidth(v)                        v.frame.size.width
#define ViewHeight(v)                       v.frame.size.height
#define ViewX(v)                            v.frame.origin.x
#define ViewY(v)                            v.frame.origin.y

//color
#define RGB(r, g, b)             [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
#define RGBAlpha(r, g, b, a)     [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]

//weakself & strongself
#define DONG_WeakSelf(type)  __weak typeof(type) weak##type = type
#define DONG_StrongSelf(type)  __strong typeof(weak##type) strong##type = weak##type



//主要单例
#define DONG_UserDefaults                        [NSUserDefaults standardUserDefaults]
#define DONG_NotificationCenter                  [NSNotificationCenter defaultCenter]
//收到通知后执行什么操作
#define DONG_RecevieNotification(name,expression) [[DONG_NotificationCenter rac_addObserverForName:name object:nil] subscribeNext:^(NSNotification *noteification) {expression;}];




//UIView动画
#define DONG_ANIMATION(time,expression)\
[UIView animateWithDuration:time animations:^{expression}];
#define DONG_ANIMATION_COMPLETION(time,expresiion,COMPLETION)\
[UIView animateWithDuration:time animations:^{expresiion} completion:^(BOOL finished){COMPLETION}];

//延迟执行
#define DONG_MAIN_AFTER(time,expression)\
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{expression;});
#define DONG_RAC_AFTER(time,expression)\
[[RACScheduler mainThreadScheduler] afterDelay:time schedule:^{expression;}];

//设定系统字体大小
#define DONG_FONT(FLOAT) [UIFont systemFontOfSize:FLOAT]
//设定指定字体和大小
#define DONG_FONT_NAME(NAME,SIZE)  [UIFont fontWithName:NAME size:SIZE]
//粗体
#define DONG_DEFALUT_BOLD @"Helvetica-Bold"

//GCD （子线程、主线程定义）
#define DONG_BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)

#define DONG_MAIN(block) dispatch_async(dispatch_get_main_queue(),block)

#define DONG_AFTER_DELAY(s,block) \
double delayInSeconds = s;   \
dispatch_time_t delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC); \
dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);\
dispatch_after(delayInNanoSeconds, concurrentQueue, block);

#define DONG_SubThread(expression) \
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ expression; })

#define  DONG_MainThread(expression)\
dispatch_async(dispatch_get_main_queue(), ^{expression});

// 获取版本号
#ifdef DEBUG
#define LOCAL_VER_STR [[NSBundle mainBundle]infoDictionary][@"CFBundleVersion"]
#else
#define LOCAL_VER_STR [[NSBundle mainBundle]infoDictionary][@"CFBundleShortVersionString"]
#endif

#define LOCAL_DEBUG_VER_STR [[NSBundle mainBundle]infoDictionary][@"CFBundleVersion"]
#define LOCAL_RELEASE_VER_STR [[NSBundle mainBundle]infoDictionary][@"CFBundleShortVersionString"]

#define Bundle                          [NSBundle mainBundle]
#define BundleToObj(nibName)            [Bundle loadNibNamed:nibName owner:nil options:nil][0]
#define BundlePath(name,type)           [Bundle pathForResource:name ofType:type]


//弹出信息
#define ALERT(msg) [[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil] show]

// 带占字符弹出信息(format, ## __VA_ARGS__)
#define ALERT_FORMAT(format, ...) [[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:format, ## __VA_ARGS__] delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil] show]

#define ALERT_TITLE(title, msg) [[[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil] show]

//打开URL
#define DONG_OpenURL(URLString) ([[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]])

//添加点击手势1
#define DONG_TapGesture(view,funcName)\
[view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(funcName)]]

//添加点击手势2:这种方法要先创建一个tap -> UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init]; 让后把tap传到 Gesture
#define DONG_Gesture(view,Gesture,funcName) \
[[Gesture  rac_gestureSignal] subscribeNext:^(UITapGestureRecognizer *tap) { funcName; }];\
[view addGestureRecognizer:Gesture];

#define DONG_PanGesture(view,funcName)\
[view addGestureRecognizer:[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(funcName)]]

// 按钮点击事件1
#define TL_RAC_BUTTON(button,expression) [[button rac_signalForControlEvents:UIControlEventTouchUpInside]\
subscribeNext:^(UIButton *btn) { expression ;}];

// 按钮点击事件2
#define TL_RAC_COMMAND(expression) [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {\
expression; \
return [RACSignal empty];\
}]

//textField
#define DONG_PLACEHOLDER_COLOR(textField,color) [textField setValue:[UIColor color] forKeyPath:@"_placeholderLabel.textColor"];
#define DONG_PLACEHOLDER_COLOR_Hex(textField,color_Hex) [textField setValue:[UIColor colorWithHex:color_Hex] forKeyPath:@"_placeholderLabel.textColor"];

#define DONG_PLACEHOLDER_FONT(textField,TL_FONT)    [textField setValue:TL_FONT forKeyPath:@"_placeholderLabel.font"];

//根据textfield的长度决定某个按钮颜色
#define DONG_BUTTON_ENABLE_FROM_TEXTFIELD(TEXTFIELD,NUM,BUTTON) [[TEXTFIELD.rac_textSignal map:^id(NSString *text) {\
return @((text.length > NUM));\
}]\
subscribeNext:^(NSNumber *value) {\
if ([value boolValue]) {\
BUTTON.selected = YES;\
}else {\
BUTTON.selected = NO;\
}\
}];\


#endif /* UtilityMacro_h */
