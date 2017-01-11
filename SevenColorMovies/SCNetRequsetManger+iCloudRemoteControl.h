//
//  SCNetRequsetManger+iCloudRemoteControl.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/12/22.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  语音识别服务器网络通信工具类

#import "SCNetRequsetManger.h"

@interface SCNetRequsetManger (iCloudRemoteControl)

- (void)postRequestDataToCloudRemoteControlServerWithUrl:(nullable NSString *)urlString parameters:(nullable id)parameters success:(nullable void(^)(id _Nullable responseObject))success failure:(nullable void(^)(id _Nullable errorObject))faild;


- (void)postDataToCloudRemoteControlServerWithUrl:(nullable NSString *)urlString parameters:(nullable id)parameters success:(nullable void(^)(id _Nullable responseObject))success failure:(nullable void(^)(id _Nullable errorObject))faild;

@end
