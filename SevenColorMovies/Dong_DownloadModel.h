//
//  Dong_DownloadModel.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/11/9.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Dong_DownloadModel;
@class Dong_DownloadOperation;

typedef NS_ENUM(NSUInteger, DownLoadStateType) {
    kDownloadStateNotFound = -1,
    kDownloadStateUnDownLoad = 0,//未下载
    kDownloadStatePause,//暂停下载
    kDownloadStateCompleted,//下载完成
    kDownloadStateDownloading,//正在下载
    kDownloadStateWaitting,//等待下载
    kDownloadStateContinue, //继续下载
    kDownloadStateFailed //下载失败
};

typedef void(^Dong_DownloadStatusChanged)(Dong_DownloadModel *model);
typedef void(^Dong_DownloadProgressChanged)(Dong_DownloadModel *model);

@interface Dong_DownloadModel : NSObject

@property (nonatomic, copy) NSString *filmName;//影片名称
@property (nonatomic, copy) NSString *videoUrl;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *title;


@property (nonatomic, strong) NSData *resumeData;

@property (nonatomic, copy) NSString *localPath;//下载后存储到此处
@property (nonatomic, copy) NSString *progressText;

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) DownLoadStateType status;
@property (nonatomic, strong) Dong_DownloadOperation *operation;

@property (nonatomic, copy) Dong_DownloadStatusChanged onStatusChanged;
@property (nonatomic, copy) Dong_DownloadProgressChanged onProgressChanged;

@property (nonatomic, readonly, copy) NSString *statusText;


@end
