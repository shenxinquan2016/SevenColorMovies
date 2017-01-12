//
//  SCAdvertisemetPosModel.h
//  SevenColorMovies
//
//  Created by yesdgq on 17/1/12.
//  Copyright © 2017年 yesdgq. All rights reserved.
//  广告model

#import <Foundation/Foundation.h>
@class SCAdMediaInfo;

@interface SCAdvertisemetPosModel : NSObject

/** 广告数量 */
@property (nonatomic, copy) NSString *_adcount;
/** 广告位 701:片头 704:缓冲 706:暂停 */
@property (nonatomic, copy) NSString *_pos;
/** 广告module数组 */
@property (nonatomic, copy) NSArray *adMediaInfoArray;
@property (nonatomic, strong) SCAdMediaInfo *adMediaInfo;

@end
