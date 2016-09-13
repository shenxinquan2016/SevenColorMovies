//
//  HLJKeychainStore.m
//  HLJVideoApp
//
//  Created by admin on 16/3/26.
//  Copyright © 2016年 EasonChan. All rights reserved.
//

#import "HLJKeychainStore.h"

@implementation HLJKeychainStore

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service{
    
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            service,(id)kSecAttrService,
            service,(id)kSecAttrAccount,
            (id)kSecAttrAccessibleWhenUnlocked,(id)kSecAttrAccessible,
            nil];
}

+ (void)save:(NSString *)service data:(id)data{
    
    NSMutableDictionary *keychainQuery = [NSMutableDictionary dictionaryWithDictionary:[self getKeychainQuery:service]];
    //添加新item之前先删除旧item
    SecItemDelete((CFDictionaryRef)keychainQuery);
    
    //在字典中添加新的键值对
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    
    //在keychain中添加新的item
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}

+ (id)load:(NSString *)service{
    
    id uniFlag = nil;
    
    NSMutableDictionary *keychainQuery = [NSMutableDictionary dictionaryWithDictionary:[self getKeychainQuery:service]];
    
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    
    CFDataRef keydata = NULL;
    
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery,(CFTypeRef *)&keydata) == noErr) {
        
        uniFlag = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData*)keydata];
    }
    
    return uniFlag;
}

+ (void)deleteKeyData:(NSString *)service{
    
    NSMutableDictionary *keychainQuery = [NSMutableDictionary dictionaryWithDictionary:[self getKeychainQuery:service]];
    
    SecItemDelete((CFDictionaryRef )keychainQuery);
}

@end
