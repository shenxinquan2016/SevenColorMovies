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
#import "SCTCPSocketManager.h"
#import "AsyncSocket.h"
#import "SCDeviceModel.h"
#import "SCDiscoveryViewController.h"
#import <AudioToolbox/AudioToolbox.h>

#define PORT 9814

@interface SCRemoteControlVC () <SocketManagerDelegate>

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
    
    //2.断开连接btn
    [self addRightBBI];
    
    //3.建立tcp连接
    TCPScoketManager.delegate = self;
    
    if (!TCPScoketManager.isConnected) {
        
        [TCPScoketManager connectToHost:self.deviceModel._ip port:PORT];
    }
    
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
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    NSString *type = @"Rc_Move";
    NSString *value = @"MoveUp";
    NSString *xmlString = [self getCommandXMLStringWithType:type value:value];
    
    [TCPScoketManager socketWriteData:xmlString];
}

- (IBAction)doMoveDown:(id)sender
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    NSString *type = @"Rc_Move";
    NSString *value = @"MoveDown";
    NSString *xmlString = [self getCommandXMLStringWithType:type value:value];
    
    [TCPScoketManager socketWriteData:xmlString];
}

- (IBAction)doMoveLeft:(id)sender
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    NSString *type = @"Rc_Move";
    NSString *value = @"MoveLeft";
    NSString *xmlString = [self getCommandXMLStringWithType:type value:value];
    
    [TCPScoketManager socketWriteData:xmlString];
}

- (IBAction)doMoveRignt:(id)sender
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
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

- (void)addRightBBI
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 18, 18);
    
    [btn setImage:[UIImage imageNamed:@"Cut_Off_Connect"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"Cut_Off_Connect_Click"] forState:UIControlStateHighlighted];
    btn.enlargedEdge = 5.f;
    [btn addTarget:self action:@selector(cutOffConnect) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    UIBarButtonItem *rightNegativeSpacer = [[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                            target:nil action:nil];
    rightNegativeSpacer.width = -4;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:rightNegativeSpacer,item, nil];
}

- (void)cutOffConnect
{
    //1.断开连接
    [TCPScoketManager disConnectSocket];
    [self.navigationController popToRootViewControllerAnimated:YES];
    //2.发送通知
    //[DONG_NotificationCenter postNotificationName:CutOffTcpConnectByUser object:nil];
}

/** xml命令构造器 */
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
    
    _moveUpBtn.enlargedEdge = 15;
    _moveDownBtn.enlargedEdge = 15;
    _moveLeftBtn.enlargedEdge = 15;
    _moveRightBtn.enlargedEdge = 15;
    
}

/** 重写返回事件 */
- (void)goBack
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - SocketManagerDelegate

- (void)socket:(GCDAsyncSocket *)socket didReadData:(NSData *)data
{
    DONG_Log(@"SocketManagerDelegate读取数据成功");
}

- (void)socket:(GCDAsyncSocket *)socket didConnect:(NSString *)host port:(uint16_t)port
{
    DONG_Log(@"SocketManagerDelegate连接成功");
    
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)socket{
    
    DONG_Log(@"SocketManagerDelegate断开了");
}



// 禁止旋转屏幕
- (BOOL)shouldAutorotate{
    return NO;
}


@end
