//
//  SCScanQRCodesVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 17/1/9.
//  Copyright © 2017年 yesdgq. All rights reserved.
//  扫码控制器

#import "SCScanQRCodesVC.h"
#import "SCXMPPManager.h"
#import <AVFoundation/AVFoundation.h>

#define ScanViewWidthAndHeight kMainScreenHeight * 0.6

@interface SCScanQRCodesVC () <SCXMPPManagerDelegate, AVCaptureMetadataOutputObjectsDelegate>

@property(nonatomic,strong)AVCaptureSession * session;
@property(nonatomic,weak)UIView * maskView;

@end

@implementation SCScanQRCodesVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHex:@"#f1f1f1"];
    // 1.标题
    self.leftBBI.text = @"扫一扫";
   
    // 登录XMPP
    //[XMPPManager initXMPPWithUserName:@"8451204087955261" andPassWord:@"voole"];
    //XMPPManager.delegate = self;
    
    
    [self setUpMaskView];
//    [self setUpBottomBar];
//    [self setUpScanWindowView];
//    [self beginScanning];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)xmpp:(id)sender {
    
}

-(void)setUpMaskView
{
    UIView * mask = [[UIView alloc] init];
    self.maskView = mask;
    mask.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3].CGColor;
    mask.layer.borderWidth = (kMainScreenHeight - ScanViewWidthAndHeight)/2;
    

    mask.frame = self.view.bounds;
    [self.view addSubview:mask];
    [mask mas_updateConstraints:^(MASConstraintMaker *make) {
        
        
    }];
    
    
    mask.bounds.origin.x = self.view.bounds.origin.x;
    mask.y = 0;
    UIImageView * imageView =[[UIImageView alloc]init];
    [imageView setImage:[UIImage imageNamed:@"scan_icon"]];
    imageView.frame = CGRectMake(0, 0, 40, 40);
    UILabel * label = [[UILabel alloc]init];
    label.text = @"把二维码放到框框里就可以扫描了";
    //    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor greenColor];
    label.numberOfLines= 2;
    label.font = [UIFont systemFontOfSize:14];
    label.frame = CGRectMake(50, 0, 120, 40);
    UIView * iconAndLabelView = [[UIView alloc]init];
    iconAndLabelView.backgroundColor = [UIColor clearColor];
//    iconAndLabelView.size = CGSizeMake(165, 40);
//    iconAndLabelView.x = (self.view.width - iconAndLabelView.width)/2;
//    iconAndLabelView.y = self.view.height * 0.2;
    iconAndLabelView.frame = CGRectMake(50, 100, 120, 60);
    [iconAndLabelView addSubview:imageView];
    [iconAndLabelView addSubview:label];
//    [self.view addSubview:iconAndLabelView];
    
    
}

- (void)setUpBottomBar
{
    UIView *bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight * 0.9, kMainScreenWidth, kMainScreenHeight * 0.1)];
    bottomBar.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:@"取消" forState:UIControlStateNormal];
//    backButton.x = 5;
//    backButton.width = 50;
//    backButton.height = 30;
//    backButton.y = (bottomBar.height - backButton.height)/2;
    backButton.frame = CGRectMake(5, 10, 50, 30);
    
    
    [backButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:backButton];
    [self.view addSubview:bottomBar];
    
}

- (void)setUpScanWindowView
{
    UIView *scanWindow = [[UIView alloc] init];
//    scanWindow.width = ScanViewWidthAndHeight;
//    scanWindow.height = ScanViewWidthAndHeight;
//    scanWindow.y = (self.view.height - scanWindow.height) / 2;
//    scanWindow.x =(self.view.width - scanWindow.width)/2;
    scanWindow.clipsToBounds = YES;
    [self.view addSubview:scanWindow];
    [scanWindow mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(ScanViewWidthAndHeight, ScanViewWidthAndHeight));
        
    }];
    
    CGFloat scanNetImageViewH = ScanViewWidthAndHeight;
    CGFloat scanNetImageViewW = ScanViewWidthAndHeight;
    UIImageView *scanNetImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scan_net"]];
    scanNetImageView.frame = CGRectMake(0, -scanNetImageViewH, scanNetImageViewW, scanNetImageViewH);
    CABasicAnimation *scanNetAnimation = [CABasicAnimation animation];
    scanNetAnimation.keyPath = @"transform.translation.y";
    scanNetAnimation.byValue = @(scanWindow.bounds.size.height);
    scanNetAnimation.duration = 1.5;
    scanNetAnimation.repeatCount = MAXFLOAT;
    [scanNetImageView.layer addAnimation:scanNetAnimation forKey:nil];
    [scanWindow addSubview:scanNetImageView];
    //  设置4个边框
    CGFloat buttonWH = 18;
    
    UIButton *topLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonWH, buttonWH)];
    [topLeft setImage:[UIImage imageNamed:@"scan_1"] forState:UIControlStateNormal];
    [scanWindow addSubview:topLeft];
    
//    UIButton *topRight = [[UIButton alloc] initWithFrame:CGRectMake(scanWindow.width - buttonWH, 0, buttonWH, buttonWH)];
//    [topRight setImage:[UIImage imageNamed:@"scan_2"] forState:UIControlStateNormal];
//    [scanWindow addSubview:topRight];
//    
//    UIButton *bottomLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, scanWindow.height - buttonWH, buttonWH, buttonWH)];
//    [bottomLeft setImage:[UIImage imageNamed:@"scan_3"] forState:UIControlStateNormal];
//    [scanWindow addSubview:bottomLeft];
//    
//    UIButton *bottomRight = [[UIButton alloc] initWithFrame:CGRectMake(topRight.x, bottomLeft.y, buttonWH, buttonWH)];
//    [bottomRight setImage:[UIImage imageNamed:@"scan_4"] forState:UIControlStateNormal];
//    [scanWindow addSubview:bottomRight];
    
}

- (void)beginScanning
{
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    if (!input) return;
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    output.rectOfInterest = CGRectMake(((kMainScreenHeight-ScanViewWidthAndHeight)/2)/kMainScreenHeight,((kMainScreenWidth-ScanViewWidthAndHeight)/2)/kMainScreenWidth,ScanViewWidthAndHeight/kMainScreenHeight,ScanViewWidthAndHeight/kMainScreenWidth);
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    _session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [_session addInput:input];
    [_session addOutput:output];
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame= self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    
    
    //开始捕获
    [_session startRunning];
    
}

-(void)dismiss
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - SCXMPPManagerDelegate

- (void)didReceiveMessage:(XMPPMessage*)message
{
    NSString *from = message.fromStr;
    NSString *info = message.body;
    DONG_Log(@"接收到%@说：%@",from, info);
}


@end
