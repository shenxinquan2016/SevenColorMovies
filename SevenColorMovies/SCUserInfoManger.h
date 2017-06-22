//
//  SCUserInfoManger.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/27.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UserInfoManager [SCUserInfoManger shareManager]

@interface SCUserInfoManger : NSObject

/** 用户是否登录 */
@property (nonatomic, assign) BOOL isLogin;
/** 用户token */
@property (nonatomic, copy) NSString *token;
/** 萌娃是否登录 */
@property (nonatomic, assign) BOOL lovelyBabyIsLogin;
/** 萌娃token */
@property (nonatomic, copy) NSString *lovelyBabyToken;
/** 萌娃用户id */
@property (nonatomic, copy) NSString *lovelyBabyMemberId;

@property (nonatomic, copy) NSArray *dataCollectionArray;


+ (instancetype)shareManager;

// 移除本地用户信息
- (void)removeUserInfo;

/*
 *  保存操作记录
 *
 *  每满10条上传给服务器 删空数据
 */
- (void)addCollectionDataWithType:(NSString *)type filmName:(NSString *)filmName mid:(NSString *)mid;

@end
