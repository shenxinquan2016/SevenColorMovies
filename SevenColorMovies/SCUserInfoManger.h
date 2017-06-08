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
/** 用户是否登录 */
@property (nonatomic, copy) NSString *token;

@property (nonatomic, copy) NSArray *dataCollectionArray;


+ (instancetype)shareManager;

/*
 *  保存操作记录
 *
 *  每满10条上传给服务器 删空数据
 */
- (void)addCollectionDataWithType:(NSString *)type filmName:(NSString *)fimlName mid:(NSString *)mid;

@end
