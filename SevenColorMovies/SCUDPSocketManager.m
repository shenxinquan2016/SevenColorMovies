//
//  SCUDPSocketManager.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/12/8.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCUDPSocketManager.h"
#import "GCDAsyncUdpSocket.h"

#define PORT 9816

@interface SCUDPSocketManager () <GCDAsyncUdpSocketDelegate>

@end


@implementation SCUDPSocketManager


/** udpSocket单例 */
+ (instancetype)sharedUDPSocketManager {
    static dispatch_once_t onceToken;
    static SCUDPSocketManager *socketManager = nil;
    dispatch_once(&onceToken, ^{
        socketManager = [[self alloc] init];
    });
    
    return socketManager;
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    
    return self;
}

/** UDP连接 */
- (void)connectUDPSocketWithDelegate:(nonnull id)delegate
{
    //创建一个后台队列 等待接收数据
    dispatch_queue_t dQueue = dispatch_queue_create("My socket queue", NULL); //第一个参数是该队列的名字
    
    //1.实例化一个udp socket套接字对象
    // udpServerSocket需要用来接收数据
    self.udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:delegate delegateQueue:dQueue socketQueue:nil];
    
    //2.服务器端来监听端口9814(等待端口9814的数据)
    [self.udpSocket bindToPort:PORT error:nil];
    
    //3.开启广播模式
    [self.udpSocket enableBroadcast:YES error:nil];
    
    //4.接收一次消息(启动一个等待接收,且只接收一次)
    [self.udpSocket receiveOnce:nil];
    
    NSError *error = nil;
    if (![self.udpSocket bindToPort:PORT error:&error]) {
        NSLog(@"Error starting server (bind): %@", error);
    }
    if (![self.udpSocket beginReceiving:&error]) {
        [self.udpSocket close];
        NSLog(@"Error starting server (recv): %@", error);
    }
    // send boardcast
    if(![self.udpSocket enableBroadcast:YES error:&error]){
        NSLog(@"Error enableBroadcast (bind): %@", error);
    }
    NSLog(@"udp servers success starting %hu", [self.udpSocket localPort]);
}
/** 发送消息 */
- (void)sendMessage:(id)message {
    
    NSString *s = @"谁在线";
    NSData *data = [s dataUsingEncoding:NSUTF8StringEncoding];
    // 给网段内所有的人发送消息 四个255表示广播地址
    NSString *host = @"255.255.255.255";
    uint16_t port = PORT;
    
    //开始发送
    //该函数只是启动一次发送 它本身不进行数据的发送, 而是让后台的线程慢慢的发送 也就是说这个函数调用完成后,数据并没有立刻发送,异步发送
    [self.udpSocket sendData:data toHost:host port:port withTimeout:-1 tag:100];
    
}

@end
