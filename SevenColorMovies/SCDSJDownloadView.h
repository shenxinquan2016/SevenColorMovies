//
//  SCDownloadView.h
//  SCDSJDownloadView
//
//  Created by yesdgq on 16/11/15.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  电视剧下载页

#import <UIKit/UIKit.h>

@class SCFilmModel;

typedef void (^BackBtnBlock)(void);

@interface SCDSJDownloadView : UIView

@property (nonatomic, strong) NSArray *dataSourceArray;
@property (nonatomic, strong) SCFilmModel *filmModel;
@property (nonatomic, copy) BackBtnBlock backBtnBlock;

@end
