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


#define PORT 9816

@interface SCSearchDeviceVC ()<GCDAsyncUdpSocketDelegate>

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
    
    [self loadSubViewsFromXib];
    
    [self setUDPSocket];
    [self  searchDevice];
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
    _devicesListView.connectTCPBlock = ^(SCDeviceModel *deviceModel){
        SCRemoteControlVC *remoteVC = DONG_INSTANT_VC_WITH_ID(@"Discovery", @"SCRemoteControlVC");
        remoteVC.deviceModel = deviceModel;
        [weakself.navigationController pushViewController:remoteVC animated:YES];
    };
    
    [self.view addSubview:_searchingView];
    [self.view addSubview:_noDeviceView];
    [self.view addSubview:_devicesListView];

}

- (void)setUDPSocket
{
    //创建一个后台队列 等待接收数据
    dispatch_queue_t dQueue = dispatch_queue_create("My socket queue", NULL); //第一个参数是该队列的名字
    
    //1.实例化一个udp socket套接字对象
    // udpServerSocket需要用来接收数据
    self.udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dQueue socketQueue:nil];
    
    //2.服务器端来监听端口9814(等待端口9814的数据)
    [self.udpSocket bindToPort:PORT error:nil];
    
    //3.开启广播模式
    [self.udpSocket enableBroadcast:YES error:nil];
    
    //4.接收一次消息(启动一个等待接收,且只接收一次)
    [self.udpSocket receiveOnce:nil];
    
}

- (void)searchDevice
{
    NSString *message = @"搜索设备中...";
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    // 给网段内所有的人发送消息 四个255表示广播地址
    NSString *host = @"255.255.255.255";
    uint16_t port = PORT;
    
    //开始发送
    //该函数只是启动一次发送 它本身不进行数据的发送, 而是让后台的线程慢慢的发送 也就是说这个函数调用完成后,数据并没有立刻发送,异步发送
    [self.udpSocket sendData:data toHost:host port:port withTimeout:-1 tag:100];
    
    //搜索时清空数组 进入搜索中页面
    [_deviceArray removeAllObjects];
    _noDeviceView.hidden = YES;
    _devicesListView.hidden = YES;
    
    //搜索页面停留4S
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

#pragma mark - UDPSocketDelegate

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address {
    
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError *)error {
    
}

-(void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContex
{
    //取得发送发的ip和端口
    NSString *ip = [GCDAsyncUdpSocket hostFromAddress:address];
    uint16_t port = [GCDAsyncUdpSocket portFromAddress:address];
    
    //data就是接收的数据
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"[%@:%u]%@",ip, port,message);
    
    NSDictionary *dic = [NSDictionary dictionaryWithXMLData:data];
    NSLog(@"dic:%@",dic);
    
    if (dic) {
        NSDictionary *dic2 =[NSDictionary dictionaryWithXMLString:dic[@"Body"]];
        NSLog(@"dic2:%@",dic2);
        SCDeviceModel *deviceModel = [[SCDeviceModel alloc] init];
        deviceModel.name = dic2[@"name"];
        deviceModel._ip = dic2[@"_ip"];
        
        [_deviceArray addObject:deviceModel];
    }
    
    //[self sendBackToHost: ip port:port withMessage:message];
    
    //再次启动一个等待
    [self.udpSocket receiveOnce:nil];
    
}

-(void)sendBackToHost:(NSString *)ip port:(uint16_t)port withMessage:(NSString *)s{
    NSString *msg = @"我已接收到消息";
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    
    [self.udpSocket sendData:data toHost:ip port:port withTimeout:60 tag:200];
}

-(void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
    if (tag == 100) {
        NSLog(@"tag:100 数据发送成功");
    } else if (tag == 200) {
        NSLog(@"tag:200 数据发送成功");
    }
}

-(void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error{
    NSLog(@"标记为tag %ld的发送失败 失败原因 %@",tag, error);
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error {
    NSLog(@"UDP链接关闭 原因 %@", error);
}



@end
