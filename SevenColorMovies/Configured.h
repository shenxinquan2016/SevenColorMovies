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
#import "SCNetRequsetManger.h"
#import "SCNetUrlManger.h"

#import "UIImage+Addition.h"
#import "UIColor+Addition.h"
#import "UIImageView+Addition.h"
#import "MJExtension.h"
#import "SCUserInfoManger.h"
#import "MBProgressHUD+Addidtion.h"
#import "MJRefresh.h"
#import "DONG_RefreshGifFooter.h"
#import "DONG_RefreshGifHeader.h"
#import "SCComonFunc.h"
#import "XMLDictionary.h"
#import "UIButton+Addition.h"



#if __has_feature(objc_arc)
//#import <ReactiveCocoa.h>
#endif


#import <AFNetworking/AFNetworking.h>


#endif /* Configured_h */

/**************************************
 * 常用尺寸
 *************************************/
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




/**************************************
 * storyboard实例化
 *************************************/
#define DONG_STORYBOARD(storyboardName)          [UIStoryboard storyboardWithName:storyboardName bundle:nil]
#define DONG_INSTANT_VC_WITH_ID(storyboardName,vcIdentifier)  [DONG_STORYBOARD(storyboardName) instantiateViewControllerWithIdentifier:vcIdentifier]

/**************************************
 * UIAlertView
 *************************************/
//弹出信息
#define ALERT(msg) [[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil] show]
// 带占字符弹出信息(format, ## __VA_ARGS__)
#define ALERT_FORMAT(format, ...) [[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:format, ## __VA_ARGS__] delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil] show]
#define ALERT_TITLE(title, msg) [[[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil] show]


/**************************************
 * NSLog
 *************************************/
//#define NSLog() NSLog(@"...")


//获取view的frame某值
#define ViewWidth(v)                        v.frame.size.width
#define ViewHeight(v)                       v.frame.size.height
#define ViewX(v)                            v.frame.origin.x
#define ViewY(v)                            v.frame.origin.y

//color
#define RGB(r, g, b)             [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
#define RGBAlpha(r, g, b, a)     [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]







/******************************************首页接口的URL*******************************************/
// banner URL
#define url_Banner @"/b2b/filmlist.php?v=3.0&spid=20120528&epgid=600111&ctype=3&column=cate_EPG50sy_EPG50syjdlbt_liaoningyidong"
// 片单 URL
#define url_FilmList @"/b2b/filmlist.php?v=3.0&epgid=600111&spid=20120528"




/******************************************首页接口*******************************************/
// homePage 接口
#define HomePageUrl @"http://10.177.1.222:5040/filmlist?epgid=909191&spid=20151103&cpid=10001000&ctype=9"

// banner 接口
#define BannerURL [NetUrlManager.domainName stringByAppendingString:url_Banner]
// 片单接口
#define FilmList [NetUrlManager.domainName stringByAppendingString:url_FilmList]
// filmClass接口
#define FilmClass @"http://interface5.voole.com/b2b/filmlist.php?v=3.0&spid=20120528&epgid=600111&ctype=3&column=gf201606271730129921467019536749"




