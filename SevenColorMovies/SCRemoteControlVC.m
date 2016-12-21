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
//#import <AudioToolbox/AudioToolbox.h>
#import "SCHuikanPlayerViewController.h"
#import "SCFilmModel.h"
#import "SCSoundRecordingTool.h"//录音



#define PORT 9819

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

@property (nonatomic, strong) SCSoundRecordingTool *audioRecordingTool;

/** udpSocket实例 */
@property (nonatomic, strong) GCDAsyncUdpSocket *udpSocket;

@end

@implementation SCRemoteControlVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHex:@"#1E2026"];
    //1.标题
    self.leftBBI.text = @"遥控器";
    
    //2.断开连接btn
    [self addRightBBI];
    
    //3.建立tcp连接
    TCPScoketManager.delegate = self;
    
    if (!TCPScoketManager.isConnected) {
        [TCPScoketManager connectToHost:self.deviceModel._ip port:PORT];
    }
    
    
    //1.获取沙盒地址
    NSString *documentPath = [FileManageCommon GetTmpPath];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"/SoundRecord.wav"];
    self.audioRecordingTool = [[SCSoundRecordingTool alloc] initWithrecordFilePath:filePath];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self setBtnImage];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)dealloc{
    NSLog(@"🔴%s 第%d行 \n",__func__, __LINE__);
}

#pragma mark - IBAction


- (IBAction)startRecord:(id)sender {
    [_audioRecordingTool startRecord];
    DONG_Log(@"开始录音");
    
}

- (IBAction)stopRecord:(id)sender {
    [_audioRecordingTool stopRecord];
    
    NSString *documentPath = [FileManageCommon GetTmpPath];
    NSString *wavFilePath = [documentPath stringByAppendingPathComponent:@"/SoundRecord.wav"];
    NSString *marFilePath = [documentPath stringByAppendingPathComponent:@"/SoundRecord.mar"];
    
//    [_audioRecordingTool ConvertWavToAmr:wavFilePath amrSavePath:marFilePath];
}


- (IBAction)play:(id)sender {
    [_audioRecordingTool playRecord];
    DONG_Log(@"播放录音");
}




- (IBAction)doVolumeDown:(id)sender
{
    NSString *identifier = @"com.vurc.system";
    NSString *type = @"Rc_VolumeControl";
    NSString *value = @"-1";
    NSString *xmlString = [self getXMLStringCommandWithIdentifier:identifier type:type value:value];
    [TCPScoketManager socketWriteData:xmlString withTimeout:-1 tag:1000];
}

- (IBAction)doVolumeUp:(id)sender
{
    NSString *identifier = @"com.vurc.system";
    NSString *type = @"Rc_VolumeControl";
    NSString *value = @"1";
    NSString *xmlString = [self getXMLStringCommandWithIdentifier:identifier type:type value:value];
    [TCPScoketManager socketWriteData:xmlString withTimeout:-1 tag:1000];
}

- (IBAction)doMoveUp:(id)sender
{
    NSString *identifier = @"com.vurc.system";
    NSString *type = @"Rc_Move";
    NSString *value = @"MoveUp";
    NSString *xmlString = [self getXMLStringCommandWithIdentifier:identifier type:type value:value];
    
    [TCPScoketManager socketWriteData:xmlString withTimeout:-1 tag:1000];
}

- (IBAction)doMoveDown:(id)sender
{
    NSString *identifier = @"com.vurc.system";
    NSString *type = @"Rc_Move";
    NSString *value = @"MoveDown";
    NSString *xmlString = [self getXMLStringCommandWithIdentifier:identifier type:type value:value];
    
    [TCPScoketManager socketWriteData:xmlString withTimeout:-1 tag:1000];
}

- (IBAction)doMoveLeft:(id)sender
{
    NSString *identifier = @"com.vurc.system";
    NSString *type = @"Rc_Move";
    NSString *value = @"MoveLeft";
    NSString *xmlString = [self getXMLStringCommandWithIdentifier:identifier type:type value:value];
    
    [TCPScoketManager socketWriteData:xmlString withTimeout:-1 tag:1000];
}

- (IBAction)doMoveRignt:(id)sender
{
    NSString *identifier = @"com.vurc.system";
    NSString *type = @"Rc_Move";
    NSString *value = @"MoveRight";
    NSString *xmlString = [self getXMLStringCommandWithIdentifier:identifier type:type value:value];
    
    [TCPScoketManager socketWriteData:xmlString withTimeout:-1 tag:1000];
}

- (IBAction)doOKAction:(id)sender
{
    NSString *identifier = @"com.vurc.system";
    NSString *type = @"Rc_Navigation";
    NSString *value = @"Enter";
    NSString *xmlString = [self getXMLStringCommandWithIdentifier:identifier type:type value:value];
    
    [TCPScoketManager socketWriteData:xmlString withTimeout:-1 tag:1000];
    
}

- (IBAction)doBackAction:(id)sender
{
    NSString *identifier = @"com.vurc.system";
    NSString *type = @"Rc_Navigation";
    NSString *value = @"Back";
    NSString *xmlString = [self getXMLStringCommandWithIdentifier:identifier type:type value:value];
    
    [TCPScoketManager socketWriteData:xmlString withTimeout:-1 tag:1000];
}

- (IBAction)toHomePage:(id)sender
{
    NSString *identifier = @"com.vurc.system";
    NSString *type = @"Rc_SendKeyCode";
    NSString *value = @"HOME";
    NSString *xmlString = [self getXMLStringCommandWithIdentifier:identifier type:type value:value];
    
    [TCPScoketManager socketWriteData:xmlString withTimeout:-1 tag:1000];
    
}

- (IBAction)toMenuPage:(id)sender
{
    NSString *identifier = @"com.vurc.system";
    NSString *type = @"Rc_SendKeyCode";
    NSString *value = @"82";
    NSString *xmlString = [self getXMLStringCommandWithIdentifier:identifier type:type value:value];
    
    [TCPScoketManager socketWriteData:xmlString withTimeout:-1 tag:1000];
}

- (IBAction)doVODAction:(id)sender
{
    NSString *identifier = @"epg.vurc.action";
    NSString *type = @"Rc_RequestStartUpApp";
    NSString *value = @"";
    NSString *xmlString = [self getXMLStringCommandWithIdentifier:identifier type:type value:value];
    
    [TCPScoketManager socketWriteData:xmlString withTimeout:-1 tag:1000];
}

- (IBAction)doTimeShiftAction:(id)sender
{
    NSString *identifier = @"com.vurc.system";
    NSString *type = @"Rc_SendKeyCode";
    NSString *value = @"201";
    NSString *xmlString = [self getXMLStringCommandWithIdentifier:identifier type:type value:value];
    
    [TCPScoketManager socketWriteData:xmlString withTimeout:-1 tag:1000];
}

- (IBAction)doPullScreen:(id)sender
{
    NSString *xmlString = @"<?xml version='1.0' encoding='utf-8' standalone='no' ?><Message targetName=\"epg.vurc.action,com.hlj.live.action,epg.vurc.goback.action\"><Body><![CDATA[<?xml version='1.0' encoding='utf-8' standalone='no' ?><Message type=\"Rc_RequestDragTvVdieoToMobile\"></Message>]]></Body></Message>\n";
    
    [TCPScoketManager socketWriteData:xmlString withTimeout:-1 tag:1000];
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
- (NSString *)getXMLStringCommandWithIdentifier:(NSString *)identifier type:(NSString *)type value:(NSString *)value;
{
    NSString *xmlString = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><Message targetName=\"%@\"><Body><![CDATA[<?xml version='1.0' encoding='utf-8' standalone='no' ?><Message type=\"%@\" value=\"%@\"></Message>]]></Body></Message>\n",identifier,  type, value];
    
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
    
    NSDictionary *dic = [NSDictionary dictionaryWithXMLData:data];
    DONG_Log(@"dic:%@",dic);
    
    if (dic) {
        if ([dic[@"_value"] isEqualToString:@"tvPushMobileVideoInfo"] &&
            [dic[@"_type"] isEqualToString:@"TV_Response"]) {
            
            NSDictionary *dic2 =[NSDictionary dictionaryWithXMLString:dic[@"Body"]];
            NSLog(@"dic2:%@",dic2);
            SCFilmModel *filmModel = [[SCFilmModel alloc] init];
            filmModel.FilmName = dic2[@"filmName"];
            filmModel._Mid = dic2[@"_mid"];
            filmModel.jiIndex = [dic2[@"_sid"] integerValue];
            filmModel.currentPlayTime = [dic2[@"_currentPlayTime"] integerValue];
           
            dispatch_async(dispatch_get_main_queue(), ^{
                //调用播放器
                SCHuikanPlayerViewController *player = [SCHuikanPlayerViewController initPlayerWithFilmModel:filmModel];
                
                [self.navigationController pushViewController:player animated:YES];
            
            });
        }
    }
}

- (void)socket:(GCDAsyncSocket *)socket didConnect:(NSString *)host port:(uint16_t)port
{
    DONG_Log(@"SocketManagerDelegate连接成功");
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)socket
{
    DONG_Log(@"SocketManagerDelegate断开了");
}



// 禁止旋转屏幕
- (BOOL)shouldAutorotate {
    return NO;
}


@end
