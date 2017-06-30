//
//  SCLovelyBabyRecordVideoVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/6/23.
//  Copyright © 2017年 yesdgq. All rights reserved.
//  视频录制

#import "SCLovelyBabyRecordVideoVC.h"
#import <AVFoundation/AVFoundation.h>

#define MAXVIDEOTIME 60 // 视频最大时间
#define MINCIDEOTIME 20 // 视频最小时间

typedef void(^PropertyChangeBlock)(AVCaptureDevice *captureDevice);

@interface SCLovelyBabyRecordVideoVC () <AVCaptureFileOutputRecordingDelegate>

/**  */
@property (nonatomic, strong) AVCaptureSession *captureSession;
/**  */

/**  */
@property (nonatomic, strong) AVCaptureDeviceInput *videoCaptureDeviceInput;
/**  */
@property (nonatomic, strong) AVCaptureDeviceInput *audioCaptureDeviceInput;
/**  */
@property (nonatomic, strong) AVCaptureMovieFileOutput *caputureMovieFileOutput;
/** 视频预览图层 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;

/** 视频拍摄总容器 */
@property (nonatomic, strong)  UIView *viewContainer;
/** 聚焦光标 */
@property (nonatomic, strong) UIImageView *focusCursor;
/** 存放临时视频片段 */
@property (nonatomic, strong) NSMutableArray *videoClipsArray;


@end

@implementation SCLovelyBabyRecordVideoVC

{
    UIView *progressView; // 进度条;
    NSTimer *countTimer; // 计时器
    UIButton *finishBtn; // 录制结束按钮
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置navigationBar上的title颜色和大小
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:18]}];
    self.title = @"00:01:00";
    
    // 导航栏按钮
    [self addBBI];
    // 初始化摄像机
    [self initializeCameraConfiguration];
    // 录制按钮
    [self addVideoRecordBtnView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 设置导航栏的主题(效果只作用当前页面）
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.edgesForExtendedLayout = 0;
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.captureSession startRunning];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    
    //还原数据-----------
//    [self deleteAllVideos];
//    currentTime = 0;
//    [progressPreView setFrame:CGRectMake(0, preLayerHeight, 0, 4)];
//    shootBt.backgroundColor = UIColorFromRGB(0xfa5f66);
//    finishBt.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    [self.captureSession stopRunning];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)addBBI
{
    // 左边
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 32)];
    //    view.backgroundColor = [UIColor redColor];
    // 返回箭头
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Back_Arrow_White"]];
    [view addSubview:imgView];
    //    imgView.backgroundColor = [UIColor grayColor];
    [imgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view);
        make.centerY.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(10, 17));
        
    }];
    // 返回标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 125, 22)];
    //    titleLabel.backgroundColor = [UIColor greenColor];
    
    titleLabel.textColor = [UIColor colorWithHex:@"#878889"];
    titleLabel.font = [UIFont systemFontOfSize: 19.0];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [view addSubview:titleLabel];
    [titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.equalTo(imgView.mas_right).offset(0);
        make.size.mas_equalTo(CGSizeMake(125, 22));
        
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    [view addGestureRecognizer:tap];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:view];
    UIBarButtonItem *leftNegativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
    leftNegativeSpacer.width = -6;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:leftNegativeSpacer,item, nil];
    
    // 右边
    // 闪光灯
    UIButton *flashBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,25)];
    [flashBtn setImage:[UIImage imageNamed:@"FlashSwitch"] forState:UIControlStateNormal];
    [flashBtn addTarget:self action:@selector(switchFlash) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *flashBtnBarItem = [[UIBarButtonItem alloc] initWithCustomView:flashBtn];
    // 切换镜头
    UIButton *switchCameraBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,25,20)];
    [switchCameraBtn setImage:[UIImage imageNamed:@"CameraSwitch"] forState:UIControlStateNormal];
    [switchCameraBtn addTarget:self action:@selector(switchCamera) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *switchCameraBarItem = [[UIBarButtonItem alloc] initWithCustomView:switchCameraBtn];
    
    UIBarButtonItem *rightNegativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
    rightNegativeSpacer.width = 5;
    UIBarButtonItem *rightNegativeSpacer2 = [[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                            target:nil action:nil];
    rightNegativeSpacer2.width = 20;
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:rightNegativeSpacer, switchCameraBarItem,rightNegativeSpacer2,  flashBtnBarItem,  nil];
}

// 录制视频按钮
- (void)addVideoRecordBtnView
{
    UIView *btnBG = [[UIView alloc] init];
    btnBG.backgroundColor = [UIColor blackColor];
    btnBG.alpha = 0.8f;
    [self.view addSubview:btnBG];
    [btnBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(@120);
    }];
    
    // 录制按钮
    UIButton *videoRecordBtn = [[UIButton alloc] init];
    [videoRecordBtn addTarget:self action:@selector(beginVideoRecording) forControlEvents:UIControlEventTouchDown];
    [videoRecordBtn addTarget:self action:@selector(stopVideoRecording) forControlEvents:UIControlEventTouchUpInside];
    [videoRecordBtn setBackgroundImage:[UIImage imageNamed:@"VideoRecordBtnBG"] forState:UIControlStateNormal];
    [btnBG addSubview:videoRecordBtn];
    [videoRecordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(btnBG);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    // 录制完成按钮
    finishBtn = [[UIButton alloc] init];
    finishBtn.alpha = 0.8f;
    [finishBtn addTarget:self action:@selector(VideoRecordingFinish) forControlEvents:UIControlEventTouchUpInside];
    [finishBtn setBackgroundImage:[UIImage imageNamed:@"VideoRecordingFinish"] forState:UIControlStateNormal];
    [btnBG addSubview:finishBtn];
    [finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(btnBG.mas_right).offset(-25);
        make.centerY.equalTo(btnBG);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}

// 初始化摄像机
- (void)initializeCameraConfiguration
{
    // 1.创建视频拍摄总容器
    self.viewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64)];
    [self.view addSubview:_viewContainer];
    
    // 2.创建会话 (AVCaptureSession) 对象。
    self.captureSession = [[AVCaptureSession alloc] init];
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset640x480]) {
        // 设置会话的 sessionPreset 属性, 这个属性影响视频的分辨率
        [_captureSession setSessionPreset:AVCaptureSessionPreset640x480];
    }
    
    // 3.使用AVCaptureDevice的静态方法获得需要使用的设备 获取摄像头输入设备， 创建 AVCaptureDeviceInput 对象
    AVCaptureDevice *videoCaptureDevice = [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];
  
    // 添加一个音频输入设备
    AVCaptureDevice *audioCaptureDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];

    // 4.利用输入设备AVCaptureDevice初始化AVCaptureDeviceInput对象。
    NSError *error;
    _videoCaptureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:videoCaptureDevice error:&error]; // 视频输入对象
    if (error) {
        DONG_Log(@"---- 取得设备输入对象时出错 ------ %@",error);
        return;
    }
    _audioCaptureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioCaptureDevice error:&error]; // 音频输入对象
    if (error) {
        DONG_Log(@"取得设备输入对象时出错 ------ %@",error);
        return;
    }
    
    // 5.初始化输出数据管理对象，如果要拍照就初始化AVCaptureStillImageOutput对象；如果拍摄视频就初始化AVCaptureMovieFileOutput对象
    _caputureMovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    
    
    // 6.将视音频数据输入对象AVCcaptureFileOutput（对应子类）添加到媒体会话管理对象AVCaptureSession中
    if ([_captureSession canAddInput:_videoCaptureDeviceInput]) {
        [_captureSession addInput:_videoCaptureDeviceInput]; // 视频
    }
    if ([_captureSession canAddInput:_audioCaptureDeviceInput]) {
        [_captureSession addInput:_audioCaptureDeviceInput]; // 音频
        // 建立连接
        AVCaptureConnection *captureConnection = [_caputureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        // 标识视频录入时稳定音频流的接受，这里设置为自动
        if ([captureConnection isVideoStabilizationSupported]) {
            captureConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
        }
    }
    
    // 7.创建视频预览图层AVCaptureVideoPreviewLayer并指定媒体会话，添加图层到显示容器中，调用AVCaptureSession的startRuning方法开始捕获。
    // 通过会话 (AVCaptureSession) 创建预览层
    _captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    
    // 显示在视图表面的图层
    CALayer *layer = self.viewContainer.layer;
    layer.masksToBounds = true;
    
    _captureVideoPreviewLayer.frame = layer.bounds;
    _captureVideoPreviewLayer.masksToBounds = true;
    _captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill; // 填充模式
    [layer addSublayer:_captureVideoPreviewLayer];
    
    // 让会话（AVCaptureSession）勾搭好输入输出，然后把视图渲染到预览层上
    [_captureSession startRunning];

    // 8.添加聚焦光标
    self.focusCursor = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 50, 50)];
    [_focusCursor setImage:[UIImage imageNamed:@"FocusCursor"]];
    _focusCursor.alpha = 0.f;
    [_viewContainer addSubview:_focusCursor];
    [self addFocusTapGenstureRecognizer];
    
    // 9.进度条
    progressView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 4)];
    progressView.backgroundColor = [UIColor colorWithHex:@"#24D609"];
    [self.viewContainer addSubview:progressView];
//    UIProgressView *progressView2 = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0)];
//    [self.viewContainer addSubview:progressView2];
//    progressView2.tintColor = [UIColor colorWithHex:@"0xffc738"];
//    progressView2.trackTintColor = [UIColor redColor];
//    self.progressView = progressView2;

    // 10.将设备输出添加到会话中
    if ([_captureSession canAddOutput:_caputureMovieFileOutput]) {
        [_captureSession addOutput:_caputureMovieFileOutput];
    }

    // 11.将捕获的音频或视频数据输出到指定文件
     AVCaptureConnection *captureConnection = [self.caputureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    
    // 12.开启视频防抖模式
    AVCaptureVideoStabilizationMode stabilizationMode = AVCaptureVideoStabilizationModeCinematic;
    if ([self.videoCaptureDeviceInput.device.activeFormat isVideoStabilizationModeSupported:stabilizationMode]) {
        [captureConnection setPreferredVideoStabilizationMode:stabilizationMode];
    }

    // 如果支持多任务则则开始多任务
    if ([[UIDevice currentDevice] isMultitaskingSupported]) {
//        self.backgroundTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    }
    // 预览图层和视频方向保持一致,这个属性设置很重要，如果不设置，那么出来的视频图像可以是倒向左边的。
    captureConnection.videoOrientation = [self.captureVideoPreviewLayer connection].videoOrientation;
    
    // 设置视频输出的文件路径，这里设置为 temp 文件
    NSString *outputFielPath = [NSTemporaryDirectory() stringByAppendingString:@"test.mp4"];
    DONG_Log(@"outputFielPath-->%@", outputFielPath);
    // 路径转换成 URL 要用这个方法，用 NSBundle 方法转换成 URL 的话可能会出现读取不到路径的错误
    NSURL *fileUrl = [NSURL fileURLWithPath:outputFielPath];
    
     // 往路径的 URL 开始写入录像 Buffer ,边录边写
//    [self.caputureMovieFileOutput startRecordingToOutputFileURL:fileUrl recordingDelegate:self];

    // 取消视频拍摄
//    [self.caputureMovieFileOutput stopRecording];
//    [self.captureSession stopRunning];
//    [self completeHandle];
}

// 添加tap手势
- (void)addFocusTapGenstureRecognizer
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusTap:)];
    [self.viewContainer addGestureRecognizer:tapGesture];
}

- (void)focusTap:(UITapGestureRecognizer *)tapGesture
{
    CGPoint point = [tapGesture locationInView:self.viewContainer];
    // 将UI坐标转化为摄像头坐标
    CGPoint cameraPoint = [self.captureVideoPreviewLayer captureDevicePointOfInterestForPoint:point];
    [self setFocusCursorWithPoint:point];
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposureMode:AVCaptureExposureModeAutoExpose atPoint:cameraPoint];
}

-(void)setFocusCursorWithPoint:(CGPoint)point
{
    self.focusCursor.center = point;
    self.focusCursor.transform = CGAffineTransformMakeScale(1.5, 1.5);
    self.focusCursor.alpha = 1.0;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.focusCursor.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.focusCursor.alpha = 0;
    }];
}

// 设置聚焦点
- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point
{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        if ([captureDevice isFocusPointOfInterestSupported]) {
            [captureDevice setFocusPointOfInterest:point];
        }
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        if ([captureDevice isExposurePointOfInterestSupported]) {
            [captureDevice setExposurePointOfInterest:point];
        }
    }];
}


// 取得指定位置的摄像头
-(AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position
{
    NSArray *cameras= [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position]==position) {
            return camera;
        }
    }
    return nil;
}

// 改变设备属性的统一操作方法
- (void)changeDeviceProperty:(PropertyChangeBlock)propertyChange
{
    AVCaptureDevice *captureDevice = [self.videoCaptureDeviceInput device];
    NSError *error;
    // 改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    if ([captureDevice lockForConfiguration:&error]) {
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
        
    } else {
        DONG_Log(@"设置设备属性过程发生错误，错误信息：%@",error.localizedDescription);
    }
}

// 设置闪光灯模式
-(void)setTorchMode:(AVCaptureTorchMode )torchMode
{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isTorchModeSupported:torchMode]) {
            [captureDevice setTorchMode:torchMode];
        }
    }];
}

// 设置聚焦模式
-(void)setFocusMode:(AVCaptureFocusMode )focusMode{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:focusMode];
        }
    }];
}

// 设置曝光模式
- (void)setExposureMode:(AVCaptureExposureMode)exposureMode{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:exposureMode];
        }
    }];
}

#pragma mark - 闪光灯开关

- (void)switchFlash
{
    AVCaptureDevice *captureDevice = [self.videoCaptureDeviceInput device];
    AVCaptureTorchMode flashMode=captureDevice.torchMode;
    
    if ([captureDevice isTorchAvailable]) {
        
        switch (flashMode) {
            case AVCaptureTorchModeAuto:
                
                break;
            case AVCaptureTorchModeOn:
                [self setTorchMode:AVCaptureTorchModeOff];
                break;
            case AVCaptureTorchModeOff:
                [self setTorchMode:AVCaptureTorchModeOn];
                break;
            default:
                break;
        }
    }
}

#pragma mark - 切换摄像头

- (void)switchCamera
{
    AVCaptureDevice *currentDevice = [self.videoCaptureDeviceInput device];
    AVCaptureDevicePosition currentPosition=[currentDevice position];
    AVCaptureDevice *toChangeDevice;
    AVCaptureDevicePosition toChangePosition=AVCaptureDevicePositionFront;
    if (currentPosition == AVCaptureDevicePositionUnspecified||currentPosition ==AVCaptureDevicePositionFront) {
        
        toChangePosition = AVCaptureDevicePositionBack;
        // 闪光灯按钮隐藏
        
    } else {
        // 取消隐藏闪光灯按钮
    }
    
    toChangeDevice = [self getCameraDeviceWithPosition:toChangePosition];
    // 获得要调整的设备输入对象
    AVCaptureDeviceInput *toChangeDeviceInput = [[AVCaptureDeviceInput alloc]initWithDevice:toChangeDevice error:nil];
    
    // 改变会话的配置前一定要先开启配置，配置完成后提交配置改变
    [self.captureSession beginConfiguration];
    // 移除原有输入对象
    [self.captureSession removeInput:self.videoCaptureDeviceInput];
    // 添加新的输入对象
    if ([self.captureSession canAddInput:toChangeDeviceInput]) {
        [self.captureSession addInput:toChangeDeviceInput];
        self.videoCaptureDeviceInput=toChangeDeviceInput;
    }
    // 提交会话配置
    [self.captureSession commitConfiguration];
    
    // 关闭闪光灯
    [self setTorchMode:AVCaptureTorchModeOff];
}

#pragma mark - 开始录像

- (void)beginVideoRecording
{
    
}

#pragma mark - 结束录像

- (void)stopVideoRecording
{
    
}

- (void)VideoRecordingFinish
{
    
}

#pragma mark - AVCaptureFileOutputRecordingDelegate

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
    DONG_Log(@"---- 开始录制 ----");
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    DONG_Log(@"---- 录制结束 ----");
}

@end
