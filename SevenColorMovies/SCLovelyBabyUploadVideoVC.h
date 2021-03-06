//
//  SCLovelyBabyUploadVideoVC.h
//  SevenColorMovies
//
//  Created by yesdgq on 2017/6/23.
//  Copyright © 2017年 yesdgq. All rights reserved.
//  视频编辑上传

#import "SCOtherBaseViewController.h"

@interface SCLovelyBabyUploadVideoVC : SCOtherBaseViewController

@property (nonatomic, copy) NSString *videoFilePath; // 视频路径
@property (nonatomic, strong) UIImage *videoCoverImage; // 视频第一帧图片
@property (nonatomic, assign) NSInteger videoLength; // 视频长度

@end
