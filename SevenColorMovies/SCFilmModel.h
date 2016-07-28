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
@property (nonatomic,copy) NSString *_ChannelCode;

/**  */
@property (nonatomic,copy) NSString *_ChannelId;

/** 包含的影片个数 */
@property (nonatomic,copy) NSString *_Count;

/**  */
@property (nonatomic,copy) NSString *_FilmClassID;

/**  */
@property (nonatomic,copy) NSString *_FilmClassName;

/**  */
@property (nonatomic,copy) NSString *_FilmClassRealName;

/**  */
@property (nonatomic,copy) NSString *_FilmClassUrl;

/**  */
@property (nonatomic,copy) NSString *_FilmCount;

/**  */
@property (nonatomic,copy) NSString *_IcoID;

/**  */
@property (nonatomic,copy) NSString *_IcoUrl;

/**  */
@property (nonatomic,copy) NSString *_Intro;

/**  */
@property (nonatomic,copy) NSString *_PageCount;

/**  */
@property (nonatomic,copy) NSString *_Template;

/** 请求数据时间 */
@property (nonatomic,copy) NSString *_Time;

/** 版本 */
@property (nonatomic,copy) NSString *_Version;



@end
