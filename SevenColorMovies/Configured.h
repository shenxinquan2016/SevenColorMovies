//
//  Configured.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/15.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#ifndef Configured_h
#define Configured_h

#import <objc/runtime.h>//按钮添加多个参数
#import <Masonry.h>
//#import "Reachability.h" //网络监听
#import "UIImage+Addition.h"
#import "UIColor+Addition.h"



#if __has_feature(objc_arc)
//#import <ReactiveCocoa.h>
#endif


//#import <AFNetworking/AFNetworking.h>


#endif /* Configured_h */

/**************************************
 * 常用尺寸
 *************************************/
#define kMainScreenWidth    [[UIScreen mainScreen] bounds].size.width
#define kMainScreenHeight   [[UIScreen mainScreen] bounds].size.height

#define kApplecationScreenWidth  [[UIScreen mainScreen] applicationFrame].size.width
#define kApplecationScreenHeight [[UIScreen mainScreen] applicationFrame].size.height





/**************************************
 * storyboard实例化
 *************************************/
#define DD_STORYBOARD(storyboardName)          [UIStoryboard storyboardWithName:storyboardName bundle:nil]
#define DD_INSTANT_VC_WITH_ID(storyboardName,vcIdentifier)  [DD_STORYBOARD(storyboardName) instantiateViewControllerWithIdentifier:vcIdentifier]

/**************************************
 * UIAlertView
 *************************************/
//弹出信息
#define ALERT(msg) [[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil] show]
// 带占字符弹出信息(format, ## __VA_ARGS__)
#define ALERT_FORMAT(format, ...) [[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:format, ## __VA_ARGS__] delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil] show]
#define ALERT_TITLE(title, msg) [[[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil] show]














