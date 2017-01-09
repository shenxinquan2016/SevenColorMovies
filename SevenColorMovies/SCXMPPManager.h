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
- (void)didReceiveMessage:(XMPPMessage*)message;

@end


@interface SCXMPPManager : NSObject

@property (nonatomic, weak) id<SCXMPPManagerDelegate> delegate;

/**
 *  XMPP单例
 *
 *  @return 返回唯一的实例
 */
+ (instancetype)shareManager;

/**
 *  XMPP 断开连接
 */
- (void)disConnectXMPP;

/**
 *  XMPP 登录
 */
- (void)initXMPPWithUserName:(NSString *)name andPassWord:(NSString *)passWord;

/**
 *  发送消息
 *
 *  @param   body
 *  @param   toName
 *  @param   type
 *  @return  XMPPMessage
 */
- (XMPPMessage *)sendMessageWithBody:(NSString *)body andToName:(NSString *)toName andType:(NSString *)type;


@end

