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
//@property (weak, nonatomic) IBOutlet UIView *overlayPanel;
//@property (weak, nonatomic) IBOutlet UIView *bottomPanel;
//@property (weak, nonatomic) IBOutlet UIView *topPanel;
//
//@property (weak, nonatomic) IBOutlet UIButton *playButton;
//
//@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
//@property (weak, nonatomic) IBOutlet UILabel *totalDurationLabel;
//@property (weak, nonatomic) IBOutlet UISlider *progressSlider;

@property (weak, nonatomic) IBOutlet UIControl *overlayPanel;
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



//- (IBAction)onClickBack:(id)sender;/** 返回 */
//- (IBAction)onClickMediaControl:(id)sender;/** 控制面板底层 */
//- (IBAction)onClickOverlay:(id)sender;/** 控制面板 */
//- (IBAction)onClickPlay:(id)sender;/** 播放&暂停 */
//- (IBAction)onClickFullScreenButton:(id)sender;/** 全屏 */
//
//
//
//- (IBAction)didSliderTouchDown:(id)sender;/** 进度条 */
//- (IBAction)didSliderTouchCancel:(id)sender;
//- (IBAction)didSliderTouchUpOutside:(id)sender;
//- (IBAction)didSliderTouchUpInside:(id)sender;
//- (IBAction)didSliderValueChanged:(id)sender;
- (IBAction)onClickMediaControl:(id)sender;

- (IBAction)onClickBack:(id)sender;
- (IBAction)onClickOverlay:(id)sender;
- (IBAction)onClickPlay:(id)sender;
- (IBAction)onClickFullScreenButton:(id)sender;


- (IBAction)didSliderTouchDown:(id)sender;
- (IBAction)didSliderTouchCancel:(id)sender;
- (IBAction)didSliderTouchUpOutside:(id)sender;
- (IBAction)didSliderTouchUpInside:(id)sender;
- (IBAction)didSliderValueChanged:(id)sender;


@end
