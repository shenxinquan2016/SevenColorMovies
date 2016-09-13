//
//  HLJRequest.h
//  HLJXmlResqust
//
//  Created by Kevin on 16/4/12.
//  Copyright © 2016年 kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^XMLParseIPSuccess)(NSString *newVideoUrl);
typedef void(^XMLParseIPFailure)(NSError *error);

@interface HLJRequest : NSObject

/**
 *  创建带有域名的request
 *
 *  @param domainName 要解析的域名
 *
 *  @return request
 */
+ (instancetype)requestWithPlayVideoURL:(NSString *)videoURL;

/**
 *  第一次调用接口（请求替换的信息并根据初始化时候的videoURL来进行替换）
 *
 *  @param parseSuccess 成功回调
 *  @param parseFailure 失败回调
 */
- (void)getNewVideoURLSuccess:(XMLParseIPSuccess )parseSuccess
                      failure:(XMLParseIPFailure )parseFailure;

/**
 *  根据原播放串获得新播放串（已经获得替换信息之后）
 *
 *  @param videoURL 原播放串
 *
 *  @return 新播放串
 */
- (NSString *)getNewViedoURLByOriginVideoURL:(NSString *)videoURL;

@end
