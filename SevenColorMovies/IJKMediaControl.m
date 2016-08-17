//
//  IJKMediaControl.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/15.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "IJKMediaControl.h"
#import <IJKMediaFramework/IJKMediaFramework.h>

@interface IJKMediaControl ()

@property (nonatomic, assign) BOOL isRotate;

@end

@implementation IJKMediaControl

{
    BOOL _isMediaSliderBeingDragged;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{   self.isRotate = NO;
    [self setupProgressSlider];//自定义UISlider
    [self refreshMediaControl];
    [self showAndFade];
}

// 自定义UISlider的样式和滑块
- (void)setupProgressSlider{
    // 轨道图片
    UIImage *stetchLeftTrack = [UIImage imageNamed:@"LeftTrack"];
    UIImage *stetchRightTrack = [UIImage imageNamed:@"RightTrack"];
    //滑块图片
    UIImage *thumbImage = [UIImage imageNamed:@"thumb"];
    UIImage *thumb_ClickedImage = [UIImage imageNamed:@"thumb_Click"];
    //设置轨道的图片
    [self.progressSlider setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
    [self.progressSlider setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];
    //设置滑块的图片
    [self.progressSlider setThumbImage:thumbImage forState:UIControlStateNormal];
    [self.progressSlider setThumbImage:thumb_ClickedImage forState:UIControlStateHighlighted];
}

- (void)showNoFade
{
    self.overlayPanel.hidden = NO;
    [self cancelDelayedHide];
    [self refreshMediaControl];
}

- (void)showAndFade
{
    [self showNoFade];
    [self performSelector:@selector(hide) withObject:nil afterDelay:5];
}

- (void)hide
{
    self.overlayPanel.hidden = YES;
    [self cancelDelayedHide];
}

- (void)cancelDelayedHide
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
}

- (void)beginDragMediaSlider
{
    _isMediaSliderBeingDragged = YES;
}

- (void)endDragMediaSlider
{
    _isMediaSliderBeingDragged = NO;
}

- (void)continueDragMediaSlider
{
    [self refreshMediaControl];
}

- (void)refreshMediaControl
{
    // duration
    NSTimeInterval duration = self.delegatePlayer.duration;
    NSInteger intDuration = duration + 0.5;
    if (intDuration > 0) {
        self.progressSlider.maximumValue = duration;
        self.totalDurationLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", (int)(intDuration / 3600), (int)((intDuration % 3600) / 60), (int)(intDuration % 60)];
    } else {
        self.totalDurationLabel.text = @"--:--:--";
        self.progressSlider.maximumValue = 1.0f;
    }
    
    
    // position
    NSTimeInterval position;
    if (_isMediaSliderBeingDragged) {
        position = self.progressSlider.value;
    } else {
        position = self.delegatePlayer.currentPlaybackTime;
    }
    NSInteger intPosition = position + 0.5;
    if (intDuration > 0) {
        self.progressSlider.value = position;
    } else {
        self.progressSlider.value = 0.0f;
    }
    
    self.currentTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",(int)(intPosition / 3600), (int)(intPosition % 3660) / 60, (int)(intPosition % 60)];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshMediaControl) object:nil];
    if (!self.overlayPanel.hidden) {
        [self performSelector:@selector(refreshMediaControl) withObject:nil afterDelay:0.5];
    }
}



#pragma mark - IBAction

/** 控制面板底层 */
- (IBAction)onClickMediaControl:(id)sender {
    [self showAndFade];

}

- (IBAction)onClickBack:(id)sender {
}

//** 控制面板 */
- (IBAction)onClickOverlay:(id)sender {
    [self hide];
}

//** 播放&暂停 */
- (IBAction)onClickPlay:(id)sender {
    if ([self.delegatePlayer isPlaying]) {
                [self.delegatePlayer pause];
                [self.playButton setImage:[UIImage imageNamed:@"Play"] forState:UIControlStateNormal];
                [self refreshMediaControl];
        
            }else if (![self.delegatePlayer isPlaying]){
                [self.delegatePlayer play];
                [self.playButton setImage:[UIImage imageNamed:@"Pause"] forState:UIControlStateNormal];
                [self refreshMediaControl];
                
            }
}

//** 全屏 */
- (IBAction)onClickFullScreenButton:(id)sender {
    
    if (!self.isRotate) {
        
        [UIView animateWithDuration:0.3 animations:^{
            // 播放器View所在的控制器View
            //            self.view.transform = CGAffineTransformRotate(self.view.transform, M_PI_2);
            //            self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            
            // 播放器view
            self.delegatePlayer.view.transform = CGAffineTransformRotate(self.delegatePlayer.view.transform, M_PI_2);
            self.delegatePlayer.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            
            // 播放控件所在view
            self.transform = CGAffineTransformRotate(self.transform, M_PI_2);
            self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            
            self.isRotate = YES;
            
        }];
        
    }else{
        
        [UIView animateWithDuration:0.3 animations:^{
            // 播放器View所在的控制器View
            //            self.view.transform = CGAffineTransformIdentity;
            //            self.view.frame = CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width*9/16);
            
            // 播放器view
            self.delegatePlayer.view.transform = CGAffineTransformIdentity;
            self.delegatePlayer.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width*9/16);
            
            // 播放控件所在view
            self.transform = CGAffineTransformIdentity;
            self.frame = CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width*9/16);
            
            self.isRotate = NO;
            
        }];
        
    }
    

}

//** 进度条 */
- (IBAction)didSliderTouchDown:(id)sender {
    [self beginDragMediaSlider];
}

- (IBAction)didSliderTouchCancel:(id)sender {
    [self endDragMediaSlider];
}

- (IBAction)didSliderTouchUpOutside:(id)sender {
    [self endDragMediaSlider];
}

- (IBAction)didSliderTouchUpInside:(id)sender {
    self.delegatePlayer.currentPlaybackTime = self.progressSlider.value;
    [self endDragMediaSlider];
}

- (IBAction)didSliderValueChanged:(id)sender {
    [self continueDragMediaSlider];
}
@end
