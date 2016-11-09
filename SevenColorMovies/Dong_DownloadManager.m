//
//  Dong_DownloadManager.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/11/9.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "Dong_DownloadManager.h"
#import "Dong_DownloadModel.h"
#import "Dong_DownloadOperation.h"

static Dong_DownloadManager *downloadManager = nil;

@interface Dong_DownloadManager ()<NSURLSessionDownloadDelegate> {
    NSMutableArray *_downloadModels;
}

@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) NSURLSession *session;


@end

@implementation Dong_DownloadManager

/**
 *  下载管理器单例
 *
 *  @return 返回唯一的实例
 */
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downloadManager = [[self alloc] init];
    });
    
    return downloadManager;
}

- (instancetype)init {
    if (self = [super init]) {
        _downloadModels = [[NSMutableArray alloc] init];
        self.queue = [[NSOperationQueue alloc] init];
        // 设置最大下载数量
        self.queue.maxConcurrentOperationCount = 4;
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        // 不能传self.queue
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
 *
 *
 *  @param  downloadModels 存储下载模型的数组
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
    if (downloadModel.status != kDownloadStateCompleted) {
        downloadModel.status = kDownloadStateDownloading;
        
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
    if (downloadModel.status != kDownloadStateCompleted) {
        [downloadModel.operation suspend];
    }
}

/**
 *  重新下载
 *
 *  @param  downloadModel 下载的数据模型
 */
- (void)resumeWithVideoModel:(Dong_DownloadModel *)downloadModel {
    if (downloadModel.status != kDownloadStateCompleted) {
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



/**
 *  全部开始
 *
 */


#pragma mark - NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    //本地的文件路径，使用fileURLWithPath:来创建
    if (downloadTask.downloadModel.localPath) {
        NSURL *toURL = [NSURL fileURLWithPath:downloadTask.downloadModel.localPath];
        NSFileManager *manager = [NSFileManager defaultManager];
        [manager moveItemAtURL:location toURL:toURL error:nil];
    }
    
    [downloadTask.downloadModel.operation downloadFinished];
    NSLog(@"path = %@", downloadTask.downloadModel.localPath);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (error == nil) {
            task.downloadModel.status = kDownloadStateCompleted;
            [task.downloadModel.operation downloadFinished];
        } else if (task.downloadModel.status == kDownloadStatePause) {
            task.downloadModel.status = kDownloadStatePause;
        } else if ([error code] < 0) {
            // 网络异常
            task.downloadModel.status = kDownloadStateFailed;
        }
    });
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    double byts =  totalBytesWritten * 1.0 / 1024 / 1024;
    double total = totalBytesExpectedToWrite * 1.0 / 1024 / 1024;
    NSString *text = [NSString stringWithFormat:@"%.1lfMB/%.1fMB",byts,total];
    CGFloat progress = totalBytesWritten / (CGFloat)totalBytesExpectedToWrite;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        downloadTask.downloadModel.progressText = text;
        downloadTask.downloadModel.progress = progress;
    });
}

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
