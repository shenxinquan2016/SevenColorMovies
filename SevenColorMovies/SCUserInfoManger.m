//
//  SCUserInfoManger.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/27.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCUserInfoManger.h"


#define kIsLogin @"kIsLogin"// 登录状态
#define kToken @"kToken" // token
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
- (void)addCollectionDataWithDict:(NSDictionary *)dict
{
    if (![dict isKindOfClass:[NSNull class]] && dict.allKeys.count > 0) {
        // NSUserDefaults 只能读取不可变对象 可变对象可以写入
        NSArray *oldArray = [DONG_UserDefaults objectForKey:kDataCollectionArray];
        NSMutableArray *newArray = [NSMutableArray arrayWithArray:oldArray];
        [newArray addObject:dict];
        [DONG_UserDefaults setObject:newArray forKey:kDataCollectionArray];
        [DONG_UserDefaults synchronize];
        
        NSMutableArray *newNewArr = [DONG_UserDefaults objectForKey:kDataCollectionArray];
        DONG_Log(@"newNewArr-->%@ \n newNewArr.count-->%lu", newNewArr, (unsigned long)newNewArr.count);
        if (newNewArr.count == 10) {
            [DONG_UserDefaults removeObjectForKey:kDataCollectionArray];
        }
    }
}

@end
