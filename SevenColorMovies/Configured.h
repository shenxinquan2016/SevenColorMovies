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
#import "Masonry.h"
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
#import "NSString+Dong.h"
#import "NSDate+Addition.h"
#import "SCChangeBrightnessAndVolumeTool.h"
#import "NotificationMacro.h"// 通知的宏定义
#import "UIImageView+WebCache.h"// SDWebImage
#import "UILabel+Addition.h"
#import "libagent_start.h"// 黑广播放代理
#import "FileManageCommon.h"
#import "SCNetHelper.h"
#import "NSData+Addition.h"
#import "SCDomaintransformTool.h"// 动态域名转换获取工具
#import "HLJRequest.h"// ip 转换工具
#import "HLJUUID.h"


//@import MJRefresh;
//@import MJExtension;


#if __has_feature(objc_arc)
//#import "ReactiveCocoa.h"
#endif

#import <AFNetworking/AFNetworking.h>





typedef NS_ENUM(NSUInteger, SCLiveProgramState) {
    HavePast = 0,//回看
    NowPlaying,//直播
    WillPlay,//未开始
};

typedef NS_ENUM(NSUInteger, SCFilterOptionType) {
    FilmType = 0,//类型
    FilmArea,//地区
    FilmTime,//时间
};


#endif /* Configured_h */













