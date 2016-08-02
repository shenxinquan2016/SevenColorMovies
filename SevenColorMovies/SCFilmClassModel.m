//
//  SCFilmClassModel.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/28.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCFilmClassModel.h"

@implementation SCFilmClassModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"filmClassArray":@"FilmClass",
             @"filmArray":@"Film"};
    
}


+ (NSDictionary *)objectClassInArray{
    return @{
             @"filmClassArray" : @"SCFilmClassModel",
             @"filmArray" : @"SCFilmModel",

             };
}


@end
