//
//  IJKMediaControl.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/15.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "IJKMediaControl.h"
#import <IJKMediaFramework/IJKMediaFramework.h>

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
{
    [self refreshMediaControl];
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
        self.totalDurationLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)(intDuration / 60), (int)(intDuration % 60)];
    } else {
        self.totalDurationLabel.text = @"--:--";
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
    self.currentTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)(intPosition / 60), (int)(intPosition % 60)];
    
    
    // status
    BOOL isPlaying = [self.delegatePlayer isPlaying];
    self.playButton.hidden = isPlaying;
    self.pauseButton.hidden = !isPlaying;
    
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshMediaControl) object:nil];
    if (!self.overlayPanel.hidden) {
        [self performSelector:@selector(refreshMediaControl) withObject:nil afterDelay:0.5];
    }
}



@end
