//
//  SCNetRequsetManger+Home.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/27.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCNetRequsetManger+Home.h"
#import <objc/runtime.h>

static void *strKey = &strKey;

@implementation SCNetRequsetManger (Home)

-(void)setMyString:(NSString *)myString
{
    objc_setAssociatedObject(self, &strKey, myString, OBJC_ASSOCIATION_COPY);
}

-(NSString *)myString
{
    return objc_getAssociatedObject(self, &strKey);
}


@end
