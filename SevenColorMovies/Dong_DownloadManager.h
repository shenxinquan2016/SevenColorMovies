//
//  Dong_DownloadManager.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/11/9.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  下载管理器

#import <Foundation/Foundation.h>

@class Dong_DownloadModel;

@interface Dong_DownloadManager : NSObject

@property (nonatomic, readonly, strong) NSArray *downloadModels;

/**
 *  下载管理器单例
 *
 *  @return 返回唯一的实例
 */
+ (instancetype)sharedManager;

/**
 *
 *
 *  @param  downloadModels 存储下载模型的数组
 */
- (void)addVideoModels:(NSArray<Dong_DownloadModel *> *)downloadModels;

/**
 *  开始下载
 *
 *  @param  downloadModel 下载的数据模型
 */
- (void)startWithVideoModel:(Dong_DownloadModel *)downloadModel;

/**
 *  暂停下载
 *
 *  @param  downloadModel 下载的数据模型
 */
- (void)suspendWithVideoModel:(Dong_DownloadModel *)downloadModel;

/**
 *  重新下载
 *
 *  @param  downloadModel 下载的数据模型
 */
- (void)resumeWithVideoModel:(Dong_DownloadModel *)downloadModel;

/**
 *  停止下载
 *
 *  @param  downloadModel 下载的数据模型
 */
- (void)stopWithVideoModel:(Dong_DownloadModel *)downloadModel;

/**
 *  全部暂停
 *
 */

/**
 *  全部开始
 *
 */



@end
