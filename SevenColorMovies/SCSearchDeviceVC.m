//
//  SCSearchDeviceVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/12/9.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCSearchDeviceVC.h"
#import "SCRemoteHelpPageVC.h"
#import "SCSearchingDeviceView.h"
#import "SCNoDeviceView.h"
#import "SCDevicesListView.h"
#import "GCDAsyncUdpSocket.h"
#import "SCDeviceModel.h"
#import "SCRemoteControlVC.h"
#import "SCUDPSocketManager.h"
#import "SCTCPSocketManager.h"

#define PORT 9816

@interface SCSearchDeviceVC () <UdpSocketManagerDelegate, SocketManagerDelegate>

@property (nonatomic, strong) SCSearchingDeviceView *searchingView;
@property (nonatomic, strong) SCNoDeviceView *noDeviceView;
@property (nonatomic, strong) SCDevicesListView *devicesListView;
/** udpSocket实例 */
@property (nonatomic, strong) GCDAsyncUdpSocket *udpSocket;
@property (nonatomic, strong) NSMutableArray *deviceArray;
@property (nonatomic, strong) NSTimer *scaningTimer;

@end

@implementation SCSearchDeviceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHex:@"#f1f1f1"];
    
    self.deviceArray = [NSMutableArray arrayWithCapacity:0];
    
    //1.标题
    self.leftBBI.text = @"遥控器";
    [self addRightBBI];
    
    //2.读取xib
    [self loadSubViewsFromXib];
    
    //3.发广播搜索设备
    [self searchDevice];
}

- (void)dealloc {
    DONG_Log(@"dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - priva method

- (void)addRightBBI
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 25, 25);
    
    [btn setImage:[UIImage imageNamed:@"Romote_Help"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"Romote_Help_Click"] forState:UIControlStateHighlighted];
    btn.enlargedEdge = 5.f;
    [btn addTarget:self action:@selector(toHelpPage) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    UIBarButtonItem *rightNegativeSpacer = [[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                            target:nil action:nil];
    rightNegativeSpacer.width = -4;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:rightNegativeSpacer,item, nil];
}

- (void)toHelpPage
{
    SCRemoteHelpPageVC *helpPage = DONG_INSTANT_VC_WITH_ID(@"Discovery", @"SCRemoteHelpPageVC");
    [self.navigationController pushViewController:helpPage animated:YES];
}

- (void)loadSubViewsFromXib
{
    _searchingView = [[NSBundle mainBundle] loadNibNamed:@"SCSearchingDeviceView" owner:nil options:nil][0];
    _noDeviceView = [[NSBundle mainBundle] loadNibNamed:@"SCNoDeviceView" owner:nil options:nil][0];
    _devicesListView = [[NSBundle mainBundle] loadNibNamed:@"SCDevicesListView" owner:nil options:nil][0];
    
    [_searchingView setFrame:self.view.bounds];
    [_noDeviceView setFrame:self.view.bounds];
    [_devicesListView setFrame:self.view.bounds];
    
    //重新扫描
    DONG_WeakSelf(self);
    _noDeviceView.scanDevice = ^{
        [weakself searchDevice];
        
    };
    //帮助
    _noDeviceView.gotoHelpPage = ^{
        [weakself toHelpPage];
    };
    //重新扫描
    _devicesListView.scanDeviceBlock = ^{
        [weakself searchDevice];
    };
    //TCP连接
    _devicesListView.connectTCPBlock = ^(SCDeviceModel *deviceModel) {
        
        if ([weakself.entrance isEqualToString:@"player"]) {
            TCPScoketManager.delegate = weakself;
            [TCPScoketManager connectToHost:deviceModel._ip port:9819];
            [weakself.navigationController popViewControllerAnimated:YES];
            
        } else {
          
            SCRemoteControlVC *remoteVC = DONG_INSTANT_VC_WITH_ID(@"Discovery", @"SCRemoteControlVC");
            remoteVC.deviceModel = deviceModel;
            [weakself.navigationController pushViewController:remoteVC animated:YES];
        }
        
    };
    
    [self.view addSubview:_searchingView];
    [self.view addSubview:_noDeviceView];
    [self.view addSubview:_devicesListView];
    
}

- (void)searchDevice
{
    UdpScoketManager.delegate = self;
    [UdpScoketManager sendBroadcast];
    
    //搜索时清空数组 进入搜索中页面
    [_deviceArray removeAllObjects];
    _noDeviceView.hidden = YES;
    _devicesListView.hidden = YES;
    _devicesListView.deviceModel = nil;
    
    //搜索页面停留2S
    self.scaningTimer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                         target:self
                                                       selector:@selector(updateUIWithDeviceArray)
                                                       userInfo:nil
                                                        repeats:NO];
    
}

- (void)updateUIWithDeviceArray
{
    _devicesListView.hidden = NO;
    
    if (_deviceArray.count) {
        _noDeviceView.hidden = YES;
        _devicesListView.hidden = NO;
        
    } else {
        
        _noDeviceView.hidden = NO;
        _devicesListView.hidden = YES;
    }
    _devicesListView.dataArray = _deviceArray;
    [_devicesListView.tableView reloadData];
    
    [_scaningTimer invalidate];
    _scaningTimer = nil;
}

#pragma mark - UdpSocketManagerDelegate

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address
{
    
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError *)error
{
    
}

-(void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContex
{
    //取得发送发的ip和端口
    NSString *ip = [GCDAsyncUdpSocket hostFromAddress:address];
    uint16_t port = [GCDAsyncUdpSocket portFromAddress:address];
    
    //data就是接收的数据
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    DONG_Log(@"GCDAsyncUdpSocket接收到消息 ip:%@ port:%u data:%@",ip, port,message);
    
    NSDictionary *dic = [NSDictionary dictionaryWithXMLData:data];
    NSLog(@"dic:%@",dic);
    
    if (dic) {
        NSDictionary *dic2 =[NSDictionary dictionaryWithXMLString:dic[@"Body"]];
        //NSLog(@"dic2:%@",dic2);
        SCDeviceModel *deviceModel = [[SCDeviceModel alloc] init];
        deviceModel.name = dic2[@"name"];
        deviceModel._ip = dic2[@"_ip"];
        
        [_deviceArray addObject:deviceModel];
    }
    
    //[self sendBackToHost: ip port:port withMessage:message];
    
    //再次启动一个等待
    [self.udpSocket receiveOnce:nil];
    
}

-(void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    if (tag == 100) {
        NSLog(@"tag:100 数据发送成功");
    } else if (tag == 200) {
        NSLog(@"tag:200 数据发送成功");
    }
}


#pragma mark - SocketManagerDelegate

/** 连接成功 */
- (void)socket:(GCDAsyncSocket *)socket didConnect:(NSString *)host port:(uint16_t)port
{
    DONG_MAIN_AFTER(0.2, [MBProgressHUD showSuccess:@"设备连接成功"];);
}



// 禁止旋转屏幕
- (BOOL)shouldAutorotate {
    return NO;
}

@end
