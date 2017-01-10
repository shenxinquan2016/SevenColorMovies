//
//  SCXMPPManager.m
//  SevenColorMovies
//
//  Created by yesdgq on 17/1/9.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import "SCXMPPManager.h"
#import "HLJUUID.h" // uuid工具类

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
    if ([self.delegate respondsToSelector:@selector(didAuthenticate:)]) {
        [self.delegate didAuthenticate:sender];
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
}

/** 消息发送失败 */
- (void)xmppStream:(XMPPStream*)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error
{
    DONG_Log(@"didFailToSendMessage:%@",error.description);
}

/** 收到消息 */
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    if ([self.delegate respondsToSelector:@selector(didReceiveMessage:)]) {
        [self.delegate didReceiveMessage:message];
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
- (NSString *)getXMLStringCommandWithIdentifier:(NSString *)identifier type:(NSString *)type value:(NSString *)value;
{
//    NSString *identifier = @"com.vurc.system";
//    NSString *type = @"Rc_Move";
//    NSString *value = @"MoveUp";

    
    NSString *xmlString = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><Message targetName=\"%@\"><Body><![CDATA[<?xml version='1.0' encoding='utf-8' standalone='no' ?><Message type=\"%@\" value=\"%@\"></Message>]]></Body></Message>\n",identifier,  type, value];
    
    return xmlString;
}

@end
