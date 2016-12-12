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

@interface SCTCPSocketManager : NSObject

@property (nonatomic, strong) GCDAsyncSocket *socket;
@property (nonatomic, assign) NSInteger reConnectionCount;  // 建连失败重连次数
@property (nonatomic, assign, readonly) BOOL isConnected;
@property (nonatomic, assign) TCPSocketOfflineType offlineType;


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
- (void)connectToHost:(NSString *)host port:(UInt16)port delegate:(id)delegate;


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
 *  @param body 数据
 */
- (void)socketWriteData:(NSString *)data;

/**
 *  socket 读取数据
 */
- (void)socketBeginReadData;

/**
 *  socket 主动断开连接
 */
- (void)disConnectSocket;










@end
