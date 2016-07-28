//
//  SCNetHelper.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/27.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#define NONETWORK @"noNetwork"
#define WWANSTATUS @"WWANStatus"
#define WIFISTATUS @"wifiStatus"

#import <Foundation/Foundation.h>
#import "QINetReachabilityManager.h"

typedef void (^noNetWork)();
typedef void (^WWANNetwork)();
typedef void (^WifiNetwork)();


typedef void (^netWorkChangeToWifi)();
typedef void (^netWorkChangeToWWAN)();
typedef void (^netWorkChangeToWifiOrWWAN)();

@interface SCNetHelper : NSObject

+ (NSString *)netStatus;

+ (void)noNetWork:(noNetWork)noNetWork;
+ (void)WWANNetwork:(WWANNetwork)WWANNetwork;
+ (void)wifiNetwork:(WifiNetwork)WifiNetwork;



+ (void)changeToWifiOrWWAN:(netWorkChangeToWifiOrWWAN)netWorkChangeToWifi changeToNoNetWork:(noNetWork)noNetWork;
+ (void)changeToWifi:(netWorkChangeToWifi)netWorkChangeToWifi netWorkChangeToWWAN:(netWorkChangeToWWAN)netWorkChangeToWWAN changeToNoNetWork:(noNetWork)noNetWork;
/**
 *  检测2G/3G网络状态
 *
 *  @return 2G/3G是否联通
 */
+ (BOOL) checkGPRSNet;

/**
 *  检测WiFi网络状态
 *
 *  @return WiFi是否联通
 */
+ (BOOL) checkWifiNet;

/**
 *  检测网络连接状态
 *
 *  @return 网络是否联通
 */
+ (BOOL)isNetConnect;

+(NSString *)getNetWorkStates;


+ (NSString*)getCarrier;



@end