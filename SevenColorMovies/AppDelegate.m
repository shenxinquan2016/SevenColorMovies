//
//  AppDelegate.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/15.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "AppDelegate.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "SCXMPPManager.h"
#import "SCNetUrlManger.h"
#import "IQKeyboardManager.h"
#import "HLJUUID.h"
#import "ZFDownloadManager.h"// 第三方下载工具
//#import "NSObject+LBLaunchImage.h"
#import "DONG_LaunchAdView.h"

@interface AppDelegate ()

@property (nonatomic, strong) DONG_LaunchAdView *launchAdView;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // -1.网络状态监测
    [self checkNetworkEnvironment];
    // 0.初始化键盘控制
    [self initKeyboardManager];
    // 2.设置网络环境
    [self setNetworkEnvironment];
    // 3.设置点播播放列表点击标识置为0
    [self setSelectedInitialIndex];
    // 4.开启Crashlytics崩溃日志
    [Fabric with:@[[Crashlytics class]]];
    [self logUser];
    // 5.自动登录xmpp
    [self xmppLogin];
    // 6.启动广告
//    [self setLaunchAdvertisement];
    
    
    return YES;
}

// 禁用横屏
//- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
//{
//    if (self.lanscape == YES) {
//        //        return UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskPortrait;
//        return UIInterfaceOrientationMaskLandscapeRight;
//
//    }
//    else
//    {
//        return UIInterfaceOrientationMaskPortrait;
//    }
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    // App进入后台 发送通知 记录播放信息
    [DONG_NotificationCenter postNotificationName:AppWillResignActive object:nil];
    
    // App进入后台 关闭播放代理
    DONG_MAIN(^{
        
        [[ZFDownloadManager sharedDownloadManager] pauseAllDownloads];
        libagent_finish();
        libagent_close();
        DONG_Log(@"%@", [NSThread currentThread]); // 主线程
    });
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    // App激活时 启动播放代理包
    [self setLibagent];
    // 如果是正在播放时进入后台的 接着播放
    [DONG_NotificationCenter postNotificationName:AppDidBecomeActive object:nil];
    
    
    // 移动网络环境下播放是否提醒  每次APP进入时，设置为yes
    BOOL mobileNetworkAlert = YES;
    [DONG_UserDefaults setBool:mobileNetworkAlert forKey:kMobileNetworkAlert];
    [DONG_UserDefaults synchronize];
    
    // 数据采集启动行为
//    [UserInfoManager addCollectionDataWithType:@"startUp" filmName:@"iOS启动" mid:@"startUp"];
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:
    
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

- (void)setSelectedInitialIndex
{
    //点播播放列表点击标识置为0
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:k_for_VOD_selectedViewIndex];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:k_for_VOD_selectedCellIndex];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)xmppLogin
{
    // 登录XMPP 不绑定
    NSString *hid = [DONG_UserDefaults objectForKey:KHidByTVBox];
    NSString *uid = [DONG_UserDefaults objectForKey:kUidByTVBox];
    if (hid.length > 0 && hid.length > 0) {
        NSString *uuidStr = [HLJUUID getUUID];
        XMPPManager.uid = uid;
        XMPPManager.hid = hid;
        [XMPPManager initXMPPWithUserName:uid andPassWord:@"voole" resource:uuidStr];
    }
}

// 设置网络环境
- (void)setNetworkEnvironment
{
    NSMutableDictionary *netDic = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"switchNetworkEnvironment" ofType:@"plist"]];
    
    NSMutableDictionary *dic;
    
    if ([netDic[@"netType"] isEqualToString:@"0"]) { // 开发环境
        dic = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"devEnvironment" ofType:@"plist"]];
    } else if ([netDic[@"netType"] isEqualToString:@"1"]) { // 测试环境
        dic = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"testEnvironment" ofType:@"plist"]];
    } else if ([netDic[@"netType"] isEqualToString:@"2"]) { // 生产环境
        dic = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"onlineEnvironment" ofType:@"plist"]];
    }
    
    NetUrlManager.domainName = dic[@"domainName"];
    NetUrlManager.commonPort = dic[@"commPort"];
    NetUrlManager.interface5 = dic[@"interface5"];
    NetUrlManager.payPort = dic[@"payPort"];
    
}

- (void)setAppearance
{
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

- (void)checkNetworkEnvironment
{
    //        [SCNetHelper noNetWork:^{
    //            DONG_Log(@"没有网");
    //        }];
    //
    //        [SCNetHelper WWANNetwork:^{
    //            DONG_Log(@"4G网络");
    //
    //        }];
    //
    //        [SCNetHelper wifiNetwork:^{
    //            DONG_Log(@"WiFi网络");
    //        }];
    //
    //    DONG_Log(@"%@",[SCNetHelper getNetWorkStates]);
    
    
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

- (void) logUser
{
    // TODO: Use the current user's information
    // You can call any combination of these three methods
    [CrashlyticsKit setUserIdentifier:@"54321"];
    [CrashlyticsKit setUserEmail:@"yesdgq@yahoo.com"];
    [CrashlyticsKit setUserName:@"yesdgq"];
}

//启动播放代理
- (void)setLibagent
{
    const NSString *uuidStr = [HLJUUID getUUID];
    const char *uuid = [uuidStr UTF8String];
    
    
    libagent_start(0, NULL, uuid, 5656);
    
    // 开代理日志
    //            [requestDataManager requestDataWithUrl:@"http://127.0.0.1:5656/logon" parameters:nil success:^(id  _Nullable responseObject) {
    //
    //                DONG_Log(@"responseObject:%@",responseObject);
    //
    //            } failure:^(id  _Nullable errorObject) {
    //
    //
    //            }];
    
}

- (void)setLaunchAdvertisement
{
    [requestDataManager getRequestJsonDataWithUrl:@"http://192.167.1.6:15414/html/hlj_appjh/appad.txt" parameters:nil success:^(id  _Nullable responseObject) {
        
        //DONG_Log(@"responseObject-->%@", responseObject);
        NSArray *dataArr = (NSArray *)responseObject;
        
        for (NSDictionary *dict in dataArr) {
            if ([dict[@"adId"] isEqualToString:@"start-ad"]) {
                SCAdvertisementModel *launchAdModel = [SCAdvertisementModel mj_objectWithKeyValues:dict];
                [self.window makeKeyAndVisible];
                self.launchAdView = [[DONG_LaunchAdView alloc] init];
                self.launchAdView.imageURL = launchAdModel.imgUrl;
                self.launchAdView.getLaunchImageAdViewType(FullScreenAdType);
                // 各种点击事件的回调
                self.launchAdView.clickBlock = ^(clickType type){
                    switch (type) {
                        case clickAdType:{
                            // 点击广告回调
                            // adType:web-->打开网页 adType:app-->打开app
                            if ([launchAdModel.adType isEqualToString:@"web"]) {
                                
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:launchAdModel.webUrl]];
                                
                            } else if ([launchAdModel.adType isEqualToString:@"app"]) {
                                
                                NSString *urlScheme = launchAdModel.openUrl[@"packageName"];
                                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://",urlScheme]];
                                DONG_Log(@"packId-->%@", url);
                                [[UIApplication sharedApplication] openURL:url];
                            }
                        }
                            break;
                        case skipAdType:
                            DONG_Log(@"点击跳过回调");
                            break;
                        case overtimeAdType:
                            DONG_Log(@"倒计时完成后的回调");
                            break;
                        default:
                            break;
                    }
                };
                [self.window addSubview: self.launchAdView];
            }
        }
   
    } failure:^(id  _Nullable errorObject) {
        
        DONG_Log(@"errorObject-->%@", errorObject);
    }];
}

@end
