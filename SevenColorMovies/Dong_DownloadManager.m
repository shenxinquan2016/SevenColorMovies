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

+ (instancetype)shared {
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

- (void)addVideoModels:(NSArray<Dong_DownloadModel *> *)downloadModels {
    if ([downloadModels isKindOfClass:[NSArray class]]) {
        [_downloadModels addObjectsFromArray:downloadModels];
    }
}

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



@end
