//
//  Dong_DownloadOperation.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/11/9.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  下载类

#import "Dong_DownloadOperation.h"
#import "Dong_DownloadModel.h"
#import <objc/runtime.h>

#define kKVOBlock(KEYPATH, BLOCK) \
[self willChangeValueForKey:KEYPATH]; \
BLOCK(); \
[self didChangeValueForKey:KEYPATH];

static NSTimeInterval kTimeoutInterval = 10.0;
static const void *s_Dong_downloadModelKey = "s_Dong_downloadModelKey";

/*
 *  扩展NSURLSessionTask的属性
 */
@implementation NSURLSessionTask (DownloadModel)

- (void)setDownloadModel:(Dong_DownloadModel *)downloadModel {
    objc_setAssociatedObject(self, s_Dong_downloadModelKey, downloadModel, OBJC_ASSOCIATION_ASSIGN);
}

- (Dong_DownloadModel *)downloadModel {
    return objc_getAssociatedObject(self, s_Dong_downloadModelKey);
}

@end

/* ♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫♫ */

@interface Dong_DownloadOperation ()

@property (nonatomic, strong) NSURLSessionDownloadTask *task;
@property (nonatomic, weak) NSURLSession *session;

@end


@implementation Dong_DownloadOperation

{
    BOOL _finished;
    BOOL _executing;
}

- (instancetype)initWithModel:(Dong_DownloadModel *)downloadModel session:(NSURLSession *)session {
    if (self = [super init]) {
        self.model = downloadModel;
        self.session = session;
        [self statRequest];
    }
    return self;
}

- (void)dealloc {
    self.task = nil;
}

 /* 
  * 为每一个task注册观察者self 监听task属性"state"的变化
  *
  * NSURLSessionTaskStateRunning   = 0,
  * NSURLSessionTaskStateSuspended = 1,
  * NSURLSessionTaskStateCanceling = 2,
  * NSURLSessionTaskStateCompleted = 3,
  */
- (void)setTask:(NSURLSessionDownloadTask *)task {
    [_task removeObserver:self forKeyPath:@"state"];
    
    if (_task != task) {
        _task = task;
    }
    
    if (task != nil) {
        [task addObserver:self
               forKeyPath:@"state"
                  options:NSKeyValueObservingOptionNew context:nil];
    }
}

//将downloadModel 与 SessionDownloadTask 关联
- (void)configTask {
    self.task.downloadModel = self.model;
}

//开始下载(初始化task 全新下载)
- (void)statRequest {
    NSURL *url = [NSURL URLWithString:self.model.videoUrl];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url
                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                              timeoutInterval:kTimeoutInterval];
    self.task = [self.session downloadTaskWithRequest:request];
    //将downloadModel 与 SessionDownloadTask 关联
    [self configTask];
}

//重写start方法时,要做好isCancelled的判断  start方法开启任务执行操作,NSOperation对象默认按同步方式执行
- (void)start {
    if (self.isCancelled) {
        kKVOBlock(@"isFinished", ^{
            _finished = YES;
        });
        return;
    }
    
    [self willChangeValueForKey:@"isExecuting"];
    if (self.model.resumeData) {//断点续传
        [self resume];
    } else {//从0开始
        [self.task resume];
        self.model.downloadStatus = kDownloadStateDownloading;
    }
    _executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

//暂停下载
- (void)suspend {
    if (self.task) {
        __weak __typeof(self) weakSelf = self;
        __block NSURLSessionDownloadTask *weakTask = self.task;
        [self willChangeValueForKey:@"isExecuting"];
        __block BOOL isExecuting = _executing;
        
        [self.task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            weakSelf.model.resumeData = resumeData;
            DONG_Log(@"resumeData:%@",resumeData);
            weakTask = nil;
            isExecuting = NO;
            [weakSelf didChangeValueForKey:@"isExecuting"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.model.downloadStatus = kDownloadStatePause;
            });
        }];
        
        [self.task suspend];
    }
}

//恢复下载
- (void)resume {
    
    if (self.model.downloadStatus == kDownloadStateCompleted) {
        return;
    }
    self.model.downloadStatus = kDownloadStateDownloading;
    
    if (self.model.resumeData) {
        self.task = [self.session downloadTaskWithResumeData:self.model.resumeData];
        [self configTask];
    } else if (self.task == nil
               || (self.task.state == NSURLSessionTaskStateCompleted && self.model.progress < 1.0)) {
        [self statRequest];//重新下载
    }
    
    [self willChangeValueForKey:@"isExecuting"];
    [self.task resume];
    _executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

- (NSURLSessionDownloadTask *)downloadTask {
    return self.task;
}

#pragma mark - 重写option的主要方法
//重写isExecuting  isExecuting:可判断任务是否正在执行中
- (BOOL)isExecuting {
    return _executing;
}

//重写isFinished  isFinished:可判断任务是否已经执行完成
- (BOOL)isFinished {
    return _finished;
}

//重写isConcurrent  isConcurrent判断是否是同步 默认值为NO,表示操作与调用线程同步执行
- (BOOL)isConcurrent {
    return YES;
}

//重写cancel，并处理好isCancelled KVO处理  isCancelled:可判断任务是否已经执行完成，而要取消任务，可调用cancel方法
- (void)cancel {
    [self willChangeValueForKey:@"isCancelled"];
    [super cancel];
    [self.task cancel];
    self.task = nil;
    [self didChangeValueForKey:@"isCancelled"];
    
    [self completeOperation];
}

- (void)completeOperation {
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    
    _executing = NO;
    _finished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

//当下载完成之后，一定要回调downloadFinished，目的是让任务退队。要让任务退队，只有保证isFinished为YES才能退队 否则任务完成后还可以重新下载，通常情况下不会自动退队
- (void)downloadFinished {
    [self completeOperation];
    
}

//KVO监听动作
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    
    if ([keyPath isEqualToString:@"state"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (self.task.state) {
                case NSURLSessionTaskStateSuspended: {
                    self.model.downloadStatus = kDownloadStatePause;
                    break;
                }
                case NSURLSessionTaskStateCompleted:
                    if (self.model.progress >= 1.0) {
                        self.model.downloadStatus = kDownloadStateCompleted;
                    } else {
                        self.model.downloadStatus = kDownloadStatePause;
                    }
                default:
                    break;
            }
        });
    }
}






//参考
//检查服务器上文件的大小
- (long long)checkServerFileSize:(NSURL *)url{
    //要下载文件的url
    //NSURL *url = [NSURL URLWithString:@"http://dlsw.baidu.com/sw-search-sp/soft/2a/25677/QQ_V4.1.1.1456905733.dmg"];
    //创建获取文件大小的请求
    NSMutableURLRequest *headRequest = [NSMutableURLRequest requestWithURL:url];
    //请求方法
    headRequest.HTTPMethod = @"HEAD";
    //创建一个响应头
    NSURLResponse *headResponse;
    [NSURLConnection sendSynchronousRequest:headRequest returningResponse:&headResponse error:nil];
    long long serverSize = headResponse.expectedContentLength;
    //记录服务器文件的大小，用于计算进度
    //self.expectLength = serverSize;
    //拼接文件路径
    NSString *downloadPath = [FileManageCommon CreateList:[FileManageCommon GetDocumentPath] ListName:@"download"];
    NSString *path = [headResponse.suggestedFilename stringByAppendingString:downloadPath];
    DONG_Log(@"headResponse.suggestedFilename:%@",headResponse.suggestedFilename);
    //判断服务器文件大小跟本地文件大小的关系
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:path]) {
        NSLog(@"不存在，从头开始下载");
        return 0;
    }
    //获取文件的属性
    NSDictionary *dict = [manager attributesOfItemAtPath:path error:nil];
    //获取本地文件的大小
    long long fileSize = dict.fileSize;
    if (fileSize > serverSize) {
        //文件出错，删除文件
        [manager removeItemAtPath:path error:nil];
        NSLog(@"从头开始");
        return 0;
    } else if (fileSize < serverSize){
        NSLog(@"从本地文件大小开始下载");
        return fileSize;
    } else {
        NSLog(@"已经下载完毕");
        return fileSize;
    }
}

@end
