//
//  SCWatchHistoryModel.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/11/29.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCWatchHistoryModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *mid;
@property (nonatomic, copy) NSString *playtime;
@property (nonatomic, copy) NSString *sid;
@property (nonatomic, copy) NSString *fid;
@property (nonatomic, copy) NSString *mtype;
@property (nonatomic, assign, getter = isSelecting) BOOL selected;/** 是否正被点击 */
@property (nonatomic, assign, getter = isShowDeleteBtn) BOOL showDeleteBtn;

@end
