//
//  NSDate+Addition.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/23.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "NSDate+Addition.h"

@implementation NSDate (Addition)

// 当前日期类转换成时间戳
- (NSString *)getTimeStamp{
    return [NSString stringWithFormat:@"%lf", [self timeIntervalSince1970]];//获取当前的秒数（毫秒需*1000 微秒需*1000*1000）
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

// 字符串转NSDate
+ (NSDate *)dateFromString:(NSString *)timeStr
                    format:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSDate *date = [dateFormatter dateFromString:timeStr];
    return date;
}

// NSDate转时间戳
+ (NSInteger)timestampFromDate:(NSDate *)date
{
    return (long)[date timeIntervalSince1970];
}

// 字符串转时间戳
+(NSInteger)timestampFromString:(NSString *)timeStr
                          format:(NSString *)format
{
    NSDate *date = [NSDate dateFromString:timeStr format:format];
    return [NSDate timestampFromDate:date];
}

// 时间戳转字符串
+ (NSString *)dateStrFromTimeStampTime:(NSInteger)timeStamp
                     withDateFormat:(NSString *)format
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    return [NSDate dateStringFromDate:date withDateFormat:format];
}

// NSDate转字符串
+ (NSString *)dateStringFromDate:(NSDate *)date
               withDateFormat:(NSString *)format
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    return [dateFormat stringFromDate:date];
}




@end
