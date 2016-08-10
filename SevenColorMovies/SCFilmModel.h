//
//  SCFilmModel.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/28.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCFilmModel : NSObject

/** 影片名称 两个都用 */
@property (nonatomic,copy) NSString *FilmName;

/** 影片名称 两个都用  */
@property (nonatomic,copy) NSString *cnname;

/** 影片资源地址 */
@property (nonatomic,copy) NSString *SourceUrl;

/** 影片资源地址 */
@property (nonatomic,copy) NSString *SourceURL;

/** 影片时间 */
@property (nonatomic,copy) NSString *_Year;



/** 影片类型 两个都用 */
@property (nonatomic,copy) NSString *_Mtype;

/** 影片类型 两个都用 */
@property (nonatomic,copy) NSString *mtype;

/** 影片编号 两个都用 */
@property (nonatomic,copy) NSString *_Mid;

/** 影片编号 两个都用 */
@property (nonatomic,copy) NSString *mid;

/** 影片简介 */
@property (nonatomic,copy) NSString *Introduction;

/** film内容介绍 */
@property (nonatomic,copy) NSString *Subject;

/** 图片url 两个都用 */
@property (nonatomic,copy) NSString *_ImgUrl;

/** 图片url 两个都用 */
@property (nonatomic,copy) NSString *smallposterurl;

/** banner图片URL  老接口 */
@property (nonatomic,copy) NSString *_ImgUrlOriginal;

/** banner图片URL  新接口 */
@property (nonatomic,copy) NSString *_ImgUrlO;

/**  */
@property (nonatomic,copy) NSString *_Stype;

/**  */
@property (nonatomic,copy) NSString *_Area;

/**  */
@property (nonatomic,copy) NSString *_FilmFormat;

/** 请求数据时间 */
@property (nonatomic,copy) NSString *WatchFocus;



@end
