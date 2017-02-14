//
//  SCDomaintransformTool.h
//  SevenColorMovies
//
//  Created by yesdgq on 2017/2/13.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCDomaintransformTool : NSObject

- (void)getNewDomainByUrlString:(nullable NSString *)urlString key:(nullable NSString *)key success:(nullable void(^)(id _Nullable newUrlString))success failure:(nullable void(^)(id _Nullable errorObject))faild;

- (nullable NSString *)getNewViedoURLByUrlString:(nullable NSString *)urlString key:(nullable NSString *)key;

@end
