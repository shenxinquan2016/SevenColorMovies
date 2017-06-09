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
- (void)addCollectionDataWithType:(NSString *)type filmName:(NSString *)fimlName mid:(NSString *)mid
{
    // 格林尼治时间
    NSDate *date = [NSDate date];
    // 当前时间的时间戳
    NSInteger nowTimeStap = [NSDate timeStampFromDate:date];
    NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)nowTimeStap];
    NSDictionary *paramDict = @{@"type" : type,
                                @"time" : timeStr,
                                @"value" : @{@"data" : @{
                                                     @"dataType" : @"yp",
                                                     @"FilmName" : fimlName,
                                                     @"Mid" : mid,
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

        //NSString *urlStr = @"http://172.16.5.54:8090/mmserver/gather/addDatasIos.do"; // 吕本健
        //NSString *urlStr = @"http://10.177.4.81:8080/appjh_mmserver/gather/addDatasIos.do"; // 黑网内网
        [requestDataManager postRequestJsonDataWithUrl:CollectCustomerBehaviorData parameters:parameters success:^(id  _Nullable responseObject) {
            
            DONG_Log(@"responseObject-->%@", responseObject);
            [DONG_UserDefaults removeObjectForKey:kDataCollectionArray];
            
        } failure:^(id  _Nullable errorObject) {
            
            DONG_Log(@"errorObject-->%@", errorObject);
            [DONG_UserDefaults removeObjectForKey:kDataCollectionArray];
        }];
    }
}


@end
