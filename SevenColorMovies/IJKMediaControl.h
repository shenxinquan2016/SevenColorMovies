//
//  IJKMediaControl.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/15.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol IJKMediaPlayback;

@interface IJKMediaControl : UIControl

@property(nonatomic,weak) id<IJKMediaPlayback> delegatePlayer;
@property (weak, nonatomic) IBOutlet UIView *overlayPanel;
@property (weak, nonatomic) IBOutlet UIView *bottomPanel;
@property (weak, nonatomic) IBOutlet UIView *topPanel;

@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalDurationLabel;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;

- (void)showNoFade;
- (void)showAndFade;
- (void)hide;
- (void)refreshMediaControl;

- (void)beginDragMediaSlider;
- (void)endDragMediaSlider;
- (void)continueDragMediaSlider;


@end
