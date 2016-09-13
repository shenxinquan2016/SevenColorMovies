//
//  HLJKeychainStore.h
//  HLJVideoApp
//
//  Created by admin on 16/3/26.
//  Copyright © 2016年 EasonChan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLJKeychainStore : NSObject

+ (void)save:(NSString *)service data:(id )data;

+ (id)load:(NSString *)service;

+ (void)deleteKeyData:(NSString *)service;

@end
