//
//  SCFilmModel.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/28.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface SCFilmModel : RLMObject

@property (nonatomic, copy) NSString *FilmName;/** 影片名称 两个都用 */
@property (nonatomic, copy) NSString *cnname;/** 影片名称 两个都用  */
@property (nonatomic, copy) NSString *_Title;/** Live频道名称 */
@property (nonatomic, copy) NSString *SourceUrl;/** 影片资源地址 */
@property (nonatomic, copy) NSString *SourceURL;/** 影片资源地址 */
@property (nonatomic, copy) NSString *_Year;/** 影片时间 */
@property (nonatomic, copy) NSString *_Mtype;/** 影片类型 两个都用 */
@property (nonatomic, copy) NSString *mtype;/** 影片类型 两个都用 */
@property (nonatomic, copy) NSString *_Mid;/** 影片编号 两个都用 */
@property (nonatomic, copy) NSString *mid;/** 影片编号 两个都用 */
@property (nonatomic, copy) NSString *Introduction;/** 影片简介 */
@property (nonatomic, copy) NSString *Subject;/** film内容介绍 */
@property (nonatomic, copy) NSString *_ImgUrl;/** 图片url 两个都用 */
@property (nonatomic, copy) NSString *smallposterurl;/** 图片url 两个都用 */
@property (nonatomic, copy) NSString *_ImgUrlB;/** 横版图片url 综艺生活 */
@property (nonatomic, copy) NSString *_ImgUrlOriginal;/** banner图片URL  老接口 */
@property (nonatomic, copy) NSString *_ImgUrlO;/** banner图片URL  新接口 */
@property (nonatomic, copy) NSString *_PlayUrl;/** Live直播资源 */
@property (nonatomic, copy) NSString *WatchFocus;/** 请求数据时间 */

@property (nonatomic, copy) NSString *nowPlaying;/** 正在播出 直播 */
@property (nonatomic, copy) NSString *nextPlay;/** 即将播出 直播 */
@property (nonatomic, copy) NSString *_TvId;/** 直播节目id 直播 */

@property (nonatomic, copy) NSString *storyintro;/** 影片介绍  点播搜索 */
@property (nonatomic, copy) NSString *actor;/** 主演 点播搜索 */
@property (nonatomic, copy) NSString *endGrade;/** 评分  点播搜索 */

@property (nonatomic, assign, getter = isOnLive) BOOL onLive;/* 节目是否正在播放 */

@property (nonatomic, assign, getter = isShowDeleteBtn) BOOL showDeleteBtn;/** 是否显示删除按钮 */
@property (nonatomic, assign, getter = isSelecting) BOOL selected;/** 是否正被点击 */
@property (nonatomic,assign) BOOL isDownLoading;/** 是否正在下载 */

@end

RLM_ARRAY_TYPE(SCFilmModel)

