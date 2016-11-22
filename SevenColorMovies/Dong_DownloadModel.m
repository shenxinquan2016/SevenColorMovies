//
//  Dong_DownloadMoedel.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/11/9.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  下载数据模型

#import "Dong_DownloadModel.h"
#import "Dong_DownloadOperation.h"

@implementation Dong_DownloadModel


- (NSString *)localPath {
    
    NSString *pathName = [NSString stringWithFormat:@"/Documents/HYBVideos/%@.mp4",self.filmName];
    NSString *filePath = [NSHomeDirectory() stringByAppendingString:pathName];
    
    return filePath;
}

- (void)setProgress:(CGFloat)progress {
    if (_progress != progress) {
        _progress = progress;
        
        if (self.onProgressChanged) {
            self.onProgressChanged(self);
        } else {
            NSLog(@"progress changed block is empty");
        }
    }
}

- (void)setDownloadStatus:(DownloadStateType)downloadStatus {
    if (_downloadStatus != downloadStatus) {
        _downloadStatus = downloadStatus;
        
        if (self.onStatusChanged) {
            self.onStatusChanged(self);
        }
    }
}

- (NSString *)statusText {
    switch (self.downloadStatus) {
        case kDownloadStateNotFound: {
            return @"未找到资源";
            break;
        }
        case kDownloadStateUnDownLoad: {
            return @"未下载";
            break;
        }
        case kDownloadStateDownloading: {
            return @"下载中";
            break;
        }
        case kDownloadStatePause: {
            return @"暂停下载";
            break;
        }
        case kDownloadStateCompleted: {
            return @"下载完成";
            break;
        }
        case kDownloadStateFailed: {
            return @"下载失败";
            break;
        }
        case kDownloadStateWaitting: {
            return @"等待下载";
            break;
        }
        case kDownloadStateContinue: {
            return @"继续下载";
            break;
        }
    }
}

@end
