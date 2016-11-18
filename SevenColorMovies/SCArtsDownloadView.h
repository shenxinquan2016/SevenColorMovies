//
//  SCArtsDownloadView.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/11/18.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  综艺生活下载页

#import <UIKit/UIKit.h>

@class SCFilmModel;

typedef void (^BackBtnBlock)(void);

@interface SCArtsDownloadView : UIView

@property (nonatomic, strong) NSArray *dataSourceArray;
@property (nonatomic, strong) SCFilmModel *filmModel;
@property (nonatomic, copy) BackBtnBlock backBtnBlock;

@end
