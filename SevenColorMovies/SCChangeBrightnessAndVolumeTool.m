//
//  SCChangeBrightnessAndVolumeTool.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/18.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  手势调节声音 & 屏幕亮度 & 播放器播放进度

#import "SCChangeBrightnessAndVolumeTool.h"
#import "IJKVideoPlayerVC.h"

@interface SCChangeBrightnessAndVolumeTool ()

@property (nonatomic, strong) UILabel *horizontalLabel;

@end

@implementation SCChangeBrightnessAndVolumeTool

{
    UISlider *volumeViewSlider;
    float systemVolume;//系统音量值
    PanDirection panDirection; // 定义一个实例变量，保存枚举值
    CGPoint satrtPoint;//起始点
    
}

#pragma mark- Initialize
- (instancetype)init{
    self = [super init];
    if (self) {
        
        
    }
    return self;
}

- (void)setVolumeView:(IJKMediaControl *)vc{
    
    _mediaControlView = vc;
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    volumeView.backgroundColor = [UIColor redColor];
    volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            volumeViewSlider = (UISlider *)view;
            break;
        }
    }
    systemVolume = volumeViewSlider.value;
}

- (void)panDirection:(UIPanGestureRecognizer *)pan
{
    // 我们要响应水平移动和垂直移动
    // 根据上次和本次移动的位置，算出一个速率的point
    CGPoint veloctyPoint = [pan velocityInView:self.panView];
    //    locationInView
    // 判断是垂直移动还是水平移动
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{ // 开始移动
            //                        NSLog(@"x:%f  y:%f",veloctyPoint.x, veloctyPoint.y);
            //获取起点
            satrtPoint = [pan locationInView:self.panView];
            // 使用绝对值来判断移动的方向
            CGFloat x = fabs(veloctyPoint.x);
            CGFloat y = fabs(veloctyPoint.y);
            
            if (x > y) { // 水平移动 控制快进
                
                [self.mediaControlView showAndFade];//控件显示出来
                panDirection = PanDirectionHorizontalMoved;
                // 取消隐藏
                self.mediaControlView.goFastView.hidden = NO;
                // 给sumTime初值
                _sumTime = _mediaControlView.delegatePlayer.currentPlaybackTime;
                
            }
            else if (x < y){ // 垂直移动 控制音量
                panDirection = PanDirectionVerticalMoved;
                // 显示音量控件
                //                self.volume.hidden = NO;
                // 开始滑动的时候，状态改为正在控制音量
                //                isVolume = YES;
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{ // 正在移动
            
//            NSLog(@"x:%f  y:%f",veloctyPoint.x, veloctyPoint.y);
            
            switch (panDirection) {
                case PanDirectionHorizontalMoved:{
                    [self.mediaControlView showAndFade];//控件显示出来
                    [self horizontalMoved:veloctyPoint.x]; // 水平移动的方法只要x方向的值
                    break;
                }
                case PanDirectionVerticalMoved:{
                    [self verticalMoved:veloctyPoint.y]; // 垂直移动方法只要y方向的值
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{ // 移动停止
            // 移动结束也需要判断垂直或者平移
            // 比如水平移动结束时，要快进到指定位置，如果这里没有判断，当我们调节音量完之后，会出现屏幕跳动的bug
            switch (panDirection) {
                case PanDirectionHorizontalMoved:{
                    // 隐藏视图
                    self.mediaControlView.goFastView.hidden = YES;
                    // ⚠️在滑动结束后，视屏要跳转
                    self.mediaControlView.delegatePlayer.currentPlaybackTime = _sumTime;
                    // 把sumTime滞空，不然会越加越多
                    _mediaControlView.delegatePlayer.currentPlaybackTime = _sumTime;
                    _sumTime = 0;
                    break;
                }
                case PanDirectionVerticalMoved:{
                    // 垂直移动结束后，隐藏音量控件
                    //                    self.volume.hidden = YES;
                    // 且，把状态改为不再控制音量
                    //                    isVolume = NO;
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}
#pragma mark - pan垂直移动的方法 音控
- (void)verticalMoved:(CGFloat)value
{
    
    if (satrtPoint.x <= self.panView.bounds.size.width/2.0)
    {   //调节亮度
        [[UIScreen mainScreen] setBrightness:[UIScreen mainScreen].brightness - (value / 10000)];
        
    }else
    {   //调节音量
        volumeViewSlider.value -= value /10000;
        systemVolume = volumeViewSlider.value;
        
    }
    
}

#pragma mark - pan水平移动的方法 快进
- (void)horizontalMoved:(CGFloat)value
{
    // 快进快退的图标
    NSString *imageStyle = @"";
    if (value < 0) {
        imageStyle = @"FastRewind";
    }
    else if (value > 0){
        imageStyle = @"FastForward";
    }
    
    // 每次滑动需要叠加时间
    _sumTime += value / 10;
    
    // 需要限定sumTime的范围
    if (_sumTime > _mediaControlView.delegatePlayer.duration) {
        _sumTime = _mediaControlView.delegatePlayer.duration;
    }else if (_sumTime < 0){
        _sumTime = 0;
    }
    
    [self.mediaControlView.goFastImageView setImage:[UIImage imageNamed:imageStyle]];
    self.mediaControlView.progressSlider.value = _sumTime;
    self.mediaControlView.delegatePlayer.currentPlaybackTime = self.mediaControlView.progressSlider.value;
    
    // 当前快进的时间
    NSString *nowTime = [self durationStringWithTime:(int)_sumTime];
    // 总时间
    NSString *durationTime = [self durationStringWithTime:(int)_mediaControlView.delegatePlayer.duration];
    // 给label赋值
    self.mediaControlView.currentLabel.text = [NSString stringWithFormat:@"%@",nowTime];
    self.mediaControlView.durationTimeLabel.text = [NSString stringWithFormat:@"/ %@",durationTime];
    
}

#pragma mark - 根据时长求出字符串
- (NSString *)durationStringWithTime:(int)time
{
    //获取小时
    NSString *hour = [NSString stringWithFormat:@"%02d",time / 3600];
    // 获取分钟
    NSString *min = [NSString stringWithFormat:@"%02d",time % 3600 / 60];
    // 获取秒数
    NSString *sec = [NSString stringWithFormat:@"%02d",time % 60];
    return [NSString stringWithFormat:@"%@:%@:%@",hour, min, sec];
}


@end

