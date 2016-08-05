//
//  SCFilmEpisode.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/5.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCFilmSetModel : NSObject

/** 第几集 */
@property (nonatomic,copy) NSString *_ContentIndex;

/** 第一集 */
@property (nonatomic,copy) NSString *_ContentName;

/**  */
@property (nonatomic,copy) NSString *_FilmContentID;

/** 片长 */
@property (nonatomic,copy) NSString *_FilmSize;

/**  */
@property (nonatomic,copy) NSString *_DownUrl;



@end
