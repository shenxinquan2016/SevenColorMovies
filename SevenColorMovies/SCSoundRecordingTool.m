//
//  SCSoundRecordingTool.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/12/20.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCSoundRecordingTool.h"
#import <AVFoundation/AVFoundation.h>

@interface SCSoundRecordingTool ()

/** session */
@property (nonatomic, strong) AVAudioSession *session;
/** 录音器 */
@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
/** 播放器 */
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
/** 存放路径 */
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, strong) NSURL *recordFileUrl;
/** 录音声波监控（这里暂时不对播放进行监控） */
@property (nonatomic, strong) NSTimer *timer;
/** 音频波动 */
@property (nonatomic, strong) UIProgressView *audioPower;

@end

@implementation SCSoundRecordingTool
{
    NSTimer *_timer; //定时器
    NSInteger countDown;  //倒计时
}

- (instancetype)initWithrecordFilePath:(NSString *)filePath
{
    if (self = [super init]) {
        // 设置音频会话 设置为播放和录音状态，以便可以在录制完之后播放录音
        AVAudioSession *session =[AVAudioSession sharedInstance];
        NSError *sessionError;
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
        
        if (session == nil) {
            DONG_Log(@"Error creating session: %@",[sessionError description]);
        }else{
            [session setActive:YES error:nil];
        }
        
        self.session = session;
        
        //1.获取沙盒地址
        NSString *documentPath = [FileManageCommon GetTmpPath];
        self.filePath = [documentPath stringByAppendingPathComponent:@"/SoundRecord.caf"];
        
        self.filePath = filePath;
        //2.获取文件路径url
        self.recordFileUrl = [NSURL URLWithString:filePath];
        
        //3.设置参数
        NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                       // 采样率  8000/11025/22050/44100/96000（影响音频的质量）
                                       [NSNumber numberWithFloat: 8000.0],AVSampleRateKey,
                                       // 音频格式
                                       [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                       // 采样位数  8、16、24、32 默认为16
                                       [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                       // 音频通道数 1 或 2
                                       [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                                       // 录音质量
                                       [NSNumber numberWithInt:AVAudioQualityHigh],AVEncoderAudioQualityKey,
                                       nil];
        
        _audioRecorder = [[AVAudioRecorder alloc] initWithURL:_recordFileUrl settings:recordSetting error:nil];

    }
    
    return self;
}

/** 开始录音 */
- (void)startRecord
{
    if (_audioRecorder) {
        
        _audioRecorder.meteringEnabled = YES;
        [_audioRecorder prepareToRecord];
        [_audioRecorder record];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self stopRecord];
        });
        
    }else{
        DONG_Log(@"音频格式和文件存储格式不匹配,无法初始化Recorder");
        
    }
}

/** 暂停录音 */
- (void)pauseRecord
{
    if ([self.audioRecorder isRecording]) {
        [self.audioRecorder pause];
    }
}

/** 恢复录音 */
- (void)resumeRecord
{
    // 恢复录音只需要再次调用record，AVAudioSession会帮助你记录上次录音位置并追加录音
    [self startRecord];
}

/** 停止录音 */
- (void)stopRecord
{
    if ([self.audioRecorder isRecording]) {
        [self.audioRecorder stop];
    }
}

/** 播放录音 */
- (void)playRecord
{
    NSLog(@"播放录音");
    [self.audioRecorder stop];
    
    if ([self.audioPlayer isPlaying]) return;
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recordFileUrl error:nil];
    
    DONG_Log(@"%li",self.audioPlayer.data.length/1024);
    
    [self.session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [self.audioPlayer play];
}

/** 添加定时器 */
- (void)addTimer
{
    _timer=[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(audioPowerChange) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

/** 移除定时器 */
- (void)removeTimer
{
    [_timer invalidate];
    _timer = nil;
    
}

/**
 *  录音声波监控定制器
 *
 *  @return 定时器
 */
-(NSTimer *)timer
{
    if (!_timer) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(audioPowerChange) userInfo:nil repeats:YES];
    }
    return _timer;
}

/**
 *  录音声波状态设置
 */
-(void)audioPowerChange
{
    [self.audioRecorder updateMeters];//更新测量值
    float power= [self.audioRecorder averagePowerForChannel:0];//取得第一个通道的音频，注意音频强度范围时-160到0
    CGFloat progress=(1.0/160.0)*(power+160.0);
    [self.audioPower setProgress:progress];
}



@end
