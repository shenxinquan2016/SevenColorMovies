//
//  Dong_DownloadModel.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/11/9.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  下载数据模型

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


@property (nonatomic, strong) NSData *resumeData;//用于断点下载记录，其实应该要存储到文件中，然后记录路径

@property (nonatomic, copy) NSString *localPath;//下载后存储到此处
@property (nonatomic, copy) NSString *progressText;

@property (nonatomic, assign) CGFloat progress;//非常关键的属性，进度变化会自动回调onProgressChanged
@property (nonatomic, assign) DownLoadStateType status;//状态变化会自动回调onStatusChanged
// 这里为什么要引用operation且是强引用？因为管理器直接管理的是model，
// 而真正做下载任务的是operation。
// 为什么没有将这两个分别作为属性呢？为了整体更简单！
@property (nonatomic, strong) Dong_DownloadOperation *operation;

@property (nonatomic, copy) Dong_DownloadStatusChanged onStatusChanged;
@property (nonatomic, copy) Dong_DownloadProgressChanged onProgressChanged;

@property (nonatomic, readonly, copy) NSString *statusText;


@end
