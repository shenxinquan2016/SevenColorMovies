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

@property(atomic,strong) NSURL *url;
@property(atomic, retain) id<IJKMediaPlayback> player;
@property (nonatomic, copy) DoBackActionBlock doBackActionBlock;

- (id)initWithURL:(NSURL *)url;

+ (void)presentFromViewController:(UIViewController *)viewController withTitle:(NSString *)title URL:(NSURL *)url completion:(void(^)())completion;
+ (instancetype)initIJKPlayerWithTitle:(NSString *)title URL:(NSURL *)url;
-(void)installMovieNotificationObservers;
-(void)removeMovieNotificationObservers;

- (IBAction)onClickMediaControl:(id)sender;
- (IBAction)onClickOverlay:(id)sender;
- (IBAction)onClickBack:(id)sender;

- (IBAction)onClickPlay:(id)sender;
- (IBAction)onClickPause:(id)sender;

- (IBAction)didSliderTouchDown:(id)sender;
- (IBAction)didSliderTouchCancel:(id)sender;
- (IBAction)didSliderTouchUpOutside:(id)sender;
- (IBAction)didSliderTouchUpInside:(id)sender;
- (IBAction)didSliderValueChanged:(id)sender;

@property (strong, nonatomic) IBOutlet IJKMediaControl *mediaControl;

@end
