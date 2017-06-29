//
//  SCLovelyBabyRecordVideoVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/6/23.
//  Copyright © 2017年 yesdgq. All rights reserved.
//  视频录制

#import "SCLovelyBabyRecordVideoVC.h"
#import <AVFoundation/AVFoundation.h>

typedef void(^PropertyChangeBlock)(AVCaptureDevice *captureDevice);

@interface SCLovelyBabyRecordVideoVC () <AVCaptureFileOutputRecordingDelegate>

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureDevice *captureDeviceInput;
@property (nonatomic, strong) AVCaptureDeviceInput *videoCaptureDeviceInput;
@property (nonatomic, strong) AVCaptureDeviceInput *audioCaptureDeviceInput;
@property (nonatomic, strong) AVCaptureMovieFileOutput *caputureMovieFileOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;

@end

@implementation SCLovelyBabyRecordVideoVC

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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
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

// 闪光灯开关
- (void)switchFlash
{
    DONG_Log(@"闪光灯");
    [self setFlashMode:AVCaptureFlashModeOn];
//    [self setFlashModeButtonStatus];
}

// 切换摄像头
- (void)switchCamera
{
    DONG_Log(@"摄像头");
}

// 开始录像
- (void)beginVideoRecording
{
    [_captureSession startRunning];
}

// 结束录像
- (void)stopVideoRecording
{
    [self.captureSession stopRunning];
}

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
    
    UIButton *videoRecordBtn = [[UIButton alloc] init];
    [videoRecordBtn addTarget:self action:@selector(beginVideoRecording) forControlEvents:UIControlEventTouchDown];
    [videoRecordBtn addTarget:self action:@selector(stopVideoRecording) forControlEvents:UIControlEventTouchUpInside];
    [videoRecordBtn setBackgroundImage:[UIImage imageNamed:@"VideoRecordBtnBG"] forState:UIControlStateNormal];
    [btnBG addSubview:videoRecordBtn];
    [videoRecordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(btnBG);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
}

// 初始化摄像机
- (void)initializeCameraConfiguration
{
    // 1.创建会话 (AVCaptureSession) 对象。
    self.captureSession = [[AVCaptureSession alloc] init];
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset640x480]) {
        // 设置会话的 sessionPreset 属性, 这个属性影响视频的分辨率
        [_captureSession setSessionPreset:AVCaptureSessionPreset640x480];
    }
    
    // 2.使用AVCaptureDevice的静态方法获得需要使用的设备 获取摄像头输入设备， 创建 AVCaptureDeviceInput 对象
    // 在获取摄像头的时候，摄像头分为前后摄像头，我们创建了一个方法通过用摄像头的位置来获取摄像头
    AVCaptureDevice *videoCaptureDevice = [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];
    if (!videoCaptureDevice) {
        DONG_Log(@"---- 取得后置摄像头时出现问题---- ");
        return;
    }
    // 添加一个音频输入设备 直接可以拿数组中的数组中的第一个
    AVCaptureDevice *audioCaptureDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];

    // 3.利用输入设备AVCaptureDevice初始化AVCaptureDeviceInput对象。
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
    
    // 4.初始化输出数据管理对象，如果要拍照就初始化AVCaptureStillImageOutput对象；如果拍摄视频就初始化AVCaptureMovieFileOutput对象
    _caputureMovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    
    
    // 5.将视音频数据输入对象AVCcaptureFileOutput（对应子类）添加到媒体会话管理对象AVCaptureSession中
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
    
    // 6.创建视频预览图层AVCaptureVideoPreviewLayer并指定媒体会话，添加图层到显示容器中，调用AVCaptureSession的startRuning方法开始捕获。
    // 通过会话 (AVCaptureSession) 创建预览层
    _captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    
    // 显示在视图表面的图层
    CALayer *layer = self.view.layer;
    layer.masksToBounds = true;
    
    _captureVideoPreviewLayer.frame = layer.bounds;
    _captureVideoPreviewLayer.masksToBounds = true;
    _captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill; // 填充模式
    [layer addSublayer:_captureVideoPreviewLayer];
    
    // 让会话（AVCaptureSession）勾搭好输入输出，然后把视图渲染到预览层上
    [_captureSession startRunning];

    
    //将设备输出添加到会话中
    if ([_captureSession canAddOutput:_caputureMovieFileOutput]) {
        [_captureSession addOutput:_caputureMovieFileOutput];
    }
    
    
    // 7.将捕获的音频或视频数据输出到指定文件
     AVCaptureConnection *captureConnection = [self.caputureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    // 开启视频防抖模式
    AVCaptureVideoStabilizationMode stabilizationMode = AVCaptureVideoStabilizationModeCinematic;
    if ([self.captureDeviceInput.activeFormat isVideoStabilizationModeSupported:stabilizationMode]) {
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
    [self.caputureMovieFileOutput startRecordingToOutputFileURL:fileUrl recordingDelegate:self];

    // 取消视频拍摄
//    [self.caputureMovieFileOutput stopRecording];
//    [self.captureSession stopRunning];
//    [self completeHandle];
}


/**
 *  取得指定位置的摄像头
 *
 *  @param position 摄像头位置
 *
 *  @return 摄像头设备
 */
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

/**
 *  改变设备属性的统一操作方法
 *
 *  @param propertyChange 属性改变操作
 */
-(void)changeDeviceProperty:(PropertyChangeBlock)propertyChange
{
//    AVCaptureDevice *captureDevice= [self.captureDeviceInput device];
//    NSError *error;
//    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
//    if ([captureDevice lockForConfiguration:&error]) {
//        propertyChange(captureDevice);
//        [captureDevice unlockForConfiguration];
//    }else{
//        NSLog(@"设置设备属性过程发生错误，错误信息：%@",error.localizedDescription);
//    }
}

/**
 *  设置闪光灯模式
 *
 *  @param flashMode 闪光灯模式
 */
-(void)setFlashMode:(AVCaptureFlashMode)flashMode
{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFlashModeSupported:flashMode]) {
            [captureDevice setFlashMode:flashMode];
        }
    }];
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
