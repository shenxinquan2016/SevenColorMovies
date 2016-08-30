//
//  SCRotatoUtil.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/18.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  强制切换横竖屏

#import "SCRotatoUtil.h"

@implementation SCRotatoUtil

+ (void)forceOrientation: (UIInterfaceOrientation)orientation {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget: [UIDevice currentDevice]];
        int val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

@end