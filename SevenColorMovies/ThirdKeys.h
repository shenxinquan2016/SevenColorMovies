//
//  ThirdKeys.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/5.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#ifndef ThirdKeys_h
#define ThirdKeys_h







typedef NS_ENUM(NSUInteger, SCDownLoadStateType) {
    SCNotFoundState = -1,
    SCUnDownLoadState = 0,//未下载
    SCDownLoadPauseState,//暂停下载
    SCDownLoadFinshedState,//下载结束
    SCJustDownLoadingState,//正在下载
    SCWaittingDownLoadState,//等待下载
    SCContinueDownLoadState //继续下载
};











#endif /* ThirdKeys_h */
