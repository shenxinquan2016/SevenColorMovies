//
//  SCFilmListModel.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/28.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCFilmListModel : NSObject

/** FilmClassList */
@property (nonatomic,copy) NSString *__name;

/** 请求数据时间 */
@property (nonatomic,copy) NSString *_Time;

/** 版本 */
@property (nonatomic,copy) NSString *_Version;

/** 包含影片个数 */
@property (nonatomic,copy) NSString *_Count;

/** 包含的影片数组*/
@property (nonatomic, copy) NSArray *filmArray;





@end
