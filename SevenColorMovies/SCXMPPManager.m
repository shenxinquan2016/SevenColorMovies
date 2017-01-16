//
//  SCXMPPManager.m
//  SevenColorMovies
//
//  Created by yesdgq on 17/1/9.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import "SCXMPPManager.h"
#import "HLJUUID.h" // uuid工具类
#import "SCFilmModel.h"
#import "SCLiveProgramModel.h"
#import "SCHuikanPlayerViewController.h"

@interface SCXMPPManager ()

@property (nonatomic, strong) XMPPStream *xmppStream;
@property (nonatomic, strong) NSString *password;

@end

@implementation SCXMPPManager

+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    static SCXMPPManager *xmppManager = nil;
    dispatch_once(&onceToken, ^{
        xmppManager = [[self alloc] init];
    });
    
    return xmppManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
       
    }
     return self;
}

- (void)initXMPPWithUserName:(NSString *)name andPassWord:(NSString *)passWord resource:(NSString *)resource
{
    self.password = passWord;
    self.xmppStream = [[XMPPStream alloc] init];
    // 设置delegate
    [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    //允许后台模式(注意iOS模拟器上是不支持后台socket的)
    self.xmppStream.enableBackgroundingOnSocket = YES;
    // 设置服务器地址 172.60.5.100  124.207.192.18
    [self.xmppStream setHostName:@"10.177.1.44"];
    [self.xmppStream setHostPort:5222];
    // 设置当前用户的信息
    XMPPJID *myJID = [XMPPJID jidWithUser:name domain:@"hljvoole.com" resource:resource];
    [self.xmppStream setMyJID:myJID];
    // 连接服务器
    NSError *error;
    [self.xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error];
    if (error) {
        DONG_Log(@"XMPPStreamConnectError:%@", error.description);
    }
 
}

- (XMPPMessage *)sendMessageWithBody:(NSString *)body andToName:(NSString *)toName andType:(NSString *)type
{
    XMPPMessage *message = [XMPPMessage messageWithType:type to:[XMPPJID jidWithString:[NSString stringWithFormat:@"%@@hljvoole.com",toName]]];
    [message addBody:body];
    
    [self.xmppStream sendElement:message];
    return message;
}

/** 连接状态 */
- (BOOL)isConnected
{
    return [self.xmppStream isConnected];
}

/** 上线 */
- (void)goOnline//上线
{
    XMPPPresence *presence = [XMPPPresence presence];
    [self.xmppStream sendElement:presence];
    
}

/** 下线 */
- (void)goOffline
{
    XMPPPresence *presence =[XMPPPresence presenceWithType:@"unavailable"];
    [[self xmppStream] sendElement:presence];
}

- (void)disConnect
{
    [self.xmppStream disconnect];
    [self goOffline];
}

#pragma mark - XMPP Delegate

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    DONG_Log(@"已经连接");
    //登陆
    [self.xmppStream authenticateWithPassword:self.password error:nil];
}

//- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
//{
//    DONG_Log(@"已经断开");
//}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    DONG_Log(@"登陆成功");
    if ([self.delegate respondsToSelector:@selector(xmppDidAuthenticate:)]) {
        [self.delegate xmppDidAuthenticate:sender];
    }

    // 通知服务器登陆状态 上线
    [self goOnline];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    DONG_Log(@"登陆失败");
    // 注册
    [self.xmppStream registerWithPassword:self.password error:nil];
}

- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    DONG_Log(@"注册成功");
    
    [self.xmppStream authenticateWithPassword:self.password error:nil];
}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error
{
    DONG_Log(@"注册失败 ：%@",error);
}

- (void)xmppStream:(XMPPStream*)sender didReceivePresence:(XMPPPresence *)presence
{
    NSString *presenceType = [presence type]; //online/offline
    //当前用户
    NSString *userId = [[self.xmppStream myJID] user] ;
    //在线用户
    NSString *presenceFromUser = [[presence from] user];
    if (![presenceFromUser isEqualToString:userId]) {
        //在线状态
        if([presenceType isEqualToString:@"available"]) {
            
            DONG_Log(@"%@上线了",presenceFromUser);
            
        } else if ([presenceType isEqualToString:@"unavailable"]) {

            DONG_Log(@"%@下线了",presenceFromUser);
        }
    }
}

/** 消息发送成功 */
- (void)xmppStream:(XMPPStream*)sender didSendMessage:(XMPPMessage *)message
{
    DONG_Log(@"消息发送成功");
    if ([self.delegate respondsToSelector:@selector(xmppDidSendMessage:)]) {
        [self.delegate xmppDidSendMessage:message];
    }
    DONG_Log(@"message:%@",message);
}

/** 消息发送失败 */
- (void)xmppStream:(XMPPStream*)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error
{
    DONG_Log(@"didFailToSendMessage:%@",error.description);
}

/** 收到消息 */
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    if ([self.delegate respondsToSelector:@selector(xmppDidReceiveMessage:)]) {
        [self.delegate xmppDidReceiveMessage:message];
    }
    
    
    NSString *info = message.body;
    
    NSDictionary *dic = [NSDictionary dictionaryWithXMLString:info];
    DONG_Log(@"dic:%@",dic);
    
    
    
    if ([dic[@"_value"] isEqualToString:@"tvPushMobileVideoInfo"] &&
        [dic[@"_type"] isEqualToString:@"TV_Response"])
    {
        NSDictionary *dic2 =[NSDictionary dictionaryWithXMLString:dic[@"Body"]];
        DONG_Log(@"dic2:%@",dic2);
        
        
        
        NSString *deviceType = @"TV";
        NSString *mid = dic2[@"_mid"];
        NSString *sid = dic2[@"_sid"];
        NSString *tvId = dic2[@"_tvid"];
        NSString *playingType = dic2[@"_playingType"];
        NSString *fromWhere = dic2[@"_fromWhere"];
        NSString *clientType = dic2[@"_clientType"];
        NSString *currentPlayTime = dic2[@"_currentPlayTime"];
        NSString *startTime = dic2[@"_startTime"];
        NSString *endTime = dic2[@"_endTime"];
        NSString *cyclePlay = dic2[@"_cyclePlay"];
        NSString *filmName = dic2[@"filmName"];
        NSString *columnCode = dic2[@"columnCode"];
        NSString *dataUrl= dic2[@"dataUrl"];
        
        NSString *targetName;
        if ([playingType isEqualToString:@"dianbo"]) {
            targetName = @"epg.vurc.action";
        } else if ([playingType isEqualToString:@"goback"]) {
            targetName = @"epg.vurc.goback.action";
        } else if ([playingType isEqualToString:@"live"]) {
            targetName = @"com.hlj.live.action";
        }
        
        NSString *toName = [NSString stringWithFormat:@"%@@hljvoole.com/%@", self.uid, self.hid];
        
        NSString *xmlString =  [self getXMLStringCommandWithTargetName:targetName deviceType:deviceType mid:mid sid:sid tvId:tvId playingType:playingType currentIndex:currentPlayTime fromWhere:fromWhere clientType:clientType currentPlayTime:currentPlayTime startTime:startTime endTime:endTime cyclePlay:cyclePlay filmName:filmName columnCode:columnCode dataUrl:dataUrl];
        
        DONG_Log(@"xmlString:%@",xmlString);
        
        [XMPPManager sendMessageWithBody:xmlString andToName:toName andType:@"text"];
        
        // 回看 的拉屏和飞屏消息
        if (dic2[@"goback"]) {
            // _startTime = 2017-01-16 03:45:00
            NSString *startTime = dic2[@"_startTime"];
            NSString *endTime = dic2[@"_endTime"];

            //获取时间戳字符串
            NSString *startTimeStamp = [NSString stringWithFormat:@"%ld", (long)[NSDate timeStampFromString:startTime format:@"yyyy-MM-dd HH:mm:ss"]];
            NSString *endTimeStamp =  [NSString stringWithFormat:@"%ld", (long)[NSDate timeStampFromString:endTime format:@"yyyy-MM-dd HH:mm:ss"]];
            
            SCLiveProgramModel *liveProgramModel = [[SCLiveProgramModel alloc] init];
            liveProgramModel.startTimeStamp = startTimeStamp;
            liveProgramModel.endTimeStamp = endTimeStamp;
            liveProgramModel.tvid = dic2[@"_tvId"];;
            
 
            
            
        } else {
            
            // 点播 的拉屏和飞屏
            SCFilmModel *filmModel = [[SCFilmModel alloc] init];
            filmModel.FilmName = dic2[@"filmName"];
            filmModel._Mid = dic2[@"_mid"];
            filmModel.jiIndex = [dic2[@"_sid"] integerValue];
            filmModel.currentPlayTime = [dic2[@"_currentPlayTime"] integerValue];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 调用播放器
                SCHuikanPlayerViewController *player = [SCHuikanPlayerViewController initPlayerWithFilmModel:filmModel];
                
                player.hidesBottomBarWhenPushed = YES;
                // 取出当前的导航控制器
                UITabBarController *tabBarVC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                // 当前选择的导航控制器
                UINavigationController *navController = (UINavigationController *)tabBarVC.selectedViewController;
                [navController pushViewController:player animated:YES];
                
            });
        }
        
        
      
        
        
    }
}


- (void)xmppStream:(XMPPStream*)sender didFailToSendPresence:(XMPPPresence *)presence error:(NSError *)error
{
    DONG_Log(@"didFailToSendPresence:%@",error.description);
}

//[xmppStream disconnect]时会执行；掉线、断网故障时不执行
- (void)xmppStreamWasToldToDisconnect:(XMPPStream*)sender
{
    DONG_Log(@"xmppStreamWasToldToDisconnect");
}

//[xmppStream disconnect]、掉线、断网故障时执行
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    NSString *str = [NSString stringWithFormat:@"服务器连接失败%@",[error.userInfo objectForKey:@"NSLocalizedDescription"]];
    DONG_Log(@"%s--=%@---\n error=%@",__func__,str,error);
    DONG_Log(@"error.userInfo =%@",error.userInfo);
    //登陆不到服务器
    //    error.userInfo ={
    //       NSLocalizedDescription = "nodename nor servnameprovided, or not known";
    //    }
    [self disConnect];
    if ([error.userInfo objectForKey:@"NSLocalizedDescription"]) {
        
    } else {
        // 好友服务器连接失败！
    }
}


/** xml命令构造器 */
- (NSString *)getXMLStringCommandWithTargetName:(NSString *)targetName deviceType:(NSString *)deviceType mid:(NSString *)mid sid:(NSString *)sid tvId:(NSString *)tvId playingType:(NSString *)playingType currentIndex:(NSString *)currentIndex fromWhere:(NSString *)fromWhere clientType:(NSString *)clientType currentPlayTime:(NSString *)currentPlayTime startTime:(NSString *)startTime endTime:(NSString *)endTime cyclePlay:(NSString *)cyclePlay filmName:(NSString *)filmName columnCode:(NSString *)columnCode dataUrl:(NSString *)dataUrl
{
    NSString *xmlString = [NSString stringWithFormat:@"<?xml version='1.0' encoding='utf-8' standalone='no' ?><Message targetName=\"%@\"><Body><![CDATA[<?xml version='1.0' encoding='utf-8' standalone='no' ?><Message type=\"Mobile_Response\" value=\"mobileStartPlayVideoInfo\"><Body><![CDATA[<?xml version='1.0' encoding='utf-8' standalone='no' ?><Device type=\"%@\" mid=\"%@\" sid=\"%@\" tvId=\"%@\" playingType=\"%@\" currentIndex=\"%@\" fromWhere=\"%@\" clientType=\"%@\" currentPlayTime=\"%@\" startTime=\"%@\" endTime=\"%@\" cyclePlay=\"%@\"><filmName><![CDATA[%@]]]]]]><![CDATA[><![CDATA[></filmName><columnCode><![CDATA[%@]]]]]]><![CDATA[><![CDATA[></columnCode><dataUrl><![CDATA[%@]]]]]]><![CDATA[><![CDATA[></dataUrl><info><![CDATA[<?xml version='1.0' encoding='utf-8' standalone='no' ?><ContentList />]]]]]]><![CDATA[><![CDATA[></info></Device>]]]]><![CDATA[></Body></Message>]]></Body></Message>\n", targetName, deviceType, mid, sid, tvId, playingType, currentIndex, fromWhere, clientType, currentPlayTime, startTime, endTime, cyclePlay, filmName, columnCode, dataUrl];
    
    return xmlString;
}



@end
