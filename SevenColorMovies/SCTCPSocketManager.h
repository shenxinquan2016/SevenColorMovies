//
//  SCTCPSocketManager.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/12/8.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCDAsyncSocket;

#define UPDScoketManager [SCTCPSocketManager sharedSocketManager]

typedef NS_ENUM(NSUInteger, SocketOfflineType){
    SocketOfflineByServer,      //服务器掉线
    SocketOfflineByUser,        //用户断开
    SocketOfflineByWifiCut,     //wifi 断开
};


@interface SCTCPSocketManager : NSObject

@property (nonatomic, strong) GCDAsyncSocket *socket;
@property (nonatomic, strong) GCDAsyncSocket *severSocket;
@property (nonatomic, strong) GCDAsyncSocket *clientSocket;

/** 心跳计时器 */
@property (nonatomic, retain) NSTimer *heartTimeInterval;



/**
 *  udpSocket单例
 *
 *  @return 返回唯一的实例
 */
+ (instancetype)sharedSocketManager;

/** 开始连接 */
- (void)connectToHost:(NSString *)host port:(UInt16)port;

/** 断开连接 */
-(void)cutOffSocket;



@end
