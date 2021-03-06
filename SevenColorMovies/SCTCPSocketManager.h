//
//  SCTCPSocketManager.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/12/8.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCDAsyncSocket;

#define TCPScoketManager [SCTCPSocketManager sharedSocketManager]

typedef NS_ENUM(NSUInteger, TCPSocketOfflineType){
    SocketOfflineByServer,      //服务器掉线
    SocketOfflineByUser,        //用户断开
    SocketOfflineByWifiCut,     //wifi 断开
};

@protocol SocketManagerDelegate <NSObject>

@optional
- (void)socket:(GCDAsyncSocket *)socket didReadData:(NSData *)data;
- (void)socket:(GCDAsyncSocket *)socket didConnect:(NSString *)host port:(uint16_t)port;
- (void)socketDidDisconnect:(GCDAsyncSocket *)socket;
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag;

@end

@interface SCTCPSocketManager : NSObject

@property (nonatomic, strong) GCDAsyncSocket *socket;
@property (nonatomic, weak) id<SocketManagerDelegate> delegate;
@property (nonatomic, assign) NSInteger reConnectionCount;  // 建连失败重连次数
@property (nonatomic, assign, readonly) BOOL isConnected;
@property (nonatomic, assign) TCPSocketOfflineType offlineType;
/** 建立连接的ip */
@property (nonatomic, copy) NSString *host;

/**
 *  udpSocket单例
 *
 *  @return 返回唯一的实例
 */
+ (instancetype)sharedSocketManager;

/**
 *  连接 socket
 *
 *  @param host 连接IP地址
 *  @param port 端口
 *  @param delegate      delegate
 */
- (void)connectToHost:(NSString *)host port:(UInt16)port;


/**
 *  socket 连接成功后发送心跳的操作
 */
- (void)socketDidConnectBeginSendBeat:(NSString *)beatBody;

/**
 *  socket 连接失败后重接的操作
 */
- (void)reConnectSocket;

/**
 *  向服务器发送数据
 *
 *  @param data      消息体
 *  @param timeout   超时时间
 *  @param tag       tag
 */
- (void)socketWriteData:(NSString *)data withTimeout:(NSTimeInterval)timeout tag:(long)tag;

/**
 *  socket 读取数据
 */
- (void)socketBeginReadData;

/**
 *  socket 主动断开连接
 */
- (void)disConnectSocket;



@end
