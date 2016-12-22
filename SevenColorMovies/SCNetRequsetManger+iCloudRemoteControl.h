//
//  SCNetRequsetManger+iCloudRemoteControl.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/12/22.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCNetRequsetManger.h"

@interface SCNetRequsetManger (iCloudRemoteControl)

- (void)postRequestDataToCloudRemoteControlServerWithUrl:(nullable NSString *)urlString parameters:(nullable NSDictionary *)parameters success:(nullable void(^)(id _Nullable responseObject))success failure:(nullable void(^)(id _Nullable errorObject))faild;

@end
