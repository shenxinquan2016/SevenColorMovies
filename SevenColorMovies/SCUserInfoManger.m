//
//  SCUserInfoManger.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/27.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCUserInfoManger.h"


#define kIsLogin @"kIsLogin"//登录状态
#define kToken @"kToken" // token

@implementation SCUserInfoManger

+(instancetype)shareManager {
    static SCUserInfoManger *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SCUserInfoManger alloc] init];
    });
    return manager;
}

//******************☝️☝️☝️☝️☝️☝️☝️☝️setter 方法☝️☝️☝️☝️☝️☝️☝️☝️****************
- (void)setIsLogin:(BOOL)isLogin {
    [[NSUserDefaults standardUserDefaults] setBool:isLogin forKey:kIsLogin];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// token add 20160516
- (void)setToken:(NSString *)token {
    if (![token isKindOfClass:[NSNull class]] && token.length > 0) { // 如果存在保存token
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:kToken];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}




//******************☝️☝️☝️☝️☝️☝️☝️☝️getter 方法☝️☝️☝️☝️☝️☝️☝️☝️****************
- (BOOL)isLogin {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
}

- (NSString *)token {
    return [[NSUserDefaults standardUserDefaults]  objectForKey:kToken];
}
@end
