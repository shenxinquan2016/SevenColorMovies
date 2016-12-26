//
//  DNIPhoneInfo.h
//  ReadyGo
//
//  Created by LTL on 15/12/22.
//  Copyright © 2015年 GC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sys/utsname.h"

@interface DNIPhoneInfo : NSObject
+ (NSString *)deviceType; /**< 获取iPhone具体型号：iPhone6s等 */
+ (NSString *)deviceIOSVersion; /**< ios版本具体版本：iOS9.2 */

@end
