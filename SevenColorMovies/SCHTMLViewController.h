//
//  SCHTMLViewController.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/12/26.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCHTMLViewController : UIViewController

@property (nonatomic,copy) NSString *url;
@property (nonatomic,assign) BOOL notificationPresentH5;/**< 通知情况下跳转到H5页面 */
@property (nonatomic,copy) NSString *H5Type;/**< H5进入请求的类型 */

@end
