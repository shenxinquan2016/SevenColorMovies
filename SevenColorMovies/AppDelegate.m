//
//  AppDelegate.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/15.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [NSThread sleepForTimeInterval:2.0f];
   
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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
}




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
    
//    NetUrlManager.domainName = dic[@"domainName"];
//    NetUrlManager.commonPort = dic[@"commPort"];
//    NetUrlManager.searchPort = dic[@"searchPort"];
//    NetUrlManager.payPort = dic[@"payPort"];
    
}

@end
