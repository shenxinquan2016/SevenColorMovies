//
//  downloadManager.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/11/7.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  下载管理器

#import <Foundation/Foundation.h>

@interface downloadManager : NSObject

/**
 *  下载管理器单例
 *
 *  @return 返回唯一的实例
 */
+ (instancetype)sharedManager;

/**
 *  下载操作
 *
 *  @param url           要下载的url
 *  @param progressBlock 进度回调
 *  @param complete      完成回调
 */
- (void)downloadWith:(NSURL *)url cacheFilePath:(NSString *)filePath pregressBlock:(void (^)(CGFloat progress))progressBlock complete:(void(^)(NSString *path,NSError *error))complete;


@end
