//
//  SCFilmModel.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/28.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "SCFilmSetModel.h"

@interface SCFilmModel : RLMObject

/** 影片名称 两个都用 */
@property NSString *FilmName;
/** 影片名称 两个都用 */
@property NSString *cnname;
/** Live频道名称 */
@property NSString *_Title;
/** 影片资源地址 */
@property NSString *SourceUrl;
/** 影片资源地址 */
@property NSString *SourceURL;
@property NSString *_FilmID;
/** 影片时间 */
@property NSString *_Year;
/** 影片类型 两个都用 */
@property NSString *_Mtype;
/** 影片类型 两个都用 */
@property NSString *mtype;
/** 搜索是用于判断是否是综艺 1为综艺 */
@property NSString *stype;
/** 影片编号 两个都用 */
@property NSString *_Mid;
/** 影片编号 两个都用 */
@property NSString *mid;
/** 影片简介 */
@property NSString *Introduction;
/** film内容介绍 */
@property NSString *Subject;
/** 图片url 两个都用 */
@property NSString *_ImgUrl;
/** 图片url 两个都用 */
@property NSString *smallposterurl;
/** 横版图片url 综艺生活 */
@property NSString *_ImgUrlB;
/** banner图片URL  老接口 */
@property NSString *_ImgUrlOriginal;
/** banner图片URL  新接口 */
@property NSString *_ImgUrlO;
/** Live直播资源 */
@property NSString *_PlayUrl;
/** 请求数据时间 */
@property NSString *WatchFocus;

/** 正在播出 直播 */
@property NSString *nowPlaying;
/** 即将播出 直播 */
@property NSString *nextPlay;
/** 直播节目id 直播 */
@property NSString *_TvId;

/** 影片介绍  点播搜索 */
@property NSString *storyintro;
/** 主演 点播搜索 */
@property NSString *actor;
/** 评分  点播搜索 */
@property NSString *endGrade;

/* 节目是否正在播放 */
@property (getter = isOnLive) BOOL onLive;

/** 是否显示删除按钮 */
@property (nonatomic, assign, getter = isShowDeleteBtn) BOOL showDeleteBtn;
/** 是否正被点击 */
@property (nonatomic, assign, getter = isSelecting) BOOL selected;
/** 是否正在下载 */
@property BOOL isDownLoading;
/* 节目是否被下载 */
@property (getter = isDownLoaded) BOOL downloaded;

/** 伪属性 记录第几集 */
@property NSInteger jiIndex;
@property SCFilmSetModel *filmSetModel;
/** 已经播放的时间 */
@property (nonatomic, assign) NSTimeInterval currentPlayTime;
/** 用于专题推荐页横版判断 */
@property (nonatomic, strong) NSString *scale;

@end

RLM_ARRAY_TYPE(SCFilmModel)

