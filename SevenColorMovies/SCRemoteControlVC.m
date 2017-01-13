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
#import "SCUDPSocketManager.h"
#import "AsyncSocket.h"
#import "SCDeviceModel.h"
#import "SCDiscoveryViewController.h"
//#import <AudioToolbox/AudioToolbox.h>
#import "SCHuikanPlayerViewController.h"
#import "SCFilmModel.h"
#import "SCSoundRecordingTool.h"//录音
#import "SCNetRequsetManger+iCloudRemoteControl.h"
#import "SCXMPPManager.h"
#import "HLJUUID.h" // uuid工具类
#import "SCVideoLoadingView.h"

#define PORT 9098

@interface SCRemoteControlVC () <SocketManagerDelegate, UdpSocketManagerDelegate, SCXMPPManagerDelegate, UIAlertViewDelegate>

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
@property (weak, nonatomic) IBOutlet UIButton *miroPhoneBtn;

/** 录音工具类 */
@property (nonatomic, strong) SCSoundRecordingTool *audioRecordingTool;
/** udpSocket实例 */
@property (nonatomic, strong) GCDAsyncUdpSocket *udpSocket;
@property (nonatomic, copy) NSString *host;
/** 语音识别服务器是否在线 */
@property (nonatomic, copy) NSString *isOnline;
/** XMPP消息接收方 */
@property (nonatomic, copy) NSString *toName;
/** 保存盒子的ip */
@property (nonatomic, strong) NSMutableArray *ipArray;
/** 保存盒子的Mac */
@property (nonatomic, strong) NSMutableArray *macArray;
/** 语音服务器状态 */
@property (nonatomic, copy) NSString *voiceServerState;

@end

@implementation SCRemoteControlVC
{
    SCVideoLoadingView *_loadView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHex:@"#1E2026"];
    // 0.初始化数组
    self.ipArray = [NSMutableArray arrayWithCapacity:0];
    self.macArray = [NSMutableArray arrayWithCapacity:0];
    
    // 1.标题
    self.leftBBI.text = @"遥控器";
    
    // 2.断开连接btn
    [self addRightBBI];
    
    // 3.建立tcp连接
//    TCPScoketManager.delegate = self;
//    
//    if (!TCPScoketManager.isConnected) {
//        [TCPScoketManager connectToHost:self.deviceModel._ip port:PORT];
//    }
    
    // 4.发广播获取盒子的IP
    UdpScoketManager.delegate = self;
    [UdpScoketManager sendBroadcast];
    
    // 5.登录XMPP
    //[CommonFunc showLoadingWithTips:@"绑定设备中..."];
    if (!XMPPManager.isConnected) {
        NSString *uuidStr = [HLJUUID getUUID];
        XMPPManager.uid = _uid;
        XMPPManager.hid = _hid;
        //[XMPPManager initXMPPWithUserName:@"8451204087955261" andPassWord:@"voole" resource:uuidStr];
        [XMPPManager initXMPPWithUserName:self.uid andPassWord:@"voole" resource:uuidStr];
    }
    
    XMPPManager.delegate = self;
    _miroPhoneBtn.enabled = NO;
    
    [self startLoadingAnimating];
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
    DONG_Log(@"🔴%s 第%d行 \n",__func__, __LINE__);
}

- (void)startLoadingAnimating
{
    _loadView = [[NSBundle mainBundle] loadNibNamed:@"SCVideoLoadingView" owner:nil options:nil][0];
    _loadView.backgroundColor = [UIColor colorWithHex:@"#000000" alpha:0.8];
    _loadView.backgroundColor = [UIColor clearColor];
    // 6.1 开始动画
    [_loadView startAnimating];
    [self.view addSubview:_loadView];
    [_loadView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(64, 64));
    }];
}

#pragma mark - IBAction

// 开始录音
- (IBAction)startRecord:(id)sender
{
    NSString *ip = [_ipArray firstObject];
    NSString *mac = [_macArray firstObject];
   
    // 扫码得到的mac地址与upd广播得到的mac地址一致时 说明设备是对应的
//    if ([mac isEqualToString:_hid]) {
    
        NSString *cloudRemoteControlUrlStr = [NSString stringWithFormat:@"http://%@:9099/prepare", ip];
        
        DONG_Log(@"cloudRemoteControlUrlStr:%@",cloudRemoteControlUrlStr);
        
        [requestDataManager postRequestDataToCloudRemoteControlServerWithUrl:cloudRemoteControlUrlStr parameters:nil success:^(id  _Nullable responseObject) {
            
            DONG_Log(@"responseObject:%@", responseObject);
            
            NSDictionary *dic = responseObject;
            
            if ([dic[@"result"] isEqualToString:@"ok"]) {
                
                _isOnline = dic[@"type"];
                
                // 语音在线识别：采样率为8000 离线识别：采样率为16000
                float sampleRate = 0.f;
                if ([_isOnline isEqualToString:@"online"]) {
                    
                    sampleRate = 8000.f;
                    
                } else if ([_isOnline isEqualToString:@"offline"]) {
                    
                    sampleRate = 16000.f;
                }
                
                //1.获取沙盒地址
                NSString *tmpPath = [FileManageCommon GetTmpPath];
                NSString *filePath = [tmpPath stringByAppendingPathComponent:@"/SoundRecord.wav"];
                
                self.audioRecordingTool = [[SCSoundRecordingTool alloc] initWithRecordFilePath:filePath sampleRate:sampleRate];
                
                self.voiceServerState = @"ok";
                [_audioRecordingTool startRecord];
                
            } else if ([dic[@"result"] isEqualToString:@"wait"] || [dic[@"result"] isEqualToString:@"error"] ) {
                
                [MBProgressHUD showError:@"语音模块初始化中，请稍后再试"];
                self.voiceServerState = @"error";
            }
            
        } failure:^(id  _Nullable errorObject) {
            
            [MBProgressHUD showError:@"网络故障，请稍后再试"];
        }];
  
//    }
    
    
}

// 结束录音
- (IBAction)touchCancel:(id)sender
{
    [self stopRecord:sender];
}

- (IBAction)stopRecord:(id)sender
{
    if ([_voiceServerState isEqualToString:@"error"]) {
        return;
        
    } else if ([_voiceServerState isEqualToString:@"ok"]) {
        
        
        [_audioRecordingTool stopRecord];
        
        NSString *tmpPath = [FileManageCommon GetTmpPath];
        NSString *wavFilePath = [tmpPath stringByAppendingPathComponent:@"/SoundRecord.wav"];
        NSString *marFilePath = [tmpPath stringByAppendingPathComponent:@"/SoundRecord.mar"];
        
        //格式转换 .wav --> .mar
        [SCSoundRecordingTool ConvertWavToAmr:wavFilePath amrSavePath:marFilePath];
        
        NSString *ip = [_ipArray firstObject];
        NSString *mac = [_macArray firstObject];
        //    if (![mac isEqualToString:_hid]) {
        //        return;
        //    }
        NSString *cloudRemoteControlUrlStr = [NSString stringWithFormat:@"http://%@:9099/recognition", ip];
        
        DONG_Log(@"marFilePath:%@", marFilePath);
        DONG_Log(@"cloudRemoteControlUrlStr:%@", cloudRemoteControlUrlStr);
        
        // 在线传.war 离线传.wav
        NSString *base64String = nil;
        if ([_isOnline isEqualToString:@"online"]) {
            
            NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:marFilePath] options:NSDataReadingMappedIfSafe error:nil];
            base64String = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
            
            DONG_Log(@"base64String.length: %lu",(unsigned long)base64String.length);
            
        } else if ([_isOnline isEqualToString:@"offline"]) {
            
            NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:wavFilePath] options:NSDataReadingMappedIfSafe error:nil];
            base64String = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        }
        
        DONG_Log(@"base64String:%@", base64String);
        
        NSString *jsonStr = [NSString stringWithFormat:@"{\"type\":\"%@\", \"sound\":\"%@\"}", _isOnline, base64String ? base64String : @"", nil];
        
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"data" , jsonStr, nil];
        
        [requestDataManager postRequestDataToCloudRemoteControlServerWithUrl:cloudRemoteControlUrlStr parameters:parameters success:^(id  _Nullable responseObject) {
            
            DONG_Log(@"responseObject:%@", responseObject);
            
            // 完成传递后将音频文件删除
            [FileManageCommon DeleteFile:wavFilePath];
            [FileManageCommon DeleteFile:marFilePath];
            
        } failure:^(id  _Nullable errorObject) {
            
            [MBProgressHUD showError:@"网络故障，请稍后再试"];
            // 失败时也将音频文件删除
            [FileManageCommon DeleteFile:wavFilePath];
            [FileManageCommon DeleteFile:marFilePath];
            
        }];

    }
    
    
//    [requestDataManager postDataToCloudRemoteControlServerWithUrl:cloudRemoteControlUrlStr parameters:parameters success:^(id  _Nullable responseObject) {
//        DONG_Log(@"responseObject:%@", responseObject);
//        
//    } failure:^(id  _Nullable errorObject) {
//        
//        
//    }];
    
}

- (IBAction)doVolumeDown:(id)sender
{
    NSString *identifier = @"com.vurc.system";
    NSString *type = @"Rc_VolumeControl";
    NSString *value = @"-1";
    NSString *xmlString = [self getXMLStringCommandWithIdentifier:identifier type:type value:value];
    //[TCPScoketManager socketWriteData:xmlString withTimeout:-1 tag:1000];
    [XMPPManager sendMessageWithBody:xmlString andToName:_toName andType:@"text"];

}

- (IBAction)doVolumeUp:(id)sender
{
    NSString *identifier = @"com.vurc.system";
    NSString *type = @"Rc_VolumeControl";
    NSString *value = @"1";
    NSString *xmlString = [self getXMLStringCommandWithIdentifier:identifier type:type value:value];
    //[TCPScoketManager socketWriteData:xmlString withTimeout:-1 tag:1000];
    [XMPPManager sendMessageWithBody:xmlString andToName:_toName andType:@"text"];
}

- (IBAction)doMoveUp:(id)sender
{
    NSString *identifier = @"com.vurc.system";
    NSString *type = @"Rc_Move";
    NSString *value = @"MoveUp";
    NSString *xmlString = [self getXMLStringCommandWithIdentifier:identifier type:type value:value];
    
    //[TCPScoketManager socketWriteData:xmlString withTimeout:-1 tag:1000];
    [XMPPManager sendMessageWithBody:xmlString andToName:_toName andType:@"text"];
}

- (IBAction)doMoveDown:(id)sender
{
    NSString *identifier = @"com.vurc.system";
    NSString *type = @"Rc_Move";
    NSString *value = @"MoveDown";
    NSString *xmlString = [self getXMLStringCommandWithIdentifier:identifier type:type value:value];
    
    //[TCPScoketManager socketWriteData:xmlString withTimeout:-1 tag:1000];
    [XMPPManager sendMessageWithBody:xmlString andToName:_toName andType:@"text"];
}

- (IBAction)doMoveLeft:(id)sender
{
    NSString *identifier = @"com.vurc.system";
    NSString *type = @"Rc_Move";
    NSString *value = @"MoveLeft";
    NSString *xmlString = [self getXMLStringCommandWithIdentifier:identifier type:type value:value];
    
    //[TCPScoketManager socketWriteData:xmlString withTimeout:-1 tag:1000];
    [XMPPManager sendMessageWithBody:xmlString andToName:_toName andType:@"text"];
}

- (IBAction)doMoveRignt:(id)sender
{
    NSString *identifier = @"com.vurc.system";
    NSString *type = @"Rc_Move";
    NSString *value = @"MoveRight";
    NSString *xmlString = [self getXMLStringCommandWithIdentifier:identifier type:type value:value];
    
    //[TCPScoketManager socketWriteData:xmlString withTimeout:-1 tag:1000];
    [XMPPManager sendMessageWithBody:xmlString andToName:_toName andType:@"text"];
}

- (IBAction)doOKAction:(id)sender
{
    NSString *identifier = @"com.vurc.system";
    NSString *type = @"Rc_Navigation";
    NSString *value = @"Enter";
    NSString *xmlString = [self getXMLStringCommandWithIdentifier:identifier type:type value:value];
    
    //[TCPScoketManager socketWriteData:xmlString withTimeout:-1 tag:1000];
    [XMPPManager sendMessageWithBody:xmlString andToName:_toName andType:@"text"];
    
}

- (IBAction)doBackAction:(id)sender
{
    NSString *identifier = @"com.vurc.system";
    NSString *type = @"Rc_Navigation";
    NSString *value = @"Back";
    NSString *xmlString = [self getXMLStringCommandWithIdentifier:identifier type:type value:value];
    
    //[TCPScoketManager socketWriteData:xmlString withTimeout:-1 tag:1000];
    [XMPPManager sendMessageWithBody:xmlString andToName:_toName andType:@"text"];
}

- (IBAction)toHomePage:(id)sender
{
    NSString *identifier = @"com.vurc.system";
    NSString *type = @"Rc_SendKeyCode";
    NSString *value = @"HOME";
    NSString *xmlString = [self getXMLStringCommandWithIdentifier:identifier type:type value:value];
    
    //[TCPScoketManager socketWriteData:xmlString withTimeout:-1 tag:1000];
    [XMPPManager sendMessageWithBody:xmlString andToName:_toName andType:@"text"];
    
}

- (IBAction)toMenuPage:(id)sender
{
    NSString *identifier = @"com.vurc.system";
    NSString *type = @"Rc_SendKeyCode";
    NSString *value = @"82";
    NSString *xmlString = [self getXMLStringCommandWithIdentifier:identifier type:type value:value];
    
    //[TCPScoketManager socketWriteData:xmlString withTimeout:-1 tag:1000];
    [XMPPManager sendMessageWithBody:xmlString andToName:_toName andType:@"text"];
}

- (IBAction)doVODAction:(id)sender
{
    NSString *identifier = @"epg.vurc.action";
    NSString *type = @"Rc_RequestStartUpApp";
    NSString *value = @"";
    NSString *xmlString = [self getXMLStringCommandWithIdentifier:identifier type:type value:value];
    
    //[TCPScoketManager socketWriteData:xmlString withTimeout:-1 tag:1000];
    [XMPPManager sendMessageWithBody:xmlString andToName:_toName andType:@"text"];
}

- (IBAction)doTimeShiftAction:(id)sender
{
    NSString *identifier = @"com.vurc.system";
    NSString *type = @"Rc_SendKeyCode";
    NSString *value = @"201";
    NSString *xmlString = [self getXMLStringCommandWithIdentifier:identifier type:type value:value];
    
    //[TCPScoketManager socketWriteData:xmlString withTimeout:-1 tag:1000];
    [XMPPManager sendMessageWithBody:xmlString andToName:_toName andType:@"text"];
}

- (IBAction)doPullScreen:(id)sender
{
    NSString *xmlString = @"<?xml version='1.0' encoding='utf-8' standalone='no' ?><Message targetName=\"epg.vurc.action,com.hlj.live.action,epg.vurc.goback.action\"><Body><![CDATA[<?xml version='1.0' encoding='utf-8' standalone='no' ?><Message type=\"Rc_RequestDragTvVdieoToMobile\"></Message>]]></Body></Message>\n";
    
    //[TCPScoketManager socketWriteData:xmlString withTimeout:-1 tag:1000];
    [XMPPManager sendMessageWithBody:xmlString andToName:_toName andType:@"text"];
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
    //[TCPScoketManager disConnectSocket];
    [XMPPManager disConnect];
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
    [_miroPhoneBtn setImage:[UIImage imageNamed:@"Microphone_Click"] forState:UIControlStateHighlighted];
    
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

#pragma mark - UdpSocketManagerDelegate

-(void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContex
{
    //取得发送发的ip和端口
    NSString *ip = [GCDAsyncUdpSocket hostFromAddress:address];
    uint16_t port = [GCDAsyncUdpSocket portFromAddress:address];
    
    //data就是接收的数据
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    DONG_Log(@"GCDAsyncUdpSocket接收到消息 ip:%@ port:%u data:%@",ip, port,message);
    
    NSError *myError;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&myError];
    DONG_Log(@"dic:%@",dic);
    
    NSString *ipStr = dic[@"ip"];
    NSString *macStr = dic[@"mac"];
    
    if (ipStr) {
        [_ipArray addObject:ipStr];
        [_macArray addObject:macStr];
        // 更改遥控器UI交互
        DONG_MAIN(^{
            _miroPhoneBtn.enabled = YES;
        });
    }
    
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

- (void)socket:(GCDAsyncSocket *)socket didReadData:(NSData *)data
{
    DONG_Log(@"SocketManagerDelegate读取数据成功");
    
    NSDictionary *dic = [NSDictionary dictionaryWithXMLData:data];
    DONG_Log(@"dic:%@",dic);
    
    if (dic) {
        if ([dic[@"_value"] isEqualToString:@"tvPushMobileVideoInfo"] &&
            [dic[@"_type"] isEqualToString:@"TV_Response"]) {
            
            NSDictionary *dic2 =[NSDictionary dictionaryWithXMLString:dic[@"Body"]];
            DONG_Log(@"dic2:%@",dic2);
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
    self.host = host;
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)socket
{
    DONG_Log(@"SocketManagerDelegate断开了");
}

#pragma mark - SCXMPPManagerDelegate

- (void)xmppDidAuthenticate:(XMPPStream *)sender
{
//    self.hid = @"766572792900";
//    self.uid = @"8451204087955261";
    
//    NSString *toName = @"8451204087955261@hljvoole.com/766572792900";
    NSString *toName = [NSString stringWithFormat:@"%@@hljvoole.com/%@", self.uid, self.hid];
    self.toName = toName;
    // 绑定试试
    NSString *uuidStr = [HLJUUID getUUID];
    DONG_Log(@"toName:%@",toName);
    DONG_Log(@"uuidStr:%@",uuidStr);
    NSString *xmlString = [NSString stringWithFormat:@"<?xml version='1.0' encoding='utf-8' standalone='no' ?><Message targetName=\"com.vurc.self\"  type=\"Rc_bind\" value=\"BindTv\" from=\"%@\" to=\"%@\" cardnum=\"%@\"><info>![CDATA[信息描述]]</info></Message>", uuidStr, self.hid, self.uid];
    
    [XMPPManager sendMessageWithBody:xmlString andToName:toName andType:@"text"];
    
}

- (void)xmppDidReceiveMessage:(XMPPMessage*)message
{
    NSString *from = message.fromStr;
    NSString *info = message.body;
    DONG_Log(@"接收到 %@ 说：%@",from, info);
    
    NSDictionary *dic = [NSDictionary dictionaryWithXMLString:info];
    DONG_Log(@"dic:%@",dic);
    
    if (dic) {
        if ([dic[@"info"] isEqualToString:@"操作成功"]) {
            // 绑定成功
            
//            [_loadView endAnimating];
            [CommonFunc dismiss];
        } else if ([dic[@"info"] isEqualToString:@"![CDATA[信息描述]]"]) {
            // 绑定失败
            
//            [_loadView endAnimating];
            [CommonFunc dismiss];
        } else if ([dic[@"info"] isEqualToString:@"当前设备未绑定任何设备!"]) {
            // 被其他设备挤掉线
            
            
        } else if ([dic[@"_value"] isEqualToString:@"tvPushMobileVideoInfo"] &&
            [dic[@"_type"] isEqualToString:@"TV_Response"])
        {
            // 拉屏 飞屏
            NSDictionary *dic2 =[NSDictionary dictionaryWithXMLString:dic[@"Body"]];
            DONG_Log(@"dic2:%@",dic2);
            SCFilmModel *filmModel = [[SCFilmModel alloc] init];
            filmModel.FilmName = dic2[@"filmName"];
            filmModel._Mid = dic2[@"_mid"];
            filmModel.jiIndex = [dic2[@"_sid"] integerValue];
            filmModel.currentPlayTime = [dic2[@"_currentPlayTime"] integerValue];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 调用播放器
                SCHuikanPlayerViewController *player = [SCHuikanPlayerViewController initPlayerWithFilmModel:filmModel];
                
                [self.navigationController pushViewController:player animated:YES];
                
            });
        }
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// 禁止旋转屏幕
- (BOOL)shouldAutorotate {
    return NO;
}


@end
