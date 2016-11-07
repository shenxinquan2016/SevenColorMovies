//
//  HJMURLDownloaderInstance.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/11/7.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <HJMURLDownload.h>


@interface HJMURLDownloaderInstance : HJMURLDownloadManager

+ (instancetype)sharedInstance;
- (HJMURLDownloadManager *)downloadManager;

@end
