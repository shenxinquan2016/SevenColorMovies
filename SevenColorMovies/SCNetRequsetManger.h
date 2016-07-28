//
//  SCNetRequsetManger.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/27.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <Foundation/Foundation.h>

#define requestDataManager [SCNetRequsetManger shareManager]

NS_ASSUME_NONNULL_BEGIN

@interface SCNetRequsetManger : NSObject

+ (instancetype _Nullable)shareManager;

//******************☝️☝️☝️☝️☝️☝️☝️☝️下面为某个需要调用的方法☝️☝️☝️☝️☝️☝️☝️☝️****************

/**
 *  GET 或则 POST 请求根据自己的需求来定
 *
 *  @param urlString     请求的url（某个特定接口可以写在此方法内不需要传过来）
 *  @param parameters    请求的参数 (某个特定接口可以写在此方法内不需要传递过来)
 *  @param modelType     数据模型 （返回的数据需要转换的模型）
 *  @param success       成功的返回 （如果模型存在，成功后直接返回模型数组）
 *  @param faild         失败的返回
 */


- (void)requestDataWithModelType:(nullable id)modelType success:(nullable void(^)(id _Nullable responseObject))success failure:(nullable void(^)(id _Nullable errorObject))faild;






/** 首页数据请求 get */
- (void)requestHomePageDataWithUrl:(nullable NSString *)urlString parameters:(nullable NSDictionary *)parameters success:(nullable void(^)(id _Nullable responseObject))success failure:(nullable void(^)(id _Nullable errorObject))faild;








@end

NS_ASSUME_NONNULL_END
