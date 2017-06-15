//
//  SCCustomNavigationBaseViewController.h
//  SevenColorMovies
//
//  Created by yesdgq on 2017/6/15.
//  Copyright © 2017年 yesdgq. All rights reserved.
//  自定义导航栏的Base VC

#import <UIKit/UIKit.h>

@interface SCCustomNavigationBaseViewController : UIViewController

/** 伪导航栏 */
@property (nonatomic, strong) UIView *navBar;
/** 返回按钮 */
@property (nonatomic, strong) UIButton *goBackBtn;
/** 标题 Label */
//@property (nonatomic, strong) UILabel *titleLabel;
/** 标题 Button */
@property (nonatomic, strong) UIButton *titleButton;


/** 返回按钮 */
@property (nonatomic,strong) UILabel *leftBBI;

- (instancetype)initWithWithTitle:(NSString *)title;


@end
