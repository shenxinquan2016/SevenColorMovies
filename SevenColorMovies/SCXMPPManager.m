//
//  SCXMPPManager.m
//  SevenColorMovies
//
//  Created by yesdgq on 17/1/9.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import "SCXMPPManager.h"

@interface SCXMPPManager ()

@end

@implementation SCXMPPManager

+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    static SCXMPPManager *xmppManager = nil;
    dispatch_once(&onceToken, ^{
        xmppManager = [[self alloc] init];
    });
    
    return xmppManager;
}



- (void)initXMPPWithUserName:(NSString *)name andPassWord:(NSString *)passWord
{
    self.password = passWord;
    self.xmppStream = [[XMPPStream alloc]init];
    // 设置delegate
    [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    // 设置服务器地址 172.60.5.100  124.207.192.18
    [self.xmppStream setHostName:@"10.177.1.44"];
    [self.xmppStream setHostPort:5222];
    //    设置当前用户的信息
    NSString *jidName = [NSString stringWithFormat:@"%@@hljvoole.com",name];
    XMPPJID *myJID = [XMPPJID jidWithString:jidName];
    [self.xmppStream setMyJID:myJID];
    //    连接服务器
    [self.xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:nil];
}

- (XMPPMessage *)sendMessageWithBody:(NSString *)body andToName:(NSString *)toName andType:(NSString *)type
{
    XMPPMessage *message = [XMPPMessage messageWithType:type to:[XMPPJID jidWithString:[NSString stringWithFormat:@"%@@hljvoole.com",toName]]];
    [message addBody:body];
    
    [self.xmppStream sendElement:message];
    return message;
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    DONG_Log(@"已经连接");
    //登陆
    [self.xmppStream authenticateWithPassword:self.password error:nil];
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    DONG_Log(@"已经断开");
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    DONG_Log(@"登陆成功");
    
    //   通知服务器登陆状态
    [self.xmppStream sendElement:[XMPPPresence presence]];
    
}


- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    DONG_Log(@"登陆失败");
    //    注册
    [self.xmppStream registerWithPassword:self.password error:nil];
}

- (void)xmppStreamDidRegister:(XMPPStream *)sender{
    DONG_Log(@"注册成功！");
    
    [self.xmppStream authenticateWithPassword:self.password error:nil];
}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    DONG_Log(@"注册失败 ：%@",error);
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    [self.delegate didReceiveMessage:message];
    
}


@end
