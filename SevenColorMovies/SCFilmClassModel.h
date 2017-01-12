//
//  SCFilmClassModel.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/28.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCFilmClassModel : NSObject

/** FilmClassList */
@property (nonatomic, copy) NSString *_FilmClassName;
/** film介绍 */
@property (nonatomic, copy) NSString *_Intro;
/** 包含影片个数 */
@property (nonatomic, copy) NSString *_FilmCount;
/** 包含影片个数 */
@property (nonatomic, copy) NSString *_Count;
/** 分页数量 */
@property (nonatomic, copy) NSString *_PageCount;
/** 封面图片 */
@property (nonatomic, copy) NSString *_BigImgUrl;
/** ... */
@property (nonatomic, copy) NSString *_FilmClassID;
/** ... */
@property (nonatomic, copy) NSString *_Version;
/** ... */
@property (nonatomic, copy) NSString *_ChannelId;
/** ... */
@property (nonatomic, copy) NSString *_ChannelCode;
/** 老接口FilmClassUrl字段名 */
@property (nonatomic, copy) NSString *_FilmClassUrl;
/** 新接口FilmClassUrl字段名 */
@property (nonatomic, copy) NSString *FilmClassUrl;
/** 每个类别的关键词 */
@property (nonatomic, copy) NSString *_KeyValue;
/** ... */
@property (nonatomic, copy) NSString *_FilmClassRealName;
/** ... */
@property (nonatomic, copy) NSString *_Template;
/** ... */
@property (nonatomic, copy) NSString *_Time;
/** 包含的影片数组*/
@property (nonatomic, copy) NSArray *filmClassArray;
/** 包含的影片数组*/
@property (nonatomic, copy) NSArray *filmArray;
/** FilmClass模型*/
@property (nonatomic, strong) SCFilmClassModel *filmClassModel;

@end
