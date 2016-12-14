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

@property (nonatomic, copy) NSString *host;
@property (nonatomic, assign) uint16_t port;

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
        //创建一个后台队列 等待接收数据
        dispatch_queue_t dQueue = dispatch_queue_create("My socket queue", NULL); //第一个参数是该队列的名字
        
        //1.实例化一个udp socket套接字对象
        // udpServerSocket需要用来接收数据
        self.udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dQueue socketQueue:nil];
        
        //2.服务器端来监听端口9816(等待端口9816的数据)
        [self.udpSocket bindToPort:PORT error:nil];
        
        //3.开启广播模式
        [self.udpSocket enableBroadcast:YES error:nil];
        
        //4.接收一次消息(启动一个等待接收,且只接收一次)
        [self.udpSocket receiveOnce:nil];
        
        NSError *error = nil;
        if (![self.udpSocket bindToPort:PORT error:&error]) {
            DONG_Log(@"Error starting server (bind): %@", error);
        }
        if (![self.udpSocket beginReceiving:&error]) {
            [self.udpSocket close];
            DONG_Log(@"Error starting server (recv): %@", error);
        }
        // send boardcast
        if(![self.udpSocket enableBroadcast:YES error:&error]){
            DONG_Log(@"Error enableBroadcast (bind): %@", error);
        }
        DONG_Log(@"udp servers success starting %hu", [self.udpSocket localPort]);

    }
    
    return self;
}

/** 向指定IP发送消息 */
- (void)sendMessage:(id)message toHost:(NSString *)host port:(uint16_t)port withTimeOut:(NSTimeInterval)timeout tag:(long)tag
{
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];

    //开始发送
    //该函数只是启动一次发送 它本身不进行数据的发送, 而是让后台的线程慢慢的发送 也就是说这个函数调用完成后,数据并没有立刻发送,异步发送
    [self.udpSocket sendData:data toHost:host port:port withTimeout:timeout tag:tag];
    
}

/** 发送广播 */
- (void)sendBroadcast
{
    NSString *s = @"广播信号";
    NSData *data = [s dataUsingEncoding:NSUTF8StringEncoding];
    // 给网段内所有的人发送消息 四个255表示广播地址
    NSString *host = @"255.255.255.255";
    uint16_t port = PORT;
    
    //开始发送
    //该函数只是启动一次发送 它本身不进行数据的发送, 而是让后台的线程慢慢的发送 也就是说这个函数调用完成后,数据并没有立刻发送,异步发送
    [self.udpSocket sendData:data toHost:host port:port withTimeout:-1 tag:100];
}

-(void)sendBackToHost:(NSString *)ip port:(uint16_t)port withMessage:(NSString *)s
{
    NSString *msg = @"我已接收到消息";
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    
    [self.udpSocket sendData:data toHost:ip port:port withTimeout:60 tag:200];
}



#pragma mark - UDPSocketDelegate

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(udpSocket:didConnectToAddress:)]) {
        [self.delegate udpSocket:sock didConnectToAddress:address];
    }
   

    DONG_Log(@"GCDAsyncUdpSocket连接成功");
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError *)error
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(udpSocket:didNotConnect:)]) {
        [self.delegate udpSocket:sock didNotConnect:error];
    }
    
    
    if (error) {
        DONG_Log(@"GCDAsyncUdpSocket连接被断开");
    } else {
        DONG_Log(@"GCDAsyncUdpSocket连接失败");
    }
    
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContex
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(udpSocket:didReceiveData:fromAddress:withFilterContext:)]) {
        [self.delegate udpSocket:sock didReceiveData:data fromAddress:address withFilterContext:filterContex];
    }
    
    
    //取得发送发的ip和端口
    NSString *ip = [GCDAsyncUdpSocket hostFromAddress:address];
    uint16_t port = [GCDAsyncUdpSocket portFromAddress:address];
    
    //data就是接收的数据
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    DONG_Log(@"GCDAsyncUdpSocket接收到消息 ip:%@ port:%u data:%@",ip, port,message);
 
    
    //[self sendBackToHost: ip port:port withMessage:message];
    
    //再次启动一个等待
    [self.udpSocket receiveOnce:nil];
    
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(udpSocket:didSendDataWithTag:)]) {
        [self.delegate udpSocket:sock didSendDataWithTag:tag];
    }
    
    DONG_Log(@"GCDAsyncUdpSocket数据发送成功");
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"标记为tag %ld的发送失败 失败原因 %@",tag, error);
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error
{
    NSLog(@"UDP链接关闭 原因 %@", error);
}



@end
