//
//  NSDate+Addition.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/23.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "NSDate+Addition.h"

@implementation NSDate (Addition)

// 日期类转换成时间戳
- (NSString *)getTimeStamp{
    return [NSString stringWithFormat:@"%lf", [self timeIntervalSince1970]];
}

// 时间戳转换成NSDate对象
+ (NSDate *)getDateWithTimeStamp:(NSString *)timeStamp {
    NSString *arg = timeStamp;
    
    if (![timeStamp isKindOfClass:[NSString class]]) {
        arg = [NSString stringWithFormat:@"%@", timeStamp];
    }
    
    NSTimeInterval time = [timeStamp doubleValue];
    //也要基于1970年计算
    return [NSDate dateWithTimeIntervalSince1970:time];
}




@end
