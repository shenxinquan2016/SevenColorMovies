//
//  SCRotatoUtil.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/18.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  强制切换横竖屏

#import <Foundation/Foundation.h>

@interface SCRotatoUtil : NSObject

/**
 *  切换横竖屏
 *
 *  @param orientation ：UIInterfaceOrientation
 */
+ (void)forceOrientation: (UIInterfaceOrientation)orientation;

@end