//
//  Dong_DownloadOperation.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/11/9.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Dong_DownloadModel;

@interface NSURLSessionTask (DownloadModel)

// 为了更方便去获取，而不需要遍历，采用扩展的方式，可直接提取，提高效率
@property (nonatomic, weak) Dong_DownloadModel *downloadModel;

@end



@interface Dong_DownloadOperation : NSOperation

- (instancetype)initWithModel:(Dong_DownloadModel *)model session:(NSURLSession *)session;

@property (nonatomic, weak) Dong_DownloadModel *model;
@property (nonatomic, strong, readonly) NSURLSessionDownloadTask *downloadTask;

- (void)suspend;
- (void)resume;
- (void)downloadFinished;

@end
