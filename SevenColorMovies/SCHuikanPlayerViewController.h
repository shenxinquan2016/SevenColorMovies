//
//  SCHuikanPlayerViewController.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/10/12.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  搜索-->回看 简介播放器

#import "SCOtherBaseViewController.h"
@class SCFilmModel;
@class SCLiveProgramModel;

@interface SCHuikanPlayerViewController : SCOtherBaseViewController

+ (instancetype)playFilmWithFilmModel:(SCFilmModel *)filmModel;
+ (instancetype)playHUIKANProgramWithProgramModel:(SCLiveProgramModel *)programModel;

@end
