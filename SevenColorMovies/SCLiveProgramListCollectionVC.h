//
//  SCLiveProgramListCollectionVC.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/24.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  直播节目列表

#import <UIKit/UIKit.h>
@class SCLiveProgramModel;

typedef void(^ClickToPlayBlock)(SCLiveProgramModel *model, SCLiveProgramModel *nextProgramModel, NSArray *liveProgramModelArr);//点击切换节目block

@interface SCLiveProgramListCollectionVC : UICollectionViewController

@property (nonatomic, copy) NSArray *liveProgramModelArr;
@property (nonatomic, assign) NSInteger index;//首次进入页面时正在播出节目的index
@property (nonatomic, copy) ClickToPlayBlock clickToPlayBlock;//点击切换节目block

@end
