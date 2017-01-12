//
//  SCAdMediaInfo.h
//  SevenColorMovies
//
//  Created by yesdgq on 17/1/12.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCAdMediaInfo : NSObject

/** 广告编码 */
@property (nonatomic, copy) NSString *_amid;
/** 广告类型 1:视频 2:图片 3:文字 */
@property (nonatomic, copy) NSString *_type;
/** 广告名称 */
@property (nonatomic, copy) NSString *_name;
/** 广告url */
@property (nonatomic, copy) NSString *__text;

@end
