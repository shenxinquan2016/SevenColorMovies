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

- (void)getNewDomainByUrlString:(nullable NSString *)urlString key:(nullable NSString *)key success:(nullable void(^)(id _Nullable newUrlString))success failure:(nullable void(^)(id _Nullable errorObject))faild
{
    [requestDataManager requestDataWithUrl:DynamicDomainEntrance parameters:nil success:^(id  _Nullable responseObject) {
//        DONG_Log(@"responseObject:%@",responseObject);
        self.domainNameArray = responseObject[@"Data"][@"UrlList"][@"Url"];
        if (_domainNameArray.count) {
            for (NSDictionary *dic in _domainNameArray) {
                
                if ([key isEqualToString:dic[@"_Key"]]) {
                    //DONG_Log(@"urlString:%@",urlString);
                    NSString *tempString = dic[@"SourceUrl"];
                    
                    NSString *newUrlString = [tempString stringByAppendingString:urlString];
                    //DONG_Log(@"newUrlString:%@",newUrlString);
                    
                    success(newUrlString);
                    break;
                }
            }
        }
        
    } failure:^(id  _Nullable errorObject) {
        
        faild(errorObject);
    }];
    
}


- (nullable NSString *)getNewViedoURLByUrlString:(nullable NSString *)urlString key:(nullable NSString *)key
{
    if (_domainNameArray.count) {
        for (NSDictionary *dic in _domainNameArray) {
            
            if ([key isEqualToString:dic[@"_Key"]]) {
                //DONG_Log(@"urlString:%@",urlString);
                NSString *tempString = dic[@"SourceUrl"];
                
                NSString *newUrlString = [tempString stringByAppendingString:urlString];
                //DONG_Log(@"newUrlString:%@",newUrlString);
                
                return newUrlString;
                break;
            }
        }
    }
    return @"";
}


@end