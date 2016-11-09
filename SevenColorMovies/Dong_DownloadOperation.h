//
//  Dong_DownloadOperation.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/11/9.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  下载类

#import <Foundation/Foundation.h>

@class Dong_DownloadModel;

@interface NSURLSessionTask (DownloadModel)

// 为了更方便去获取，而不需要遍历，采用扩展的方式，可直接提取，提高效率
@property (nonatomic, weak) Dong_DownloadModel *downloadModel;

@end


@interface Dong_DownloadOperation : NSOperation

- (instancetype)initWithModel:(Dong_DownloadModel *)downloadModel session:(NSURLSession *)session;

@property (nonatomic, weak) Dong_DownloadModel *model;
@property (nonatomic, strong, readonly) NSURLSessionDownloadTask *downloadTask;

- (void)suspend;//暂停下载
- (void)resume;//恢复下载
- (void)downloadFinished;//下载完成时调用

@end
