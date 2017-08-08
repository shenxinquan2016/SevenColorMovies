//
//  SCUserInfoManger.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/27.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCUserInfoManger.h"

#define kIsLogin @"kIsLogin" // 登录状态
#define kToken @"kToken"  // token
#define kMobilePhone @"kMobilePhone" // 手机
#define kServiceCode @"kServiceCode" // 用户编码
#define kCustomerLevel @"kCustomerLevel" // 用户等级
#define kProductList @"kProductList" // 产品列表
#define kIsUnrivaled @"kIsUnrivaled" // 是否有全部点播权限


#define kLovelyBabyIsLogin @"kLovelyBabyIsLogin" // 萌娃是否登录
#define kLovelyBabyToken @"kLovelyBabyToken" // 萌娃token
#define kLovelyBabyMemberId @"kLovelyBabyMemberId" // 萌娃用户id
#define kLovelyBabyMobilePhone @"kLovelyBabyMobilePhone" // 萌娃用户手机

#define kDataCollectionArray @"kDataCollectionArray" // 数据采集记录array

@implementation SCUserInfoManger

+ (instancetype)shareManager {
    static SCUserInfoManger *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SCUserInfoManger alloc] init];
    });
    return manager;
}

//******************☝️☝️☝️☝️☝️☝️☝️☝️getter 方法☝️☝️☝️☝️☝️☝️☝️☝️****************

- (BOOL)isLogin
{
    return [DONG_UserDefaults boolForKey:kIsLogin];
}

- (NSString *)token
{
    return [DONG_UserDefaults objectForKey:kToken];
}

/** 手机号 */
- (NSString *)mobilePhone
{
    return [DONG_UserDefaults objectForKey:kMobilePhone];
}

/** 用户编码 */
- (NSString *)serviceCode
{
    return [DONG_UserDefaults objectForKey:kServiceCode];
}

/** 用户等级 */
- (NSString *)customerLevel
{
    return [DONG_UserDefaults objectForKey:kCustomerLevel];
}

/** 用户产品列表 */
- (NSString *)productList
{
    return [DONG_UserDefaults objectForKey:kProductList];
}

/** 是否有全部点播权限 */
- (BOOL)isUnrivaled
{
    return [DONG_UserDefaults boolForKey:kIsUnrivaled];
}


/** 萌娃是否登录 */
- (BOOL)lovelyBabyIsLogin
{
    return [DONG_UserDefaults boolForKey:kLovelyBabyIsLogin];
}

/** 萌娃token */
- (NSString *)lovelyBabyToken
{
    return [DONG_UserDefaults objectForKey:kLovelyBabyToken];
}

/** 萌娃用户id */
- (NSString *)lovelyBabyMemberId
{
    return [DONG_UserDefaults objectForKey:kLovelyBabyMemberId];
}

/** 萌娃用户手机 */
- (NSString *)lovelyBabyMobilePhone
{
   return [DONG_UserDefaults objectForKey:kLovelyBabyMobilePhone];
}

- (NSArray *)dataCollectionArray
{
    return [DONG_UserDefaults objectForKey:kDataCollectionArray];
}

//******************☝️☝️☝️☝️☝️☝️☝️☝️setter 方法☝️☝️☝️☝️☝️☝️☝️☝️****************

- (void)setIsLogin:(BOOL)isLogin
{
    [DONG_UserDefaults setBool:isLogin forKey:kIsLogin];
    [DONG_UserDefaults synchronize];
}

- (void)setToken:(NSString *)token
{
    if (![token isKindOfClass:[NSNull class]] && token.length > 0) { // 如果存在保存token
        [DONG_UserDefaults setObject:token forKey:kToken];
        [DONG_UserDefaults synchronize];
    }
}

/** 萌娃是否登录 */
- (void)setLovelyBabyIsLogin:(BOOL)lovelyBabyIsLogin
{
    [DONG_UserDefaults setBool:lovelyBabyIsLogin forKey:kLovelyBabyIsLogin];
    [DONG_UserDefaults synchronize];
}

/** 萌娃token */
- (void)setLovelyBabyToken:(NSString *)lovelyBabyToken
{
    if (![lovelyBabyToken isKindOfClass:[NSNull class]] && lovelyBabyToken.length > 0) {
        [DONG_UserDefaults setObject:lovelyBabyToken forKey:kLovelyBabyToken];
        [DONG_UserDefaults synchronize];
    }
}

/** 手机号 */
- (void)setMobilePhone:(NSString *)mobilePhone
{
    if (![mobilePhone isKindOfClass:[NSNull class]] && mobilePhone.length > 0) {
        [DONG_UserDefaults setObject:mobilePhone forKey:kMobilePhone];
        [DONG_UserDefaults synchronize];
    }
}

/** 用户编码 */
- (void)setServiceCode:(NSString *)serviceCode
{
    if (![serviceCode isKindOfClass:[NSNull class]] && serviceCode.length > 0) {
        [DONG_UserDefaults setObject:serviceCode forKey:kServiceCode];
        [DONG_UserDefaults synchronize];
    }
}

/** 用户等级 */
- (void)setCustomerLevel:(NSString *)customerLevel
{
    if (![customerLevel isKindOfClass:[NSNull class]] && customerLevel.length > 0) {
        [DONG_UserDefaults setObject:customerLevel forKey:kCustomerLevel];
        [DONG_UserDefaults synchronize];
    }
}

/** 用户产品列表 */
- (void)setProductList:(NSString *)productList
{
    if (![productList isKindOfClass:[NSNull class]] && productList.length > 0) {
        [DONG_UserDefaults setObject:productList forKey:kProductList];
        [DONG_UserDefaults synchronize];
    }
}

/** 是否有全部点播权限 */
- (void)setIsUnrivaled:(BOOL)isUnrivaled
{
    [DONG_UserDefaults setBool:isUnrivaled forKey:kIsUnrivaled];
    [DONG_UserDefaults synchronize];
}




/** 萌娃用户id */
- (void)setLovelyBabyMemberId:(NSString *)lovelyBabyMemberId
{
    if (![lovelyBabyMemberId isKindOfClass:[NSNull class]] && lovelyBabyMemberId.length > 0) {
        [DONG_UserDefaults setObject:lovelyBabyMemberId forKey:kLovelyBabyMemberId];
        [DONG_UserDefaults synchronize];
    }
}

/** 萌娃用户手机 */
- (void)setLovelyBabyMobilePhone:(NSString *)lovelyBabyMobilePhone
{
    if (![lovelyBabyMobilePhone isKindOfClass:[NSNull class]] && lovelyBabyMobilePhone.length > 0) { // 如果存在保存
        [DONG_UserDefaults setObject:lovelyBabyMobilePhone forKey:kLovelyBabyMobilePhone];
        [DONG_UserDefaults synchronize];
    }
}

/** 保存数据采集Data */
- (void)setDataCollectionArray:(NSArray *)dataCollectionArray
{
    if (![dataCollectionArray isKindOfClass:[NSNull class]] && dataCollectionArray.count > 0) {
        [DONG_UserDefaults setObject:dataCollectionArray forKey:kDataCollectionArray];
        [DONG_UserDefaults synchronize];
    }
}

/*
 *  保存操作记录
 *
 *  每满10条上传给服务器 删空数据
 */
- (void)addCollectionDataWithType:(NSString *)type filmName:(NSString *)filmName mid:(NSString *)mid
{
    // 格林尼治时间
    NSDate *date = [NSDate date];
    // 当前时间的时间戳
    NSInteger nowTimeStap = [NSDate timeStampFromDate:date];
    NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)nowTimeStap];
    NSDictionary *paramDict = @{@"type" : type? type : @"",
                                @"time" : timeStr,
                                @"value" : @{@"data" : @{
                                                     @"dataType" : @"yp",
                                                     @"FilmName" : filmName? filmName : @"",
                                                     @"Mid" : mid? mid : @"",
                                                     }
                                             }
                                };
    
    // NSUserDefaults 只能读取不可变对象 可变对象可以写入
    NSArray *oldArray = [DONG_UserDefaults objectForKey:kDataCollectionArray];
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:oldArray];
    [mutableArray addObject:paramDict];
    [DONG_UserDefaults setObject:mutableArray forKey:kDataCollectionArray];
    [DONG_UserDefaults synchronize];
    NSMutableArray *newArr = [DONG_UserDefaults objectForKey:kDataCollectionArray];
    //        DONG_Log(@"newNewArr-->%@ \n newNewArr.count-->%lu", newArr, (unsigned long)newArr.count);
    
    if (newArr.count >= 10) {
        const NSString *uuidStr = [HLJUUID getUUID];
        NSDictionary *parameters = @{@"param" : @{
                                             @"data" : newArr,
                                             @"user" : @{
                                                     @"id" : @"6666699999" // 用户id主键
                                                     },
                                             @"terminal" : @{
                                                     @"id" : uuidStr, // 设备id
                                                     @"mac" : uuidStr, // 设备uuid地址
                                                     @"deviceType" : @"iOSMobile"
                                                     }
                                             }};
        
        //        NSString *urlStr = @"http://172.16.5.54:8090/appjh_mmserver/gather/addDatasIos.do"; // 吕本健
        //NSString *urlStr = @"http://10.177.4.81:8080/appjh_mmserver/gather/addDatasIos.do"; // 黑网内网
        [requestDataManager postRequestJsonDataWithUrl:CollectCustomerBehaviorData parameters:parameters success:^(id  _Nullable responseObject) {
            
            DONG_Log(@"responseObject-->%@", responseObject);
            [DONG_UserDefaults removeObjectForKey:kDataCollectionArray];
            
        } failure:^(id  _Nullable errorObject) {
            
            DONG_Log(@"errorObject-->%@", errorObject);
            if (newArr.count >= 12) {
                [DONG_UserDefaults removeObjectForKey:kDataCollectionArray];
            }
        }];
    }
}


// 移除本地用户信息
- (void)removeUserInfo
{
    UserInfoManager.isLogin = NO;
    [DONG_UserDefaults removeObjectForKey:kLovelyBabyToken];
    [DONG_UserDefaults removeObjectForKey:kLovelyBabyMemberId];
    [DONG_UserDefaults removeObjectForKey:kLovelyBabyMobilePhone];
    
    [DONG_UserDefaults removeObjectForKey:kMobilePhone];
    [DONG_UserDefaults removeObjectForKey:kServiceCode];
    [DONG_UserDefaults removeObjectForKey:kCustomerLevel];
//    [DONG_UserDefaults removeObjectForKey:kProductList];
    
    
}

@end
