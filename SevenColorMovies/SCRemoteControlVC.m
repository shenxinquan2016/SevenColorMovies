//
//  SCRemoteControlVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/29.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCRemoteControlVC.h"
#import "GCDAsyncUdpSocket.h"
#import "SCUDPSocketManager.h"

#define PORT 9816


@interface SCRemoteControlVC () <GCDAsyncUdpSocketDelegate>

@property (weak, nonatomic) IBOutlet UIButton *volumeDownBtn;
@property (weak, nonatomic) IBOutlet UIButton *pullScreenBtn;
@property (weak, nonatomic) IBOutlet UIButton *volumeUpBtn;
@property (weak, nonatomic) IBOutlet UIButton *VODBtn;
@property (weak, nonatomic) IBOutlet UIButton *OKBtn;
@property (weak, nonatomic) IBOutlet UIButton *timeShiftBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *homePageBtn;
@property (weak, nonatomic) IBOutlet UIButton *menuBtn;

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
    
    [UPDScoketManager connectUDPSocketWithDelegate:self];

    
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

- (IBAction)doOKAction:(id)sender {
    NSLog(@"确定");
    [UPDScoketManager sendMessage:nil];

}

- (IBAction)doBackAction:(id)sender {
    NSLog(@"返回");
}

- (IBAction)doVolumeDown:(id)sender {
    NSLog(@"音量减");
}

- (IBAction)doVolumeUp:(id)sender {
    NSLog(@"音量加");
}

- (IBAction)toHomePage:(id)sender {
    NSLog(@"主页");
}

- (IBAction)toMenuPage:(id)sender {
    NSLog(@"目录");
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

- (void)setBtnImage {
    [_volumeDownBtn setImage:[UIImage imageNamed:@"VolumeDown_Click"] forState:UIControlStateHighlighted];
    [_pullScreenBtn setImage:[UIImage imageNamed:@"PullScreen_Click"] forState:UIControlStateHighlighted];
    [_volumeUpBtn setImage:[UIImage imageNamed:@"VolumeUp_Click"] forState:UIControlStateHighlighted];
    [_VODBtn setImage:[UIImage imageNamed:@"VOD_Click"] forState:UIControlStateHighlighted];
    [_OKBtn setImage:[UIImage imageNamed:@"OK_Click"] forState:UIControlStateHighlighted];
    [_timeShiftBtn setImage:[UIImage imageNamed:@"TimeShifted_Click"] forState:UIControlStateHighlighted];
    [_backBtn setImage:[UIImage imageNamed:@"Back_Click"] forState:UIControlStateHighlighted];
    [_homePageBtn setImage:[UIImage imageNamed:@"HomePage_Click"] forState:UIControlStateHighlighted];
    [_menuBtn setImage:[UIImage imageNamed:@"Menu_Click"] forState:UIControlStateHighlighted];
}

#pragma mark - GCDAsyncUdpSocketDelegate

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
    
    //[self sendBackToHost: ip port:port withMessage:s];
    
    //再次启动一个等待
    [UPDScoketManager.udpSocket receiveOnce:nil];
    
}

-(void)sendBackToHost:(NSString *)ip port:(uint16_t)port withMessage:(NSString *)s{
    NSString *msg = @"我已接收到消息";
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    
    [UPDScoketManager.udpSocket sendData:data toHost:ip port:port withTimeout:60 tag:200];
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

// 禁止旋转屏幕
- (BOOL)shouldAutorotate{
    return NO;
}


@end
