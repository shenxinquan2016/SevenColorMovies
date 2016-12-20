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
/** 录音声波监控（注意这里暂时不对播放进行监控） */
@property (nonatomic,strong) NSTimer *timer;

@end

@implementation SCSoundRecordingTool

/** 开始录音 */
- (void)startRecord
{
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
    //2.获取文件路径url
    self.recordFileUrl = [NSURL URLWithString:_filePath];
    
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
    
    _audioRecorder = [[AVAudioRecorder alloc] initWithURL:self.recordFileUrl settings:recordSetting error:nil];
    
    if (_audioRecorder) {
        
        _audioRecorder.meteringEnabled = YES;
        [_audioRecorder prepareToRecord];
        [_audioRecorder record];
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            
//            [self stopRecord];
//        });
        
        
        
    }else{
        NSLog(@"音频格式和文件存储格式不匹配,无法初始化Recorder");
        
    }
}

/** 暂停录音 */
- (void)pauseRecord
{
    
}

/** 恢复录音 */
- (void)resumeRecord
{
    
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
    
    
    NSLog(@"%li",self.audioPlayer.data.length/1024);
    
    [self.session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [self.audioPlayer play];
}



@end
