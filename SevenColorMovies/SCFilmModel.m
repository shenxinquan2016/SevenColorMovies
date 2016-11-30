//
//  SCFilmModel.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/28.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCFilmModel.h"

@implementation SCFilmModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"SourceURL":@"_SourceUrl"};
    
}

//忽略的字段
+ (NSArray *)ignoredProperties {
    return @[@"showDeleteBtn", @"selected", @"playtime"];
}


@end
