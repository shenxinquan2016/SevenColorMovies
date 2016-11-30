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
    
    //    [NSThread sleepForTimeInterval:2.0f];
    //    [self setAppearance];
    
    
    //-1.启动播放代理包
    [self setLibagent];
    //0.初始化键盘控制
    [self initKeyboardManager];
    
    //2.设置网络环境
    [self setNetworkEnvironment];
    
    //3.点播播放列表点击标识置为0
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:k_for_VOD_selectedViewIndex];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:k_for_VOD_selectedCellIndex];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return YES;
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
    
    // 当应用被关闭终止时，可以判断当前如果存在下载任务，可以取消任务并保存resumeData
//    if(!self.downTask){
//        return;
//    }
//    [self.downTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
//        if(resumeData){
//            self.resumeData = resumeData;
//            //可以进一步存储到NSUserDefault或持久化文件中,等下次应用启动后决定是否需要断点续传重新下载
//        }
//    }];
    
    
   //    libagent_close();
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

- (void)initKeyboardManager {
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;//enable控制整个功能是否启用。
    manager.shouldResignOnTouchOutside = YES;//控制点击背景是否收起键盘。
    manager.shouldToolbarUsesTextFieldTintColor = YES;//控制键盘上的工具条文字颜色是否用户自定义
    manager.enableAutoToolbar = NO;//控制是否显示键盘上的工具条。
}

//启动播放代理
- (void)setLibagent{
    const NSString *uuidStr = [HLJUUID getUUID];
    
    const char *uuid = [uuidStr UTF8String];
    libagent_start(0, NULL, uuid, 5656);
    
}

@end
