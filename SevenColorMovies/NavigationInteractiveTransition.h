//
//  NavigationInteractiveTransition.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/18.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIViewController, UIPercentDrivenInteractiveTransition;

@interface NavigationInteractiveTransition : NSObject <UINavigationControllerDelegate>

- (instancetype)initWithVc:(UIViewController *)vc;
- (void)handlePop:(UIPanGestureRecognizer *)recognizer;
- (UIPercentDrivenInteractiveTransition *)interactivePopTransition;

@end
