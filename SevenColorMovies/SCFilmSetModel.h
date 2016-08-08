//
//  SCFilmEpisode.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/5.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCFilmSetModel : NSObject

/** 影片名称*/
@property (nonatomic,copy) NSString *_ContentSetName;

/** 第几集 */
@property (nonatomic,copy) NSString *_ContentIndex;

/** 第几集 */
@property (nonatomic,copy) NSString *_ContentName;

/** ID */
@property (nonatomic,copy) NSString *_FilmContentID;

/** 片长 */
@property (nonatomic,copy) NSString *_FilmSize;

/** 影片下载地址 */
@property (nonatomic,copy) NSString *_DownUrl;

/** 影片介绍 */
@property (nonatomic,copy) NSString *Introduction;

/** 视频流url */
@property (nonatomic,copy) NSString *VODStreamingUrl;

@end
