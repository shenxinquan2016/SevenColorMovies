//
//  HLJUUID.m
//  HLJVideoApp
//
//  Created by admin on 16/3/26.
//  Copyright © 2016年 EasonChan. All rights reserved.
//

#import "HLJUUID.h"
#import "HLJKeychainStore.h"

static NSString *const KEY_USERNAME_PASSWORD = @"KEY_USERNAME_PASSWORD";

@implementation HLJUUID

+ (NSString *)getUUID{
    
    NSString *uuidStr = [HLJKeychainStore load:KEY_USERNAME_PASSWORD];
    
    if ([uuidStr isEqualToString:@""] || !uuidStr) {
        
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        
        uuidStr = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuidRef));
        
        CFRelease(uuidRef);
        
        [HLJKeychainStore save:KEY_USERNAME_PASSWORD data:uuidStr];
    }
    
    return [uuidStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

@end
