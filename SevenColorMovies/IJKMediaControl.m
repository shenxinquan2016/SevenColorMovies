//
//  IJKMediaControl.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/15.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "IJKMediaControl.h"
#import <IJKMediaFramework/IJKMediaFramework.h>

typedef NS_ENUM (NSUInteger, Direction) {
    DirectionLeftOrRight,
    DirectionUpOrDown,
    DirectionNone
};

@interface IJKMediaControl ()

@property (nonatomic, strong) SCChangeBrightnessAndVolumeTool *changeBrightnessAndVolumeToolView;


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
    //    [self refreshMediaControl];
    //    [self refreshMediaControlWhenLive];
    [self showNoFade];
    self.programNameLabel.hidden = YES;
    self.programNameRunLabel.textAlignment = NSTextAlignmentLeft;
    self.goFastView.hidden = YES;
    self.fullScreenLockButton.hidden = YES;
    self.isLive = NO;//默认设置为NO
    
    // 根据手势获取系统音量
    _changeBrightnessAndVolumeToolView = [[SCChangeBrightnessAndVolumeTool alloc] init];
    _changeBrightnessAndVolumeToolView.panView = self;
    [_changeBrightnessAndVolumeToolView setVolumeView:self];
    // 手势滑动时时移回调
    DONG_WeakSelf(self);
    _changeBrightnessAndVolumeToolView.touchMovedTimeShiftBlock = ^(NSString *liveState, int positionTime) {
        if (weakself.timeShiftBlock) {
            weakself.timeShiftBlock(liveState, positionTime);
        }
    };
    
    // 1.添加平移手势，用来控制音量亮度和快进快退
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panViewChange:)];
    [self addGestureRecognizer:pan];
    
}


- (void)panViewChange:(UIPanGestureRecognizer *)pan
{
    [_changeBrightnessAndVolumeToolView panDirection:pan];
    
}


//#pragma mark--------触摸开始时调用此方法

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //获取任意一个touch对象
    UITouch * pTouch = [touches anyObject];
    //获取对象所在的坐标
    CGPoint point = [pTouch locationInView:self];
    //以字符的形式输出触摸点
    DONG_Log(@"触摸点的坐标：%@",NSStringFromCGPoint(point));
    //获取触摸的次数
    NSUInteger tapCount = [pTouch tapCount];
    //对触摸次数判断
    if (tapCount == 1) {
        //在0.2秒内只触摸一次视为单击
        [self performSelector:@selector(singleTouch:) withObject:nil afterDelay:0.2];
    } else if (tapCount == 2) {
        //取消单击响应，若无此方法则双击看做是：单击事件和双击事件
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleTouch:) object:nil];
        //确定为双击事件
        [self doubleTouch:nil];
    }
}

// 单击方法
- (void)singleTouch:(id)sender
{
    DONG_Log(@"此时是单击的操作");
    [self showAndFade];
}

// 双击方法
- (void)doubleTouch:(id)sender
{
    if ([_delegatePlayer isPlaying]) {
        [_delegatePlayer pause];
        // 暂停时显示广告层
        self.advertisementIV.hidden = NO;
        [self.playButton setImage:[UIImage imageNamed:@"Play"] forState:UIControlStateNormal];
        [self refreshMediaControl];
        
    } else if (![_delegatePlayer isPlaying]){
        [_delegatePlayer play];
        // 播放时隐藏广告层
        self.advertisementIV.hidden = YES;
        [self.playButton setImage:[UIImage imageNamed:@"Pause"] forState:UIControlStateNormal];
        [self refreshMediaControl];
        
    }
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
    [self cancelDelayedHide];
    
    if (_isLive) {
        [self refreshMediaControlWhenLive];
    } else {
        [self refreshMediaControl];
    }
}

- (void)showAndFade
{
    [self showNoFade];
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
    if (_isLive) {
        [self refreshMediaControlWhenLive];
    } else {
        [self refreshMediaControl];
    }
    
}

// 点播刷新 除拖拽progressSlider时，数据源均来自self.delegatePlayer
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
        [self performSelector:@selector(refreshMediaControl) withObject:nil afterDelay:1.0];
    }
}

// 直播和时移时刷新 除拖拽progressSlider时，数据源均来自self.delegatePlayer
- (void)refreshMediaControlWhenLive
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshMediaControl) object:nil];
    
    // duration 秒（S）
    NSTimeInterval duration = 6 * 3600;// 支持6个小时内的时移
    NSInteger intDuration = duration + 0.5;
    self.progressSlider.maximumValue = intDuration;
    
    // label
    NSDate *date = [NSDate date];// 格林尼治时间
    NSString *dateString = [NSDate dateStringFromDate:date withDateFormat:@"HH:mm:ss"];
    NSTimeInterval seconds = - 6*3600;
    NSDate *crrrentLabelDate = [date dateByAddingTimeInterval:seconds];
    NSString *currentLabelString = [NSDate dateStringFromDate:crrrentLabelDate withDateFormat:@"HH:mm:ss"];
    self.totalDurationLabel.text = dateString;
    self.currentTimeLabel.text   = currentLabelString;
    
    NSTimeInterval position;
    
    if (_isMediaSliderBeingDragged) {
        position = self.progressSlider.value;
        self.firmPosition = self.progressSlider.value;
        
    } else {
        
        position = self.firmPosition;
    }
    
    self.progressSlider.value = position;
    
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshMediaControlWhenLive) object:nil];
    if (self.overlayPanel.alpha != 0) {
        [self performSelector:@selector(refreshMediaControlWhenLive) withObject:nil afterDelay:1.0];
    }
    
}

- (void)setIsLive:(BOOL)isLive
{
    _isLive = isLive;
    if (isLive) {
        // Live时，进度条初始位置放在最右侧
        if (_liveState == Live) {
            // duration 秒（S）
            NSTimeInterval duration = 6 * 3600;// 支持6个小时内的时移
            NSInteger intDuration = duration + 0.5;
            self.firmPosition = intDuration;
        }
        
        // 直播刷新
        [self refreshMediaControlWhenLive];
        
    } else {
        // 点播刷新
        [self refreshMediaControl];
    }
}



@end
