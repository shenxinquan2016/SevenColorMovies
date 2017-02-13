//
//  SCDomaintransformTool.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/2/13.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import "SCDomaintransformTool.h"

@interface SCDomaintransformTool ()

@property (nonatomic, copy) NSArray *domainNameArray;

@end

@implementation SCDomaintransformTool

- (void)getNewDomainByUrlString:(nullable NSString *)urlString success:(nullable void(^)(id _Nullable newUrlString))success failure:(nullable void(^)(id _Nullable errorObject))faild
{
    [requestDataManager requestDataWithUrl:DynamicDomainEntrance parameters:nil success:^(id  _Nullable responseObject) {
        
         self.domainNameArray = responseObject[@"Data"][@"UrlList"][@"Url"];
        if (_domainNameArray.count) {
            for (NSDictionary *dic in _domainNameArray) {
                
                if ([urlString containsString:dic[@"Name"]]) {
                    DONG_Log(@"urlString:%@",urlString);
                    [urlString stringByReplacingOccurrencesOfString:dic[@"Name"] withString:dic[@"SourceUrl"]];
                    DONG_Log(@"urlString:%@",urlString);
                    DONG_Log(@"domain:%@",dic[@"SourceUrl"]);
                    success(urlString);
                    break;
                }
            }
        }
        
    } failure:^(id  _Nullable errorObject) {
        
        faild(errorObject);
    }];

}



@end
