//
//  SCScanQRCodesVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 17/1/9.
//  Copyright © 2017年 yesdgq. All rights reserved.
//  扫码控制器

#import "SCScanQRCodesVC.h"
#import "SCXMPPManager.h"
#import "LBXScanResult.h"
#import "LBXScanWrapper.h"
#import "LBXScanVideoZoomView.h"
#import "SCRemoteControlVC.h"


@interface SCScanQRCodesVC () <SCXMPPManagerDelegate, AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) LBXScanVideoZoomView *zoomView;

@end

@implementation SCScanQRCodesVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addLeftBBI];
   
    // 登录XMPP
    [XMPPManager initXMPPWithUserName:@"8451204087955261" andPassWord:@"voole"];
    XMPPManager.delegate = self;
    
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor blackColor];
    
    //设置扫码后需要扫码图像
    self.isNeedScanImage = YES;
    
    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_isQQSimulator) {
        
        //[self drawBottomItems];
        [self drawTitle];
        [self.view bringSubviewToFront:_topTitle];
    }
    else
        _topTitle.hidden = YES;
}

- (void)addLeftBBI {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 32)];
    //    view.backgroundColor = [UIColor redColor];
    // 返回箭头
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Back_Arrow"]];
    [view addSubview:imgView];
    //    imgView.backgroundColor = [UIColor grayColor];
    [imgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view);
        make.centerY.equalTo(view);
        make.size.mas_equalTo(imgView.image.size);
        
    }];
    // 返回标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 125, 22)];
    //    titleLabel.backgroundColor = [UIColor greenColor];
    titleLabel.text = @"扫一扫";
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
    
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

// 绘制扫描区域
- (void)drawTitle
{
    if (!_topTitle)
    {
        self.topTitle = [[UILabel alloc]init];
        _topTitle.bounds = CGRectMake(0, 0, 145, 60);
        _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, 50);
        
        //3.5inch iphone
        if ([UIScreen mainScreen].bounds.size.height <= 568 )
        {
            _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, 38);
            _topTitle.font = [UIFont systemFontOfSize:14];
        }
        
        
        _topTitle.textAlignment = NSTextAlignmentCenter;
        _topTitle.numberOfLines = 0;
        _topTitle.text = @"将取景框对准二维码即可自动扫描";
        _topTitle.textColor = [UIColor whiteColor];
        [self.view addSubview:_topTitle];
    }
}

- (void)cameraInitOver
{
    if (self.isVideoZoom) {
        [self zoomView];
    }
}

- (LBXScanVideoZoomView*)zoomView
{
    if (!_zoomView)
    {
        
        CGRect frame = self.view.frame;
        
        int XRetangleLeft = self.style.xScanRetangleOffset;
        
        CGSize sizeRetangle = CGSizeMake(frame.size.width - XRetangleLeft*2, frame.size.width - XRetangleLeft*2);
        
        if (self.style.whRatio != 1)
        {
            CGFloat w = sizeRetangle.width;
            CGFloat h = w / self.style.whRatio;
            
            NSInteger hInt = (NSInteger)h;
            h  = hInt;
            
            sizeRetangle = CGSizeMake(w, h);
        }
        
        CGFloat videoMaxScale = [self.scanObj getVideoMaxScale];
        
        //扫码区域Y轴最小坐标
        CGFloat YMinRetangle = frame.size.height / 2.0 - sizeRetangle.height/2.0 - self.style.centerUpOffset;
        CGFloat YMaxRetangle = YMinRetangle + sizeRetangle.height;
        
        CGFloat zoomw = sizeRetangle.width + 40;
        _zoomView = [[LBXScanVideoZoomView alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-zoomw)/2, YMaxRetangle + 40, zoomw, 18)];
        
        [_zoomView setMaximunValue:videoMaxScale/4];
        
        
        __weak __typeof(self) weakSelf = self;
        _zoomView.block= ^(float value)
        {
            [weakSelf.scanObj setVideoScale:value];
        };
        [self.view addSubview:_zoomView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        [self.view addGestureRecognizer:tap];
    }
    
    return _zoomView;
    
}

- (void)tap
{
    _zoomView.hidden = !_zoomView.hidden;
}

- (void)drawBottomItems
{
    if (_bottomItemsView) {
        
        return;
    }
    
    self.bottomItemsView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame)-164,
                                                                   CGRectGetWidth(self.view.frame), 100)];
    _bottomItemsView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    [self.view addSubview:_bottomItemsView];
    
    CGSize size = CGSizeMake(65, 87);
    self.btnFlash = [[UIButton alloc]init];
    _btnFlash.bounds = CGRectMake(0, 0, size.width, size.height);
    _btnFlash.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame)/2, CGRectGetHeight(_bottomItemsView.frame)/2);
    [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
    [_btnFlash addTarget:self action:@selector(openOrCloseFlash) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnPhoto = [[UIButton alloc]init];
    _btnPhoto.bounds = _btnFlash.bounds;
    _btnPhoto.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame)/4, CGRectGetHeight(_bottomItemsView.frame)/2);
    [_btnPhoto setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_photo_nor"] forState:UIControlStateNormal];
    [_btnPhoto setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_photo_down"] forState:UIControlStateHighlighted];
    [_btnPhoto addTarget:self action:@selector(openPhoto) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnMyQR = [[UIButton alloc]init];
    _btnMyQR.bounds = _btnFlash.bounds;
    _btnMyQR.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame) * 3/4, CGRectGetHeight(_bottomItemsView.frame)/2);
    [_btnMyQR setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_myqrcode_nor"] forState:UIControlStateNormal];
    [_btnMyQR setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_myqrcode_down"] forState:UIControlStateHighlighted];
    [_btnMyQR addTarget:self action:@selector(myQRCode) forControlEvents:UIControlEventTouchUpInside];
    
    [_bottomItemsView addSubview:_btnFlash];
    [_bottomItemsView addSubview:_btnPhoto];
    [_bottomItemsView addSubview:_btnMyQR];
    
}

// 扫描结果
- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    if (array.count < 1)
    {
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    
    //经测试，可以同时识别2个二维码，不能同时识别二维码和条形码
    for (LBXScanResult *result in array) {
        
        DONG_Log(@"scanResult:%@",result.strScanned);
    }
    
    LBXScanResult *scanResult = array[0];
    
    NSString*strResult = scanResult.strScanned;
    
    self.scanImage = scanResult.imgScanned;
    
    if (!strResult) {
        
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    
    //震动提醒
     //[LBXScanWrapper systemVibrate];
    //声音提醒
    //[LBXScanWrapper systemSound];
    
    
    [self showNextVCWithScanResult:scanResult];
    
}

// 扫描失败
- (void)popAlertMsgWithScanResult:(NSString*)strResult
{
    if (!strResult) {
        
        strResult = @"识别失败";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"扫码内容" message:strResult delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
    [alertView show];
    alertView.delegate = self;

}

- (void)showNextVCWithScanResult:(LBXScanResult*)strResult
{
    SCRemoteControlVC *remoteVC = DONG_INSTANT_VC_WITH_ID(@"Discovery", @"SCRemoteControlVC");
    
    [self.navigationController pushViewController:remoteVC animated:YES];
}


#pragma mark -底部功能项
// 打开相册
- (void)openPhoto
{
    if ([LBXScanWrapper isGetPhotoPermission])
        [self openLocalPhoto];
    else {
        [MBProgressHUD showError:@"请到设置->隐私中开启本程序相册权限"];
    }
}

// 开关闪光灯
- (void)openOrCloseFlash
{
    [super openOrCloseFlash];
    
    if (self.isOpenFlash)
    {
        [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_down"] forState:UIControlStateNormal];
    }
    else
        [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
}


#pragma mark -底部功能项

- (void)myQRCode
{
//    MyQRViewController *vc = [MyQRViewController new];
//    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - SCXMPPManagerDelegate

- (void)didReceiveMessage:(XMPPMessage*)message
{
    NSString *from = message.fromStr;
    NSString *info = message.body;
    DONG_Log(@"接收到%@说：%@",from, info);
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
