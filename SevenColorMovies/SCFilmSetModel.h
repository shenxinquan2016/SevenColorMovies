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

@property NSString *_ContentSetName;/** 影片名称*/
@property NSString *_ContentIndex;/** 第几集 */
@property NSString *_ContentName;/** 第几集 */
@property NSString *_FilmContentID;/** ID */
@property NSString *_FilmSize;/** 片长 */
@property NSString *_DownUrl;/** 影片下载地址 */
@property NSString *Introduction;/** 影片介绍 */
@property NSString *VODStreamingUrl;/** 视频流url */
@property (getter = isOnLive) BOOL onLive;/* 节目是否正在播放 */
@property (getter = isDownLoaded) BOOL downloaded;/* 节目是否被下载 */

@end

RLM_ARRAY_TYPE(SCFilmSetModel)
