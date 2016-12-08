//
//  SCUDPSocketManager.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/12/8.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCDAsyncUdpSocket;

typedef NS_ENUM(NSUInteger, SocketOfflineType){
      SocketOfflineByServer,      //服务器掉线
      SocketOfflineByUser,        //用户断开
      SocketOfflineByWifiCut,     //wifi 断开
     };

@interface SCUDPSocketManager : NSObject


/** 心跳计时器 */
@property (nonatomic, strong) GCDAsyncUdpSocket *udpSocket;
/** 心跳计时器 */
@property (nonatomic, retain) NSTimer *heartTimeInterval;






/**
 *  下载管理器单例
 *
 *  @return 返回唯一的实例
 */
+ (instancetype)sharedUDPSocketManager;

/** 开始连接 */
- (void)startConnectSocket;

/** 断开连接 */
-(void)cutOffSocket;

/** 发送消息 */
- (void)sendMessage:(id)message;

@end
