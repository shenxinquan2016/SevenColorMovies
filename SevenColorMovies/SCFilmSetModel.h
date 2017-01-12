//
//  SCFilmEpisode.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/5.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface SCFilmSetModel : RLMObject

/** 影片名称 */
@property NSString *_ContentSetName;
/** 第几集 */
@property NSString *_ContentIndex;
/** 第几集 */
@property NSString *_ContentName;
/** ID */
@property NSString *_FilmContentID;
/** 片长 */
@property NSString *_FilmSize;
/** 影片下载地址 */
@property NSString *_DownUrl;
/** 影片介绍 */
@property NSString *Introduction;
/** 视频流url */
@property NSString *VODStreamingUrl;
/* 节目是否正在播放 */
@property (getter = isOnLive) BOOL onLive;
/* 节目是否被下载 */
@property (getter = isDownLoaded) BOOL downloaded;

@end

RLM_ARRAY_TYPE(SCFilmSetModel)
