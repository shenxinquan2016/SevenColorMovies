//
//  SCTCPSocketManager.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/12/8.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCTCPSocketManager.h"
#import "GCDAsyncSocket.h"

#define HOST @"192.168.0.1"
#define PORT 8080
#define TIME_OUT 20
/** 设置写入读取超时 -1 表示不会使用超时 */
#define WRITE_TIME_OUT -1
#define READ_TIME_OUT -1
#define MAX_BUFFER 1024


@interface SCTCPSocketManager () <GCDAsyncSocketDelegate>

@property (nonatomic, assign) NSInteger beatCount;      // 发送心跳次数，用于重连
/** 心跳计时器 */
@property (nonatomic, retain) NSTimer *heartBeatTimer;
@property (nonatomic, strong) NSTimer *reconnectTimer;  // 重连定时器
/** ip */
@property (nonatomic, copy) NSString *host;
/** 端口 */
@property (nonatomic, assign) UInt16 port;
/** 发数据处理的串行队列 */
@property (strong, nonatomic) dispatch_queue_t socketQueue;
/** 收数据处理的串行队列 */
@property (strong, nonatomic) dispatch_queue_t receiveQueue;

@end

@implementation SCTCPSocketManager


/** udpSocket单例 */
+ (instancetype)sharedSocketManager {
    static dispatch_once_t onceToken;
    static SCTCPSocketManager *socketManager = nil;
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

/** 连接 socket */
- (void)connectToHost:(NSString *)host port:(UInt16)port
{
    //创建一个后台队列 等待接收数据
    dispatch_queue_t dQueue = dispatch_queue_create("My socket queue", NULL); //第一个参数是该队列的名字
    
    self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dQueue];
    NSError *error;
    [self.socket connectToHost:host onPort:port error:&error];
    NSLog(@"connect error: --- %@", error);
    self.host = host;
    self.port = port;
}

/** socket 连接成功后发送心跳的操作 */
- (void)socketDidConnectBeginSendBeat:(NSString *)beatBody
{
    if (!self.heartBeatTimer) {
        DONG_MainThread(
                        self.heartBeatTimer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                                               target:self
                                                                             selector:@selector(sendBeat:)
                                                                             userInfo:beatBody
                                                                              repeats:YES];
                        [[NSRunLoop currentRunLoop] addTimer:self.heartBeatTimer forMode:NSRunLoopCommonModes];
        );
    }
    
}

#pragma mark - 心跳
- (void)sendBeat:(NSTimer *)timer
{
    DONG_Log(@"heartBeating...");
    [self socketWriteData:timer.userInfo];
    
}

/** socket 连接失败后重新链接 */
- (void)reConnectSocket
{
    DONG_Log(@"GCDAsyncSocket重新连接中...");
    NSError *error;
    [self.socket connectToHost:self.host onPort:self.port withTimeout:30 error:&error];
}

/** 向服务器发送数据 */
- (void)socketWriteData:(NSString *)data
{
    NSData *requestData = [data dataUsingEncoding:NSUTF8StringEncoding];
    [self.socket writeData:requestData withTimeout:-1 tag:0];
    [self socketBeginReadData];
}

/** socket 读取数据 */
- (void)socketBeginReadData {
    [self.socket readDataToData:[GCDAsyncSocket CRLFData] withTimeout:10 maxLength:0 tag:0];
}

/** socket 主动断开连接 */
- (void)disConnectSocket
{
    [self.socket disconnect];
    self.offlineType = SocketOfflineByUser;
    [self.heartBeatTimer invalidate];
    self.heartBeatTimer = nil;
    
}

/** 连接状态 */
- (BOOL)isConnected
{
    return [self.socket isConnected];
}


-(void)checkLongConnectByServe{
    // 向服务器发送固定可是的消息，来检测长连接
    NSString *longConnect = @"connect is here";
    NSData   *data  = [longConnect dataUsingEncoding:NSUTF8StringEncoding];
    [self.socket writeData:data withTimeout:1 tag:1];
}



- (dispatch_queue_t)socketQueue {
    if (_socketQueue == nil) {
        _socketQueue = dispatch_queue_create("com.sendSocket", DISPATCH_QUEUE_SERIAL);
    }
    return _socketQueue;
}

- (dispatch_queue_t)receiveQueue {
    if (_receiveQueue == nil) {
        _receiveQueue = dispatch_queue_create("com.receiveSocket", DISPATCH_QUEUE_SERIAL);
    }
    return _receiveQueue;
}



#pragma mark - GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
    
}

/** 连接成功 */
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    DONG_Log(@"GCDAsyncSocketDelegate链接服务器成功 ip:%@ port:%d", host, port);
    dispatch_async(self.receiveQueue, ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(socket:didConnect:port:)]) {
            [self.delegate socket:sock didConnect:host port:port];
        }
    });
    [self.socket readDataWithTimeout:-1 tag:100];
}

/**
 * 断开连接
 * 如果error有值，连接失败，如果没值，正常断开
 */
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    if (err) {
        DONG_Log(@"GCDAsyncSocket服务器连接失败");
        // 重新连接
        [self reConnectSocket];
        
        dispatch_async(self.receiveQueue, ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(socketDidDisconnect:)]) {
                [self.delegate socketDidDisconnect:sock];
            }
        });

    } else  {
        DONG_Log(@"GCDAsyncSocket连接已被断开");
    }
    
}

/** 接收消息成功 */
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    DONG_Log(@"接收到的data：%@", data);
    dispatch_async(self.receiveQueue, ^{
        // 防止 didReadData 被阻塞，用个其他队列里的线程去回调 block
        if (self.delegate && [self.delegate respondsToSelector:@selector(socket:didReadData:)]) {
            [self.delegate socket:sock didReadData:data];
        }
    });
    [self.socket readDataWithTimeout:-1 tag:100];
}

/** 发送消息成功 */
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"数据成功发送到服务器");
    //数据发送成功后，自己调用一下读取数据的方法，接着socket才会调用读取数据的代理方法
    [self.socket readDataWithTimeout:-1 tag:tag];
    
}




@end
