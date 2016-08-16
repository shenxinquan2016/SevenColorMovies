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


@interface IJKMoviePlayerVC : UIViewController

@property(atomic,strong) NSURL *url;
@property(atomic, retain) id<IJKMediaPlayback> player;

- (id)initWithURL:(NSURL *)url;

+ (void)presentFromViewController:(UIViewController *)viewController withTitle:(NSString *)title URL:(NSURL *)url completion:(void(^)())completion;



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


@end
