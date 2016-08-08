//
//  SCFilmModel.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/28.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCFilmModel : NSObject

/**  */
@property (nonatomic,copy) NSString *FilmName;

/** 影片资源地址 */
@property (nonatomic,copy) NSString *SourceUrl;

/** 影片资源地址 */
@property (nonatomic,copy) NSString *SourceURL;

/** ... */
@property (nonatomic,copy) NSString *_Year;

/**  */
@property (nonatomic,copy) NSString *_SourceID;

/**  */
@property (nonatomic,copy) NSString *_Mtype;

/**  */
@property (nonatomic,copy) NSString *_ImgUrl;

/**  */
@property (nonatomic,copy) NSString *_ImgUrlB;

/**  */
@property (nonatomic,copy) NSString *_FilmID;

/**  */
@property (nonatomic,copy) NSString *Introduction;

/**  */
@property (nonatomic,copy) NSString *_LongTime;

/**  */
@property (nonatomic,copy) NSString *_Stype;

/**  */
@property (nonatomic,copy) NSString *_Area;

/**  */
@property (nonatomic,copy) NSString *_FilmFormat;

/** 请求数据时间 */
@property (nonatomic,copy) NSString *WatchFocus;

/** banner图片URL  老接口 */
@property (nonatomic,copy) NSString *_ImgUrlOriginal;

/** banner图片URL  新接口 */
@property (nonatomic,copy) NSString *_ImgUrlO;

@end
