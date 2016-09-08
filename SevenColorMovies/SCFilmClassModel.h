//
//  SCFilmClassModel.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/28.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCFilmClassModel : NSObject

@property (nonatomic, copy) NSString *_FilmClassName;/** FilmClassList */
@property (nonatomic, copy) NSString *_Intro;/** film介绍 */
@property (nonatomic, copy) NSString *_FilmCount;/** 包含影片个数 */
@property (nonatomic, copy) NSString *_Count;/** 包含影片个数 */
@property (nonatomic, copy) NSString *_PageCount;/** 分页数量 */
@property (nonatomic, copy) NSString *_BigImgUrl;/** 封面图片 */
@property (nonatomic, copy) NSString *_FilmClassID;/** ... */
@property (nonatomic, copy) NSString *_Version;/** ... */
@property (nonatomic, copy) NSString *_ChannelId;/** ... */
@property (nonatomic, copy) NSString *_ChannelCode;/** ... */
@property (nonatomic, copy) NSString *_FilmClassUrl;/** 老接口FilmClassUrl字段名 */
@property (nonatomic, copy) NSString *FilmClassUrl;/** 新接口FilmClassUrl字段名 */
@property (nonatomic, copy) NSString *_KeyValue;/** 每个类别的关键词 */
@property (nonatomic, copy) NSString *_FilmClassRealName;/** ... */
@property (nonatomic, copy) NSString *_Template;/** ... */
@property (nonatomic, copy) NSString *_Time;/** ... */
@property (nonatomic, copy) NSArray *filmClassArray;/** 包含的影片数组*/
@property (nonatomic, copy) NSArray *filmArray;/** 包含的影片数组*/
@property (nonatomic, strong) SCFilmClassModel *filmClassModel;/** FilmClass模型*/

@end
