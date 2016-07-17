//
//  SCNetUrlManger.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/15.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCNetUrlManger.h"

#define kSearchPort @"searchPort"
#define kCommonPort @"commonPort"
#define kPayPort @"payPort"
#define kDomainName @"domainName"

@implementation SCNetUrlManger

// shareManager
+(instancetype)shareManager {
    static SCNetUrlManger *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SCNetUrlManger alloc] init];
    });
    return manager;
}


//========================================== getter  ==========================================
- (void)setDomainName:(NSString *)domainName {
    if (![domainName isKindOfClass:[NSNull class]]) {
        [[NSUserDefaults standardUserDefaults] setObject:domainName forKey:kDomainName];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (NSString *)domainName {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kDomainName];
    
    
}


//========================================== searchPort  ==========================================
#pragma mark - setter

- (void)setSearchPort:(NSString *)searchPort{
    if (![searchPort isKindOfClass:[NSNull class]]) {
        [[NSUserDefaults standardUserDefaults] setObject:searchPort forKey:kSearchPort];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (NSString *)searchPort{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kSearchPort];
}


//========================================== commonPort  ==========================================


- (void)setCommonPort:(NSString *)commonPort{
    if (![commonPort isKindOfClass:[NSNull class]]) {
        [[NSUserDefaults standardUserDefaults] setObject:commonPort forKey:kCommonPort];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (NSString *)commonPort{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kCommonPort];
}


//========================================== payPort  ==========================================
- (void)setPayPort:(NSString *)payPort {
    if (![payPort isKindOfClass:[NSNull class]]) {
        [[NSUserDefaults standardUserDefaults] setObject:payPort forKey:kPayPort];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

- (NSString *)payPort {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kPayPort];
    
}


@end
