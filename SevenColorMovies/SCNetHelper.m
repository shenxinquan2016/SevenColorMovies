//
//  SCNetHelper.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/27.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCNetHelper.h"
#import "Reachability.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@implementation SCNetHelper

// 检测2G/3G网络状态
+ (BOOL)checkGPRSNet{
    NetworkStatus status = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    return (status == ReachableViaWWAN);
}

// 检测Wifi网络状态
+ (BOOL)checkWifiNet{
    NetworkStatus status = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    return (status == ReachableViaWiFi);
}

// 检测网络连接状态
+ (BOOL)isNetConnect{
    if ([SCNetHelper checkWifiNet] || [SCNetHelper checkGPRSNet]) {
        return YES;
    }
    return NO;
}


+ (NSString *)netStatus {
    NSString *netStatusString;
    
    QINetReachabilityManager *manager = [QINetReachabilityManager sharedInstance];
    
    QINetReachabilityStatus status = (QINetReachabilityStatus)[manager currentNetReachabilityStatus];
    
    if(status == QINetReachabilityStatusNotReachable){
        NSLog(@"没有网络");
        netStatusString = NONETWORK;
    }else if (status == QINetReachabilityStatusWIFI){
        NSLog(@"wifi");
        netStatusString = WIFISTATUS;
    }else if (status == QINetReachabilityStatusWWAN){
        NSLog(@"4G/3G");
        netStatusString = WWANSTATUS;
    }
    
//       [manager currentNetReachabilityStatus];
    
    return netStatusString;
    
}


+ (void)noNetWork:(noNetWork)noNetWork{
    
    QINetReachabilityManager *manager = [QINetReachabilityManager sharedInstance];
    QINetReachabilityStatus status = (QINetReachabilityStatus)[manager currentNetReachabilityStatus];
    
    if(status == QINetReachabilityStatusNotReachable){
        //        NSLog(@"没有网络");
        if (noNetWork) {
            noNetWork();
        }
    }
}


+ (void)WWANNetwork:(WWANNetwork)WWANNetwork {
    
    QINetReachabilityManager *manager = [QINetReachabilityManager sharedInstance];
    QINetReachabilityStatus status = (QINetReachabilityStatus)[manager currentNetReachabilityStatus];
    
    if (status == QINetReachabilityStatusWWAN){
        NSLog(@"4G/3G");
        if (WWANNetwork) {
            WWANNetwork();
        }
        
    }
    
}
+ (void)wifiNetwork:(WifiNetwork)WifiNetwork {
    QINetReachabilityManager *manager = [QINetReachabilityManager sharedInstance];
    
    QINetReachabilityStatus status = (QINetReachabilityStatus)[manager currentNetReachabilityStatus];
    
    if (status == QINetReachabilityStatusWIFI){
        NSLog(@"wifi");
        if (WifiNetwork) {
            WifiNetwork();
        }
    }
    
}


+ (void)changeToWifiOrWWAN:(netWorkChangeToWifiOrWWAN)netWorkChangeToWifiOrWWAN changeToNoNetWork:(noNetWork)noNetWork{
    QINetReachabilityManager *manager = [QINetReachabilityManager sharedInstance];
    [manager currentNetStatusChangedBlock:^(QINetReachabilityStatus currentStatus) {
        if(currentStatus == QINetReachabilityStatusNotReachable){
            //            NSLog(@"没有网络");
            if (noNetWork) {
                noNetWork();
            }
        }else if (currentStatus == QINetReachabilityStatusWIFI){
            //            NSLog(@"wifi");
            if (netWorkChangeToWifiOrWWAN) {
                netWorkChangeToWifiOrWWAN();
            }
            
        }else if (currentStatus == QINetReachabilityStatusWWAN){
            //            NSLog(@"4G/3G");
            if (netWorkChangeToWifiOrWWAN) {
                netWorkChangeToWifiOrWWAN();
            }
        }
    }];
    
}


+ (void)changeToWifi:(netWorkChangeToWifi)netWorkChangeToWifi netWorkChangeToWWAN:(netWorkChangeToWWAN)netWorkChangeToWWAN changeToNoNetWork:(noNetWork)noNetWork{
    QINetReachabilityManager *manager = [QINetReachabilityManager sharedInstance];
    [manager currentNetStatusChangedBlock:^(QINetReachabilityStatus currentStatus) {
        if(currentStatus == QINetReachabilityStatusNotReachable){
            NSLog(@"没有网络");
            if (noNetWork) {
                noNetWork();
            }
        }else if (currentStatus == QINetReachabilityStatusWIFI){
            NSLog(@"wifi");
            if (netWorkChangeToWifi) {
                netWorkChangeToWifi();
            }
            
        }else if (currentStatus == QINetReachabilityStatusWWAN){
            NSLog(@"4G/3G");
            if (netWorkChangeToWWAN) {
                netWorkChangeToWWAN();
            }
        }
    }];
    
}

+(NSString *)getNetWorkStates{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    NSString *state = [[NSString alloc] init];
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            
            switch (netType) {
                case 0:
                    state = @"无网络";
                    //无网模式
                    break;
                case 1:
                    state = @"2G";
                    break;
                case 2:
                    state = @"3G";
                    break;
                case 3:
                    state = @"4G";
                    break;
                case 5:
                {
                    state = @"WIFI";
                }
                    break;
                default:
                    break;
            }
        }
    }
    //根据状态选择
    return state;
}


+ (NSString*)getCarrier
{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    NSString * mcc = [carrier mobileCountryCode];
    NSString * mnc = [carrier mobileNetworkCode];
    if (mnc == nil || mnc.length <1 || [mnc isEqualToString:@"SIM Not Inserted"] ) {
        return @"Unknown";
        
    }else {
        if ([mcc isEqualToString:@"460"]) {
            NSInteger MNC = [mnc intValue];
            switch (MNC) {
                case 00:
                case 02:
                case 07:
                    return @"Mobile";
                    break;
                case 01:
                case 06:
                    return @"Unicom";
                    break;
                case 03:
                case 05:
                    return @"Telecom";
                    break;
                case 20:
                    return @"Tietong";
                    break;
                default:
                    break;
            }
        }
    }
    
    return@"Unknown";
}



@end
