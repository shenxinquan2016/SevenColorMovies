//
//  SCUDPSocketManager.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/12/8.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCUDPSocketManager.h"
#import "GCDAsyncUdpSocket.h"

#define HOST @"192.168.0.1"
#define PORT 8080
#define TIME_OUT 20
/** 设置写入读取超时 -1 表示不会使用超时 */
#define WRITE_TIME_OUT -1
#define READ_TIME_OUT -1
#define MAX_BUFFER 1024

@interface SCUDPSocketManager ()<GCDAsyncUdpSocketDelegate>

@end


@implementation SCUDPSocketManager


/** 下载管理器单例 */
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
        
        //2.服务器端来监听端口12345(等待端口12345的数据)
        [self.udpSocket bindToPort:12345 error:nil];
        
        //3.接收一次消息(启动一个等待接收,且只接收一次)
        [self.udpSocket receiveOnce:nil];

        
        NSError *error = nil;
        if (![self.udpSocket bindToPort:PORT error:&error]) {
            NSLog(@"Error starting server (bind): %@", error);
            
        }
        // send boardcast
        if(![self.udpSocket enableBroadcast:YES error:&error]){
            NSLog(@"Error enableBroadcast (bind): %@", error);
            
        }
//        if (![self.udpSocket joinMulticastGroup:groupHost error:&error]) {
//            NSLog(@"Error enableBroadcast (bind): %@", error);
//            
//        }
        if (![self.udpSocket beginReceiving:&error]) {
            [self.udpSocket close];
            NSLog(@"Error starting server (recv): %@", error);
            
        }
        NSLog(@"udp servers success starting %hu", [_udpSocket localPort]);
    }
    
    return self;
}

/** 开始连接 */
- (void)startConnectSocket {
    
}

/** 断开连接 */
-(void)cutOffSocket {
    [self.udpSocket close];
}

/** 发送消息 */
- (void)sendMessage:(id)message {
    
    NSString *s = @"hello IOS";
    NSData *data = [s dataUsingEncoding:NSUTF8StringEncoding];
    NSString *host = @"10.0.161.87";
    uint16_t port = 12345;
    
    //开始发送
    //改函数只是启动一次发送 它本身不进行数据的发送, 而是让后台的线程慢慢的发送 也就是说这个函数调用完成后,数据并没有立刻发送,异步发送
    [self.udpSocket sendData:data toHost:host port:port withTimeout:60 tag:100];
    
}


#pragma mark -GCDAsyncUdpSocketDelegate
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContex
{
    //取得发送发的ip和端口
    NSString *ip = [GCDAsyncUdpSocket hostFromAddress:address];
    uint16_t port = [GCDAsyncUdpSocket portFromAddress:address];
    
    //data就是接收的数据
    NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"[%@:%u]%@",ip, port,s);
    
    [self sendBackToHost: ip port:port withMessage:s];
    //再次启动一个等待
    [self.udpSocket receiveOnce:nil];
    
}


-(void)sendBackToHost:(NSString *)ip port:(uint16_t)port withMessage:(NSString *)s{
    NSString *msg = @"我已接收到消息";
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    
    [self.udpSocket sendData:data toHost:ip port:port withTimeout:60 tag:200];
}

#pragma mark -GCDAsyncUdpSocketDelegate
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
    if (tag == 100) {
        //NSLog(@"表示标记为100的数据发送完成了");
    }
}
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error{
    NSLog(@"标记为tag %ld的发送失败 失败原因 %@",tag, error);
    
}

//-(void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext{
//    NSString *ip = [GCDAsyncUdpSocket hostFromAddress:address];
//    uint16_t port = [GCDAsyncUdpSocket portFromAddress:address];
//    NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    // 继续来等待接收下一次消息
//    NSLog(@"收到服务端的响应 [%@:%d] %@", ip, port, s);
//    [sock receiveOnce:nil];
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self sendBackToHost:ip port:port withMessage:s];
//    });
//}

@end
