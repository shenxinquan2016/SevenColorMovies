//
//  SCSoundRecordingTool.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/12/20.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCSoundRecordingTool : NSObject

/**
 *  初始化方法
 *
 *  @param filePath   录音文件保存路径
 *  @param sampleRate 录音采样率
 *
 *  @return 实例
 */
- (instancetype)initWithRecordFilePath:(NSString *)filePath sampleRate:(float)sampleRate;

/** 开始录音 */
- (void)startRecord;
/** 暂停录音 */
- (void)pauseRecord;
/** 恢复录音 */
- (void)resumeRecord;
/** 停止录音 */
- (void)stopRecord;
/** 播放录音 */
- (void)playRecord;

/**
 *  wav转换到amr
 *
 *  @param aWavPath  wav文件路径
 *  @param aSavePath amr保存路径
 *
 *  @return 0失败 1成功
 */
+ (int)ConvertWavToAmr:(NSString *)aWavPath amrSavePath:(NSString *)aSavePath;

/**
 *  amr转换到wav
 *
 *  @param aAmrPath  amr文件路径
 *  @param aSavePath wav保存路径
 *
 *  @return 0失败 1成功
 */
+ (int)ConvertAmrToWav:(NSString *)aAmrPath wavSavePath:(NSString *)aSavePath;

@end
