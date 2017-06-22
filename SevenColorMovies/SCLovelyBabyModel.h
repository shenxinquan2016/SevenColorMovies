//
//  SCLovelyBabyModel.h
//  SevenColorMovies
//
//  Created by yesdgq on 2017/6/22.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCLovelyBabyModel : NSObject

/** 标题 */
@property (nonatomic, copy) NSString *mzName;
/** 状态码 */
@property (nonatomic, assign) NSInteger status;
/** 序号 */
@property (nonatomic, copy) NSString *serialNumber;
/** 投票数 */
@property (nonatomic, copy) NSString *voteNum;
/** 拍客id */
@property (nonatomic, copy) NSString *id;
/** 封面图片 */
@property (nonatomic, copy) NSString *showUrl;
/** 视频地址 */
@property (nonatomic, copy) NSString *bfUrl;

@end
