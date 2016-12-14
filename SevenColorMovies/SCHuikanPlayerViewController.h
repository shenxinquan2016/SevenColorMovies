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

// 由我的节目单进入
+ (instancetype)initPlayerWithFilmModel:(SCFilmModel *)filmModel;
// 由回看搜索单进入
+ (instancetype)initPlayerWithProgramModel:(SCLiveProgramModel *)programModel;
// 播放本地文件
+ (instancetype)initPlayerWithFilePath:(NSString *)filePath;


@end
