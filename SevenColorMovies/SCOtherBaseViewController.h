//
//  SCOtherBaseViewController.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/22.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  带返回标题的基类

#import <UIKit/UIKit.h>

@interface SCOtherBaseViewController : UIViewController

/** 返回标题 */
@property (nonatomic, copy) NSString *_title;

/** 返回按钮 */
@property (nonatomic,strong) UILabel *leftBBI;

- (instancetype)initWithWithTitle:(NSString *)title;

@end
