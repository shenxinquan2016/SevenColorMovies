//
//  SCGroupModel.h
//  SevenColorMovies
//
//  Created by yesdgq on 2017/5/16.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCGroupModel : NSObject

/** 是否展开 */
@property (nonatomic, assign) BOOL isOpened;
/** sectionHeader名称 */
@property (nonatomic, copy) NSString *groupName;
/** cell个数 */
@property (nonatomic, assign) NSInteger groupCount;
/** 展开时cell高度 */
@property (nonatomic, assign) float cellHeightOpen;
/** 关闭时cell高度 */
@property (nonatomic, assign) float cellHeightClose;


@end
