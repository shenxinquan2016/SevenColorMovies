//
//  SCUDPSocketManager.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/12/8.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCDAsyncUdpSocket;

#define UPDScoketManager [SCUDPSocketManager sharedUDPSocketManager]


@protocol UdpSocketManagerDelegate <NSObject>

- (void)udpSocket:(GCDAsyncUdpSocket *)socket didConnectToAddress:(NSData *)address;
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag;
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContex;
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError *)error;

@end

@interface SCUDPSocketManager : NSObject

/** udpSocket实例 */
@property (nonatomic, strong) GCDAsyncUdpSocket *udpSocket;
@property (nonatomic, weak) id<UdpSocketManagerDelegate> delegate;




/**
 *  udpSocket单例
 *
 *  @return 返回唯一的实例
 */
+ (instancetype)sharedUDPSocketManager;

/** UDP连接 */
- (void)connectUDPSocketWithDelegate:(id)delegate;

/** 发送消息 */
- (void)sendMessage:(id)message;

@end
