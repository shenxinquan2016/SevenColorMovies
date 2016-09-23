//
//  SCLiveProgramModel.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/24.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCLiveProgramModel : NSObject

@property (nonatomic, copy) NSString *programName;/* 节目名称 */
@property (nonatomic, copy) NSString *programTime;/* 节目开始时间 HH:mm"*/
@property (nonatomic, copy) NSString *startTime;/* 节目时间开始时间 yyyy-MM-dd HH:mm:ss */
@property (nonatomic, copy) NSString *endTime;/* 节目时间结束时间 yyyy-MM-dd HH:mm:ss */
@property (nonatomic, assign) SCLiveProgramState programState;/* 节目状态:回看/播放/预约 */
@property (nonatomic, assign, getter = isOnLive) BOOL onLive;/* 节目是否正在播放 */

@property (nonatomic, copy) NSString *forecastdate;/* 回看节目播出时间  回看搜索 */
@property (nonatomic, copy) NSString *program;/* 回看节目名称  回看搜索 */
@property (nonatomic, copy) NSString *tvchannelen;/* 频道名称  回看搜索 */
@property (nonatomic, copy) NSString *channelLogoUrl;/* 节目logo url  回看搜索 */

@end
