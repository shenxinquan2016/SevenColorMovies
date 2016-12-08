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


@interface SCUDPSocketManager : NSObject

/** udpSocket实例 */
@property (nonatomic, strong) GCDAsyncUdpSocket *udpSocket;







/**
 *  udpSocket单例
 *
 *  @return 返回唯一的实例
 */
+ (instancetype)sharedUDPSocketManager;


/** 发送消息 */
- (void)sendMessage:(id)message;

@end
