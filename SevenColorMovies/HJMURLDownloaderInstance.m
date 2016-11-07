//
//  HJMURLDownloaderInstance.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/11/7.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "HJMURLDownloaderInstance.h"

@implementation HJMURLDownloaderInstance

static id sharedManager = nil;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] initBackgroundDownloaderWithIdentifier:@"" maxConcurrentDownloads:1 OnlyWiFiAccess:NO];
    });
    return sharedManager;
}

- (HJMURLDownloadManager *)downloadManager {
    return sharedManager;
}



@end
