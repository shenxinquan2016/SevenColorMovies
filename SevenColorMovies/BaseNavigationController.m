//
//  SCBaseNavigationController.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/18.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  手势返回基类

#import "BaseNavigationController.h"
#import "NavigationInteractiveTransition.h"
#import <objc/runtime.h>
#import "SCLovelyBabyRegisterVC.h"
#import "SCLovelyBabyLoginVC.h"

@interface BaseNavigationController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NavigationInteractiveTransition *navTransition;

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationBar.hidden = YES;
    
    // built-in pop recognizer
    UIGestureRecognizer *recognizer = self.interactivePopGestureRecognizer;
    recognizer.enabled = NO;
    UIView *gestureView = recognizer.view;
    
    // pop recognizer
    UIPanGestureRecognizer *popRecognizer = [[UIPanGestureRecognizer alloc] init];
    popRecognizer.delegate = self;
    popRecognizer.maximumNumberOfTouches = 1;
    [gestureView addGestureRecognizer:popRecognizer];
    self.popRecognizer = popRecognizer;
    
    // taget-action reflect
    NSMutableArray *actionTargets = [recognizer valueForKey:@"_targets"];
    id actionTarget = [actionTargets firstObject];
    id target = [actionTarget valueForKey:@"_target"];
    SEL action = NSSelectorFromString(@"handleNavigationTransition:");
    [popRecognizer addTarget:target action:action];
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    
//    return self.viewControllers.count > 1 && ![[self valueForKey:@"_isTransitioning"] boolValue] && [gestureRecognizer translationInView:gestureRecognizer.view].x > 0;
    
    // 当要popto的页面为登录或注册页时 不返回
    //    DONG_Log(@"viewControllers -->%@",self.viewControllers);
    //    DONG_Log(@"即将返回到的页面VC-->%@",self.childViewControllers[self.viewControllers.count-2]);
    return self.viewControllers.count > 1 && ![[self valueForKey:@"_isTransitioning"] boolValue] && [gestureRecognizer translationInView:gestureRecognizer.view].x > 0 && !([self.childViewControllers[self.viewControllers.count-2] isKindOfClass:[SCLovelyBabyRegisterVC class]]) && !([self.childViewControllers[self.viewControllers.count-2] isKindOfClass:[SCLovelyBabyLoginVC class]]);
}

//支持横竖屏显示
- (BOOL)shouldAutorotate
{
    return [self.viewControllers.lastObject shouldAutorotate];
}

//支持设备自动旋转
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.viewControllers.lastObject supportedInterfaceOrientations];
}

@end
