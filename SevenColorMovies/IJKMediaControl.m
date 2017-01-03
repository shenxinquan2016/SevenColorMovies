//
//  IJKMediaControl.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/15.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "IJKMediaControl.h"
#import <IJKMediaFramework/IJKMediaFramework.h>

typedef NS_ENUM(NSUInteger, Direction) {
    DirectionLeftOrRight,
    DirectionUpOrDown,
    DirectionNone
};

@interface IJKMediaControl ()

@property (nonatomic,strong) SCChangeBrightnessAndVolumeTool *changeBrightnessAndVolumeToolView;

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
{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    
    self.goBackButton.enlargedEdge = 100.f;
    [self setupProgressSlider];//自定义UISlider
    [self refreshMediaControl];
    [self showNoFade];
    self.programNameLabel.hidden = YES;
    self.programNameRunLabel.textAlignment = NSTextAlignmentLeft;
    self.goFastView.hidden = YES;
    self.playButton.hidden = YES;//第一次加载时隐藏
    self.fullScreenLockButton.hidden = YES;
    
    //根据手势获取系统音量
    _changeBrightnessAndVolumeToolView = [[SCChangeBrightnessAndVolumeTool alloc] init];
    _changeBrightnessAndVolumeToolView.panView = self;
    [_changeBrightnessAndVolumeToolView setVolumeView:self];
    
    // 添加平移手势，用来控制音量亮度和快进快退
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panViewChange:)];
    [self addGestureRecognizer:pan];
    
}


- (void)panViewChange:(UIPanGestureRecognizer *)pan
{
    [_changeBrightnessAndVolumeToolView panDirection:pan];
    
    [self showAndFade];
}

// 自定义UISlider的样式和滑块
- (void)setupProgressSlider
{
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
    self.overlayPanel.alpha = 1;
    self.playButton.hidden = NO;
    [self cancelDelayedHide];
    [self refreshMediaControl];
}

- (void)showAndFade
{
    [self showNoFade];
    self.playButton.hidden = NO;
    [self performSelector:@selector(hide) withObject:nil afterDelay:3];
}

- (void)hide
{
    [UIView animateWithDuration:0.2 animations:^{
        self.overlayPanel.alpha = 0;
        
    }];
    
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
    // duration 秒（S）
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
    if (self.overlayPanel.alpha != 0) {
        [self performSelector:@selector(refreshMediaControl) withObject:nil afterDelay:0.5];
    }
}



@end
