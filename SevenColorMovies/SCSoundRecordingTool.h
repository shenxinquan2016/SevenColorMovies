//
//  SCSoundRecordingTool.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/12/20.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCSoundRecordingTool : NSObject

- (instancetype)initWithrecordFilePath:(NSString *)filePath;

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
 *  转换wav到amr
 *
 *  @param aWavPath  wav文件路径
 *  @param aSavePath amr保存路径
 *
 *  @return 0失败 1成功
 */
+ (int)ConvertWavToAmr:(NSString *)aWavPath amrSavePath:(NSString *)aSavePath;


@end
