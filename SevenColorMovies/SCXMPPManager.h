//
//  SCXMPPManager.h
//  SevenColorMovies
//
//  Created by yesdgq on 17/1/9.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XMPP.h>

#define XMPPManager [SCXMPPManager shareManager]

@protocol SCXMPPManagerDelegate <NSObject>
@required
- (void)didAuthenticate:(XMPPStream *)sender;
- (void)didReceiveMessage:(XMPPMessage*)message;

@end


@interface SCXMPPManager : NSObject

@property (nonatomic, weak) id<SCXMPPManagerDelegate> delegate;
@property (nonatomic, assign, readonly) BOOL isConnected;

/**
 *  XMPP单例
 *
 *  @return 返回唯一的实例
 */
+ (instancetype)shareManager;

/**
 *  XMPP断开连接
 */
- (void)disConnect;

/**
 *  XMPP登录
 */
- (void)initXMPPWithUserName:(NSString *)name andPassWord:(NSString *)passWord resource:(NSString *)resource;;

/**
 *  发送消息
 *
 *  @param   body    消息体
 *  @param   toName  接受者
 *  @param   type    消息类型
 *  @return  XMPPMessage
 */
- (XMPPMessage *)sendMessageWithBody:(NSString *)body andToName:(NSString *)toName andType:(NSString *)type;


@end

