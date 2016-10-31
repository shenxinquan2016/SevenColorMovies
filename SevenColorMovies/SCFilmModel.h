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

@property NSString *FilmName;/** 影片名称 两个都用 */
@property NSString *cnname;/** 影片名称 两个都用  */
@property NSString *_Title;/** Live频道名称 */
@property NSString *SourceUrl;/** 影片资源地址 */
@property NSString *SourceURL;/** 影片资源地址 */
@property NSString *_Year;/** 影片时间 */
@property NSString *_Mtype;/** 影片类型 两个都用 */
@property NSString *mtype;/** 影片类型 两个都用 */
@property NSString *_Mid;/** 影片编号 两个都用 */
@property NSString *mid;/** 影片编号 两个都用 */
@property NSString *Introduction;/** 影片简介 */
@property NSString *Subject;/** film内容介绍 */
@property NSString *_ImgUrl;/** 图片url 两个都用 */
@property NSString *smallposterurl;/** 图片url 两个都用 */
@property NSString *_ImgUrlB;/** 横版图片url 综艺生活 */
@property NSString *_ImgUrlOriginal;/** banner图片URL  老接口 */
@property NSString *_ImgUrlO;/** banner图片URL  新接口 */
@property NSString *_PlayUrl;/** Live直播资源 */
@property NSString *WatchFocus;/** 请求数据时间 */

@property NSString *nowPlaying;/** 正在播出 直播 */
@property NSString *nextPlay;/** 即将播出 直播 */
@property NSString *_TvId;/** 直播节目id 直播 */

@property NSString *storyintro;/** 影片介绍  点播搜索 */
@property NSString *actor;/** 主演 点播搜索 */
@property NSString *endGrade;/** 评分  点播搜索 */

@property (getter = isOnLive) BOOL onLive;/* 节目是否正在播放 */

@property (getter = isShowDeleteBtn) BOOL showDeleteBtn;/** 是否显示删除按钮 */
@property (getter = isSelecting) BOOL selected;/** 是否正被点击 */
@property BOOL isDownLoading;/** 是否正在下载 */


@property NSInteger jiIndex;/** 伪属性 记录第几集 */
@property SCFilmSetModel *filmSetModel;

@end

RLM_ARRAY_TYPE(SCFilmModel)

