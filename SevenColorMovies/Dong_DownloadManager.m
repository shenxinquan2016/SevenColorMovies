//
//  Dong_DownloadManager.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/11/9.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  下载管理器

#import "Dong_DownloadManager.h"
#import "Dong_DownloadModel.h"
#import "Dong_DownloadOperation.h"


@interface Dong_DownloadManager ()<NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) NSURLSession *session;

@end

@implementation Dong_DownloadManager

{
    NSMutableArray *_downloadModels;
}

/**
 *  下载管理器单例
 *
 *  @return 返回唯一的实例
 */
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static Dong_DownloadManager *downloadManager = nil;
    dispatch_once(&onceToken, ^{
        downloadManager = [[self alloc] init];
    });
    
    return downloadManager;
}

- (instancetype)init {
    if (self = [super init]) {
        _downloadModels = [[NSMutableArray alloc] init];
        self.queue = [[NSOperationQueue alloc] init];
        // 设置允许最大线程并行数量
        self.queue.maxConcurrentOperationCount = 4;
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        // delegateQueue不能传self.queue 可以传[NSOperationQueue mainQueue]
        self.session = [NSURLSession sessionWithConfiguration:config
                                                     delegate:self
                                                delegateQueue:nil];
    }
    return self;
}

- (NSArray *)downloadModels {
    return _downloadModels;
}

/**
 *  添加视频模型，只是添加并不会下载
 *
 *  @param  downloadModels 要添加的下载模型的数组
 */
- (void)addVideoModels:(NSArray<Dong_DownloadModel *> *)downloadModels {
    if ([downloadModels isKindOfClass:[NSArray class]]) {
        [_downloadModels addObjectsFromArray:downloadModels];
    }
}

/**
 *  开始下载
 *
 *  @param  downloadModel 下载的数据模型
 */
- (void)startWithVideoModel:(Dong_DownloadModel *)downloadModel {
    if (downloadModel.downloadStatus != kDownloadStateCompleted) {
        downloadModel.downloadStatus = kDownloadStateDownloading;
        
        if (downloadModel.operation == nil) {
            downloadModel.operation = [[Dong_DownloadOperation alloc] initWithModel:downloadModel
                                                                    session:self.session];
            [self.queue addOperation:downloadModel.operation];
            [downloadModel.operation start];
        } else {
            [downloadModel.operation resume];
        }
    }
}

/**
 *  暂停下载
 *
 *  @param  downloadModel 下载的数据模型
 */
- (void)suspendWithVideoModel:(Dong_DownloadModel *)downloadModel {
    if (downloadModel.downloadStatus != kDownloadStateCompleted) {
        [downloadModel.operation suspend];
    }
}

/**
 *  恢复下载
 *
 *  @param  downloadModel 下载的数据模型
 */
- (void)resumeWithVideoModel:(Dong_DownloadModel *)downloadModel {
    if (downloadModel.downloadStatus != kDownloadStateCompleted) {
        [downloadModel.operation resume];
    }
}

/**
 *  停止下载
 *
 *  @param  downloadModel 下载的数据模型
 */
- (void)stopWithVideoModel:(Dong_DownloadModel *)downloadModel {
    if (downloadModel.operation) {
        [downloadModel.operation cancel];
    }
}

/**
 *  全部暂停
 *
 */
- (void)pauseAll{
    
}

/**
 *  全部开始
 *
 */
- (void)resumeAll{
    
}

#pragma mark - NSURLSessionDownloadDelegate
/**
 *  下载完成时回调
 *
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    
    //本地的文件路径，使用fileURLWithPath:来创建
    if (downloadTask.downloadModel.localPath) {
        NSURL *toURL = [NSURL fileURLWithPath:downloadTask.downloadModel.localPath];
        NSFileManager *manager = [NSFileManager defaultManager];
        [manager moveItemAtURL:location toURL:toURL error:nil];
    }
    
    [downloadTask.downloadModel.operation downloadFinished];
    NSLog(@"path = %@", downloadTask.downloadModel.localPath);
}

/*
 *  下载失败或者成功时，会回调。其中失败有可能是暂停下载导致，所以需要做一些判断
 *  当传输失败网络异常会接收到下面的回调函数，可以从error中获取resumeData
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (error == nil) {
            task.downloadModel.downloadStatus = kDownloadStateCompleted;
            [task.downloadModel.operation downloadFinished];
        }  else if ([error code] < 0) {
            if (task.downloadModel.downloadStatus == kDownloadStatePause) {
                // 暂停
                task.downloadModel.downloadStatus = kDownloadStatePause;
                if (error.userInfo && [error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData]) {
                    //self.resumeData = [error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData];
                }
            } else{
                // 网络异常
                task.downloadModel.downloadStatus = kDownloadStateFailed;
                if (error.userInfo && [error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData]) {
                    //self.resumeData = [error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData];
                }
            }
           
        }
    });
}


/*
 *  下载过程调用
 *
 *  bytesWritten               当前次的下载量
 *  totalBytesWritten          当前的下载总量
 *  totalBytesExpectedToWrite  需下载总量
 */
- (void)URLSession:(NSURLSession *)session
downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
    DONG_Log(@"resumeData:%lld",totalBytesExpectedToWrite);
    
    double byts =  totalBytesWritten * 1.0 / 1024 / 1024;
    double total = totalBytesExpectedToWrite * 1.0 / 1024 / 1024;
    NSString *text = [NSString stringWithFormat:@"%.1lfMB/%.1fMB",byts,total];
    CGFloat progress = totalBytesWritten / (CGFloat)totalBytesExpectedToWrite;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        downloadTask.downloadModel.progressText = text;
        downloadTask.downloadModel.progress = progress;
    });
}

/*
 *  resume恢复下载时，会回调一次这里，更新进度
 *
 *  fileOffset          已下载数量
 *  expectedTotalBytes  需下载总量
 */
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes {
    
    double byts =  fileOffset * 1.0 / 1024 / 1024;
    double total = expectedTotalBytes * 1.0 / 1024 / 1024;
    NSString *text = [NSString stringWithFormat:@"%.1lfMB/%.1fMB",byts,total];
    CGFloat progress = fileOffset / (CGFloat)expectedTotalBytes;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        downloadTask.downloadModel.progressText = text;
        downloadTask.downloadModel.progress = progress;
    });
}

@end
