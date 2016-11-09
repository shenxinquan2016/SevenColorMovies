//
//  Dong_DownloadManager.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/11/9.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Dong_DownloadModel;

@interface Dong_DownloadManager : NSObject

@property (nonatomic, readonly, strong) NSArray *downloadModels;

+ (instancetype)shared;

- (void)addVideoModels:(NSArray<Dong_DownloadModel *> *)downloadModels;

- (void)startWithVideoModel:(Dong_DownloadModel *)downloadModel;
- (void)suspendWithVideoModel:(Dong_DownloadModel *)downloadModel;
- (void)resumeWithVideoModel:(Dong_DownloadModel *)downloadModel;

- (void)stopWiethVideoModel:(Dong_DownloadModel *)downloadModel;

@end
