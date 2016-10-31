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

@property (nonatomic,copy) NSString *_ContentSetName;/** 影片名称*/
@property (nonatomic,copy) NSString *_ContentIndex;/** 第几集 */
@property (nonatomic,copy) NSString *_ContentName;/** 第几集 */
@property (nonatomic,copy) NSString *_FilmContentID;/** ID */
@property (nonatomic,copy) NSString *_FilmSize;/** 片长 */
@property (nonatomic,copy) NSString *_DownUrl;/** 影片下载地址 */
@property (nonatomic,copy) NSString *Introduction;/** 影片介绍 */
@property (nonatomic,copy) NSString *VODStreamingUrl;/** 视频流url */
@property (nonatomic, assign, getter = isOnLive) BOOL onLive;/* 节目是否正在播放 */

@end

RLM_ARRAY_TYPE(SCFilmSetModel)
