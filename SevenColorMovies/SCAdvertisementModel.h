//
//  SCAdvertisementModel.h
//  SevenColorMovies
//
//  Created by yesdgq on 2017/6/5.
//  Copyright © 2017年 yesdgq. All rights reserved.
//  广告model

#import <Foundation/Foundation.h>

@interface SCAdvertisementModel : NSObject

/** 广告类型 */
@property (nonatomic, copy) NSString *adType;
/** 广告内容图片 */
@property (nonatomic, copy) NSString *imgUrl;
/** 广告点击web链接 */
@property (nonatomic, copy) NSString *webUrl;
/**  */
@property (nonatomic, copy) NSString *isBreak;
/** 广告id */
@property (nonatomic, copy) NSString *adId;
/** 广告名称 */
@property (nonatomic, copy) NSString *adName;
/** 第三方APP url */
@property (nonatomic, copy) NSDictionary *openUrl;

@end
