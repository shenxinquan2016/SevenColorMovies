//
//  IJKMoviePlayerVC.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/15.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IJKMediaFramework/IJKMediaFramework.h>
@class IJKMediaControl;

typedef void(^DoBackActionBlock)(void);/** 返回按钮通过block实现 */

@interface IJKVideoPlayerVC : UIViewController

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, retain) id<IJKMediaPlayback> player;
@property (nonatomic, copy) DoBackActionBlock doBackActionBlock;

- (id)initWithURL:(NSURL *)url;

+ (void)presentFromViewController:(UIViewController *)viewController withTitle:(NSString *)title URL:(NSURL *)url completion:(void(^)())completion;
+ (instancetype)initIJKPlayerWithTitle:(NSString *)title URL:(NSURL *)url;




@property (nonatomic, strong) IJKMediaControl *mediaControl;






@end
