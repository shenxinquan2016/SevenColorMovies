//
//  Dong_DownloadMoedel.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/11/9.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

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

- (void)setStatus:(DownLoadStateType)status {
    if (_status != status) {
        _status = status;
        
        if (self.onStatusChanged) {
            self.onStatusChanged(self);
        }
    }
}

- (NSString *)statusText {
    switch (self.status) {
        case kDownloadStateNotFound: {
            return @"";
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
