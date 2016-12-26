//
//  DNIPhoneInfo.m
//  ReadyGo
//
//  Created by LTL on 15/12/22.
//  Copyright © 2015年 GC. All rights reserved.
//

#import "DNIPhoneInfo.h"

@implementation DNIPhoneInfo

+ (NSString*)deviceType
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,2"])   return @"iPhone 5";
    
    if ([deviceString isEqualToString:@"iPhone5,3"] || [deviceString isEqualToString:@"iPhone5,4"])
        return @"iPhone 5C";
    
    if ([deviceString isEqualToString:@"iPhone6,1"]
        || [deviceString isEqualToString:@"iPhone6,2"])
        return @"iPhone 5S";
    
    if ([deviceString isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([deviceString isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6S";
    
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6S Plus";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    return deviceString;
}

+ (NSString *)deviceIOSVersion{
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    systemVersion = [@"iOS" stringByAppendingString:systemVersion];
    return systemVersion;
}
@end
