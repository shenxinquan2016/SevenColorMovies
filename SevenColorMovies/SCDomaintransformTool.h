//
//  SCDomaintransformTool.h
//  SevenColorMovies
//
//  Created by yesdgq on 2017/2/13.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCDomaintransformTool : NSObject

- (void)getNewDomainByUrlString:(nullable NSString *)urlString success:(nullable void(^)(id _Nullable newUrlString))success failure:(nullable void(^)(id _Nullable errorObject))faild;

@end
