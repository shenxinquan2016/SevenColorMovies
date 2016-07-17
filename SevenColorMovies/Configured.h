//
//  Configured.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/15.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#ifndef Configured_h
#define Configured_h

#import <objc/runtime.h>//按钮添加多个参数
#import <Masonry.h>
#import "Reachability.h" //网络监听



#if __has_feature(objc_arc)
//#import <ReactiveCocoa.h>
#endif


//#import <AFNetworking/AFNetworking.h>


#endif /* Configured_h */







/**************************************
 * storyboard实例化
 *************************************/
#define DD_STORYBOARD(storyboardName)          [UIStoryboard storyboardWithName:storyboardName bundle:nil]
#define DD_INSTANT_VC_WITH_ID(storyboardName,vcIdentifier)  [DD_STORYBOARD(storyboardName) instantiateViewControllerWithIdentifier:vcIdentifier]


















