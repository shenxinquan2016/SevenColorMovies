//
//  SCHuikanPlayerViewController.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/10/12.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  搜索-->回看 简洁播放器

#import "SCOtherBaseViewController.h"
@class SCFilmModel;
@class SCLiveProgramModel;

@interface SCHuikanPlayerViewController : SCOtherBaseViewController

/** 是否是飞屏（用于控制播放器返回动作）*/
@property (nonatomic, assign) BOOL isFeiPing;

/** 由我的节目/点播飞屏拉屏单进入(点播) */
+ (instancetype)initPlayerWithFilmModel:(SCFilmModel *)filmModel;
/** 由回看搜索单进入(直播回看) */
+ (instancetype)initPlayerWithProgramModel:(SCLiveProgramModel *)programModel;
/** 直播拉屏 */
+ (instancetype)initPlayerWithLiveProgramModel:(SCLiveProgramModel *)liveProgramModel;
/** 时移拉屏 */
+ (instancetype)initPlayerWithTimeShiftWithLiveProgramModel:(SCLiveProgramModel *)liveProgramModel currentPlayTime:(NSString *)currentPlayTime;
/** 播放本地文件 */
+ (instancetype)initPlayerWithFilePath:(NSString *)filePath;
/** 播放URL视频 */
+ (instancetype)initPlayerWithUrlString:(NSString *)urlStr videoName:(NSString *)name;

@end

