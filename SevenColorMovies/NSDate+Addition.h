//
//  NSDate+Addition.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/23.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Addition)

// 当前日期类转换成时间戳
- (NSString *)getTimeStamp;

// 时间戳转换成NSDate对象
+ (NSDate *)getDateWithTimeStamp:(NSString *)timeStamp;


@end
