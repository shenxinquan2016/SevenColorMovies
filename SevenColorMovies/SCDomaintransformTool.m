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
//        DONG_Log(@"responseObject:%@",responseObject);
        self.domainNameArray = responseObject[@"Data"][@"UrlList"][@"Url"];
        if (_domainNameArray.count) {
            for (NSDictionary *dic in _domainNameArray) {
                
                if ([urlString containsString:dic[@"_Key"]]) {
                    //DONG_Log(@"urlString:%@",urlString);
                    NSString *tempString = dic[@"SourceUrl"];
                    NSString *domainString = [[tempString componentsSeparatedByString:@"//"] lastObject];
                    NSString *newUrlString = [urlString stringByReplacingOccurrencesOfString:dic[@"_Key"] withString:domainString];
                    DONG_Log(@"newUrlString:%@",newUrlString);
                    
                    success(newUrlString);
                    break;
                }
            }
        }
        
    } failure:^(id  _Nullable errorObject) {
        
        faild(errorObject);
    }];
    
}



@end
