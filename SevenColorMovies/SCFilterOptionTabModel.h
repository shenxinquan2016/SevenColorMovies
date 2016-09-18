//
//  SCFilterOptionTabModel.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/9/8.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCFilterOptionTabModel : NSObject

@property (nonatomic, copy) NSString *tabText;/* 选项卡内容文字 */
@property (nonatomic, getter=isSelected) BOOL selected;/* 是否被选中 */

@end