//
//  SCLiveProgramModel.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/24.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCLiveProgramModel : NSObject

@property (nonatomic, strong) NSString *programName;/* 节目名称 */
@property (nonatomic, strong) NSString *programTime;/* 节目时间 */
@property (nonatomic, assign) SCLiveProgramState programState;/* 节目状态:回看/播放/预约 */
@property (nonatomic, assign, getter = isOnLive) BOOL onLive;/* 节目是否正在播放 */

@property (nonatomic, strong) NSString *forecastdate;/* 回看节目播出时间  回看搜索 */
@property (nonatomic, strong) NSString *program;/* 回看节目名称  回看搜索 */
@property (nonatomic, strong) NSString *tvchannelen;/* 频道名称  回看搜索 */
@property (nonatomic, strong) NSString *channelLogoUrl;/* 节目logo url  回看搜索 */

@end
