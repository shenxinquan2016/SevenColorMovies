

#import <Foundation/Foundation.h>
#import <MBProgressHUD.h>
#import <SVProgressHUD.h>
#import "TWMessageBarManager.h"
#import "MONActivityIndicatorView.h"

@interface Dialog : NSObject<MBProgressHUDDelegate,MONActivityIndicatorViewDelegate> {
	MBProgressHUD *HUD;
    MONActivityIndicatorView *monView_;
	long long expectedLength;
	long long currentLength;
}

+ (Dialog *)Instance;

//提示对话框
+ (void)alert:(NSString *)message;
+ (void)alertWithTitle:(NSString *)title andMessage:(NSString *)message;

//添加到vc的view上 类似于Android一个显示框效果 底部
+ (void)toast:(UIViewController *)controller withMessage:(NSString *) message;
+ (void)toast:(NSString *)message; //添加到当前keyWindow 显示在底部 类似安卓底部提示框
+ (void)toastStatus:(NSString *)message; // 底部等待状态
+ (void)hideMBHud; //隐藏底部等待状态
+ (void)simpleToast:(NSString *)message; //底部
//+ (void)hideSimpleToast;
//显示在屏幕中间
+ (void)toastCenter:(NSString *)message;
//带进度条
+ (void)progressToast:(NSString *)message;

//带遮罩效果的进度条
- (void)gradient:(UIViewController *)controller seletor:(SEL)method;

//显示遮罩
- (void)showProgress:(UIViewController *)controller;

//关闭遮罩
- (void)hideProgress;

/**
 *  显示带文字表述的风火轮
 *
 *  @param status   文字信息
 *  @param maskType 遮罩类型
 *  addTime add by gcz 14.5.14
 */
+ (void)showWithStatus:(NSString *)status maskType:(SVProgressHUDMaskType)maskType;

/**
 *  成功提示
 *
 *  @param status 提示内容
 */
+ (void)showSucessWithStatus:(NSString *)status;
/**
 *  失败提示
 *
 *  @param status 提示内容
 */
+ (void)showFailWithStatus:(NSString *)status;

// 圆环进度
+ (void)showProgress:(CGFloat)progress status:(NSString *)status;

/**
 *  隐藏SVProgressHUD
 *  addTime add by gcz 14.5.14
 */
+ (void)dismissSVHUD;

//带说明的进度条
- (void)progressWithLabel:(UIViewController *)controller seletor:(SEL)method;

//显示带说明的进度条
- (void)showProgress:(UIViewController *)controller withLabel:(NSString *)labelText;
- (void)showCenterProgressWithLabel:(NSString *)labelText;

/**
 *  顶部或底部提示条（集成）
 *
 *  @param title  标题
 *  @param type   类型
 *  @param places y坐标数组 @[起始y坐标,最后y坐标]
 */
+ (void)twTitle:(NSString *)title type:(TWMessageBarMessageType)type places:(NSArray *)places;

/**
 *  隐藏TWBar
 */
+ (void)twDismiss;

// 显示咕噜视图
- (void)showMONto:(UIView *)view center:(CGPoint)center;
// 隐藏咕噜视图
- (void)dismissMon;

@end
