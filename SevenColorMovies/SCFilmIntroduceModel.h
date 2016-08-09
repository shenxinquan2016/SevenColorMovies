//
//  SCFilmIntroduceModel.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/9.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  影片详情model

#import <Foundation/Foundation.h>


@interface SCFilmIntroduceModel : NSObject

/** 时间 */
@property (nonatomic,copy) NSString *_Year;

/** 导演 */
@property (nonatomic,copy) NSString *Director;

/** 主演 */
@property (nonatomic,copy) NSString *Actor;

/** 介绍 */
@property (nonatomic,copy) NSString *Introduction;


@end
