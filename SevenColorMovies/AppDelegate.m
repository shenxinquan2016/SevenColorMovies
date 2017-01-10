//
//  AppDelegate.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/15.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "AppDelegate.h"
#import "SCNetUrlManger.h"
#import "IQKeyboardManager.h"
#import "HLJUUID.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    //    [self setAppearance];
    
    
    [self checkNetworkEnvironment];
    
    //-1.启动播放代理包
    [self setLibagent];
    
    //0.初始化键盘控制
    [self initKeyboardManager];
    
    //2.设置网络环境
    [self setNetworkEnvironment];
    
    //3.设置点播播放列表点击标识置为0
    [self setSelectedInitialIndex];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    //    libagent_close();
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

//       libagent_close();
}

////禁用横屏
//- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
//{
//    if (self.lanscape == YES) {
////                return UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskPortrait;
//        return UIInterfaceOrientationMaskLandscapeRight;
//
//    }
//    else
//    {
//        return UIInterfaceOrientationMaskPortrait;
//    }
//}

- (void)setSelectedInitialIndex {
    
    //点播播放列表点击标识置为0
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:k_for_VOD_selectedViewIndex];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:k_for_VOD_selectedCellIndex];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//设置网络环境
- (void)setNetworkEnvironment {
    
    NSMutableDictionary *netDic = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"switchNetworkEnvironment" ofType:@"plist"]];
    
    NSMutableDictionary *dic;
    
    if ([netDic[@"netType"] isEqualToString:@"0"]) {//开发环境
        dic = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"devEnvironment" ofType:@"plist"]];
    }else if ([netDic[@"netType"] isEqualToString:@"1"]) {//测试环境
        dic = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"testEnvironment" ofType:@"plist"]];
    }else if ([netDic[@"netType"] isEqualToString:@"2"]) {//生产环境
        dic = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"onlineEnvironment" ofType:@"plist"]];
    }
    
    NetUrlManager.domainName = dic[@"domainName"];
    NetUrlManager.commonPort = dic[@"commPort"];
    NetUrlManager.interface5 = dic[@"interface5"];
    NetUrlManager.payPort = dic[@"payPort"];
    
}

- (void)setAppearance {
    
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    navigationBar.barStyle = UIStatusBarStyleDefault;
    [navigationBar setTintColor:[UIColor blackColor]];
    navigationBar.backIndicatorImage = [UIImage imageNamed:@"Back_Arrow"];
    navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"Back_Arrow"];
    navigationBar.backItem.title = @"";
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
}

- (void)initKeyboardManager
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;//enable控制整个功能是否启用。
    manager.shouldResignOnTouchOutside = YES;//控制点击背景是否收起键盘。
    manager.shouldToolbarUsesTextFieldTintColor = YES;//控制键盘上的工具条文字颜色是否用户自定义
    manager.enableAutoToolbar = NO;//控制是否显示键盘上的工具条。
}

- (void)checkNetworkEnvironment {
    //    [SCNetHelper noNetWork:^{
    //        DONG_NSLog(没有网);
    //    }];
    //
    //    [SCNetHelper WWANNetwork:^{
    //        DONG_NSLog(4G网络);
    //
    //    }];
    //
    //    [SCNetHelper wifiNetwork:^{
    //        DONG_NSLog(WiFi网络);
    //    }];
    //
       DONG_Log(@"%@",[SCNetHelper getNetWorkStates]);
    
    
    
    [SCNetHelper changeToWifi:^{
        DONG_Log(@"wifi");
       

    } netWorkChangeToWWAN:^{
        DONG_Log(@"4G");
        UIAlertView *alertview =[[UIAlertView alloc] initWithTitle:@"提示" message:@"切换到移动网络,继续使用将会消耗您的流量" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertview show];

    } changeToNoNetWork:^{
        DONG_Log(@"没有网络");
        [MBProgressHUD showError:@"网络断开"];
    }];

}

//启动播放代理
- (void)setLibagent{
    const NSString *uuidStr = [HLJUUID getUUID];
    const char *uuid = [uuidStr UTF8String];
//    libagent_start(0, NULL, uuid, 5656);
    

}

@end
