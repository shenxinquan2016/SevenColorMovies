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



@end
