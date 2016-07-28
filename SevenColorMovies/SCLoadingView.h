//
//  SCLoadingView.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/27.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCLoadingView : UIView

+ (instancetype)shareManager;


- (void)showLoadingTitle:(NSString *)title;

- (void)dismiss;

@end
