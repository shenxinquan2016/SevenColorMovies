//
//  SCDomaintransformTool.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/2/13.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import "SCDomaintransformTool.h"

@interface SCDomaintransformTool ()

@property (nonatomic, strong) NSMutableArray *domainNameArray;

@end

@implementation SCDomaintransformTool

- (instancetype)init {
    if (self = [super init]) {
        self.domainNameArray = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)getNewDomainByUrlString:(nullable NSString *)urlString key:(nullable NSString *)key success:(nullable void(^)(id _Nullable newUrlString))success failure:(nullable void(^)(id _Nullable errorObject))faild
{
    const NSString *uuidStr = [HLJUUID getUUID];
    
    NSDictionary *patameters = @{@"hid" : uuidStr};
    [[[SCNetRequsetManger alloc] init] requestDataWithUrl:DynamicDomainEntrance parameters:patameters success:^(id  _Nullable responseObject) {
        //DONG_Log(@"responseObject:%@",responseObject);
        [_domainNameArray removeAllObjects];
        [_domainNameArray addObjectsFromArray:responseObject[@"Data"][@"UrlList"][@"Url"]];
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
    if (self.domainNameArray.count) {
        for (NSDictionary *dic in _domainNameArray) {
            
            if ([key isEqualToString:dic[@"_Key"]]) {
                //DONG_Log(@"urlString:%@",urlString);
                NSString *tempString = dic[@"SourceUrl"];
                
                NSString *newUrlString = [tempString stringByAppendingString:urlString];
                DONG_Log(@"newUrlString:%@",newUrlString);
                
                return newUrlString;
                break;
            }
        }
    }
    return @"";
}


@end
