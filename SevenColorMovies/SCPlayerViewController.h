//
//  SCPlayerViewController.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/22.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  播放页面

#import <UIKit/UIKit.h>
#import "SCFilmModel.h"

@interface SCPlayerViewController : UIViewController

@property (nonatomic, strong) SCFilmModel *filmModel;
@property (nonatomic, strong) NSString *filmType;/** 用于区别进入什么样的播放页面 */

- (instancetype)initWithWithFilmType:(NSString *)tpye;

@end
