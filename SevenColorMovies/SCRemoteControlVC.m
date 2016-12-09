//
//  SCRemoteControlVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/29.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCRemoteControlVC.h"
#import "GCDAsyncUdpSocket.h"
#import "GCDAsyncSocket.h"
#import "SCUDPSocketManager.h"
#import "SCTCPSocketManager.h"
#import "AsyncSocket.h"

#define PORT 9816


@interface SCRemoteControlVC () <GCDAsyncUdpSocketDelegate, GCDAsyncSocketDelegate, AsyncSocketDelegate>

/** tcpSocket */
@property (nonatomic, strong) GCDAsyncSocket *socket;
/** 遥控器btn */
@property (weak, nonatomic) IBOutlet UIButton *volumeDownBtn;
@property (weak, nonatomic) IBOutlet UIButton *pullScreenBtn;
@property (weak, nonatomic) IBOutlet UIButton *volumeUpBtn;
@property (weak, nonatomic) IBOutlet UIButton *VODBtn;
@property (weak, nonatomic) IBOutlet UIButton *OKBtn;
@property (weak, nonatomic) IBOutlet UIButton *timeShiftBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *homePageBtn;
@property (weak, nonatomic) IBOutlet UIButton *menuBtn;
@property (weak, nonatomic) IBOutlet UIButton *moveUpBtn;
@property (weak, nonatomic) IBOutlet UIButton *moveDownBtn;
@property (weak, nonatomic) IBOutlet UIButton *moveLeftBtn;
@property (weak, nonatomic) IBOutlet UIButton *moveRightBtn;

/** udpSocket实例 */
@property (nonatomic, strong) GCDAsyncUdpSocket *udpSocket;

@end

@implementation SCRemoteControlVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHex:@"#f1f1f1"];
    //1.标题
    self.leftBBI.text = @"遥控器";
    
    [self setUDPSocket];
    
    
    NSString *host = @"192.168.31.109";
    UInt16 port = 9814;
    
    [TCPScoketManager connectToHost:host port:port delegate:self];
    
}


- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self setBtnImage];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)dealloc{
    NSLog(@"🔴%s 第%d行 \n",__func__, __LINE__);
    [TCPScoketManager disConnectSocket];
}

#pragma mark - IBAction

- (IBAction)doVolumeDown:(id)sender
{
    NSString *type = @"Rc_VolumeControl";
    NSString *value = @"-1";
    NSString *xmlString = [self getCommandXMLStringWithType:type value:value];
    [TCPScoketManager socketWriteData:xmlString];
}

- (IBAction)doVolumeUp:(id)sender
{
    NSString *type = @"Rc_VolumeControl";
    NSString *value = @"1";
    NSString *xmlString = [self getCommandXMLStringWithType:type value:value];
    [TCPScoketManager socketWriteData:xmlString];
}

- (IBAction)doMoveUp:(id)sender
{
    NSString *type = @"Rc_Move";
    NSString *value = @"MoveUp";
    NSString *xmlString = [self getCommandXMLStringWithType:type value:value];
    
    [TCPScoketManager socketWriteData:xmlString];
}

- (IBAction)doMoveDown:(id)sender
{
    NSString *type = @"Rc_Move";
    NSString *value = @"MoveDown";
    NSString *xmlString = [self getCommandXMLStringWithType:type value:value];
    
    [TCPScoketManager socketWriteData:xmlString];
}

- (IBAction)doMoveLeft:(id)sender
{
    NSString *type = @"Rc_Move";
    NSString *value = @"MoveLeft";
    NSString *xmlString = [self getCommandXMLStringWithType:type value:value];
    
    [TCPScoketManager socketWriteData:xmlString];
}

- (IBAction)doMoveRignt:(id)sender
{
    NSString *type = @"Rc_Move";
    NSString *value = @"MoveRight";
    NSString *xmlString = [self getCommandXMLStringWithType:type value:value];
    
    [TCPScoketManager socketWriteData:xmlString];
}

- (IBAction)doOKAction:(id)sender {
    NSLog(@"确定");
    NSString *type = @"Rc_Navigation";
    NSString *value = @"Enter";
    NSString *xmlString = [self getCommandXMLStringWithType:type value:value];
    
    [TCPScoketManager socketWriteData:xmlString];
    
}

- (IBAction)doBackAction:(id)sender {
    NSLog(@"返回");
    NSString *type = @"Rc_Navigation";
    NSString *value = @"Back";
    NSString *xmlString = [self getCommandXMLStringWithType:type value:value];
    
    [TCPScoketManager socketWriteData:xmlString];
    
    
}

- (IBAction)toHomePage:(id)sender {
    NSLog(@"主页");
    NSString *type = @"Rc_SendKeyCode";
    NSString *value = @"HOME";
    NSString *xmlString = [self getCommandXMLStringWithType:type value:value];
    
    [TCPScoketManager socketWriteData:xmlString];
    
}

- (IBAction)toMenuPage:(id)sender {
    NSLog(@"目录");
    NSString *type = @"Rc_SendKeyCode";
    NSString *value = @"82";
    NSString *xmlString = [self getCommandXMLStringWithType:type value:value];
    
    [TCPScoketManager socketWriteData:xmlString];
}

- (IBAction)doVODAction:(id)sender {
    NSLog(@"点播");

}

- (IBAction)doTimeShiftAction:(id)sender {
    NSLog(@"时移");
  
    
}

- (IBAction)doPullScreen:(id)sender {
    NSLog(@"拉屏");
   
    
}

#pragma mark - priva method

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

- (void)searchEquipment
{
    NSString *s = @"谁在线";
    NSData *data = [s dataUsingEncoding:NSUTF8StringEncoding];
    // 给网段内所有的人发送消息 四个255表示广播地址
    NSString *host = @"255.255.255.255";
    uint16_t port = PORT;
    
    //开始发送
    //该函数只是启动一次发送 它本身不进行数据的发送, 而是让后台的线程慢慢的发送 也就是说这个函数调用完成后,数据并没有立刻发送,异步发送
    [self.udpSocket sendData:data toHost:host port:port withTimeout:-1 tag:100];
    
}

- (NSString *)getCommandXMLStringWithType:(NSString *)type value:(NSString *)value;
{
    NSString *xmlString = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><Message targetName=\"com.vurc.system\"><Body><![CDATA[<?xml version='1.0' encoding='utf-8' standalone='no' ?><Message type=\"%@\" value=\"%@\"></Message>]]></Body></Message>\n", type, value];
   
    return xmlString;
}

- (void)setBtnImage
{
    [_volumeDownBtn setImage:[UIImage imageNamed:@"VolumeDown_Click"] forState:UIControlStateHighlighted];
    [_pullScreenBtn setImage:[UIImage imageNamed:@"PullScreen_Click"] forState:UIControlStateHighlighted];
    [_volumeUpBtn setImage:[UIImage imageNamed:@"VolumeUp_Click"] forState:UIControlStateHighlighted];
    [_VODBtn setImage:[UIImage imageNamed:@"VOD_Click"] forState:UIControlStateHighlighted];
    [_OKBtn setImage:[UIImage imageNamed:@"OK_Click"] forState:UIControlStateHighlighted];
    [_timeShiftBtn setImage:[UIImage imageNamed:@"TimeShifted_Click"] forState:UIControlStateHighlighted];
    [_backBtn setImage:[UIImage imageNamed:@"Back_Click"] forState:UIControlStateHighlighted];
    [_homePageBtn setImage:[UIImage imageNamed:@"HomePage_Click"] forState:UIControlStateHighlighted];
    [_menuBtn setImage:[UIImage imageNamed:@"Menu_Click"] forState:UIControlStateHighlighted];
    [_moveUpBtn setImage:[UIImage imageNamed:@"Up_Click"] forState:UIControlStateHighlighted];
    [_moveDownBtn setImage:[UIImage imageNamed:@"Down_Click"] forState:UIControlStateHighlighted];
    [_moveLeftBtn setImage:[UIImage imageNamed:@"Left_Click"] forState:UIControlStateHighlighted];
    [_moveRightBtn setImage:[UIImage imageNamed:@"Right_Click"] forState:UIControlStateHighlighted];
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
    NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"[%@:%u]%@",ip, port,s);
    
    NSDictionary *dic = [NSDictionary dictionaryWithXMLData:data];
    NSLog(@"%@",dic);
    
    if (dic) {
        NSDictionary *dic2 =[NSDictionary dictionaryWithXMLString:dic[@"Body"]];
        NSLog(@"%@",dic2);
    }
    
    //[self sendBackToHost: ip port:port withMessage:s];
    
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



#pragma mark - TCPSocketDelegate

- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
    NSLog(@"GCDAsyncSocketDelegate接受新的连接");
    
}
/** 连接成功 */
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"GCDAsyncSocketDelegate链接服务器成功 ip:%@ port:%d", host, port);
    TCPScoketManager.connectStatus = 1;
    //发送心跳，来检测长连接
//    [TCPScoketManager socketDidConnectBeginSendBeat:@"connect is here"];
    
}

/** 连接失败 */
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"GCDAsyncSocket服务器连接失败");
    [TCPScoketManager reConnectSocket];
}

/** 接收消息成功 */
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    [TCPScoketManager.socket readDataWithTimeout:-1 buffer:nil bufferOffset:0 maxLength:1024 tag:0];
    
    
}

/** 发送消息成功 */
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"数据成功发送到服务器");
    //数据发送成功后，自己调用一下读取数据的方法，接着socket才会调用读取数据的代理方法
    [TCPScoketManager.socket readDataWithTimeout:-1 tag:tag];
}


// 禁止旋转屏幕
- (BOOL)shouldAutorotate{
    return NO;
}


@end
