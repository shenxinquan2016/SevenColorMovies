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

static const NSInteger kBeatLimit = 10;

@interface SCTCPSocketManager () <GCDAsyncSocketDelegate>

@property (nonatomic, assign) NSInteger beatCount;      // 发送心跳次数，用于重连
/** 心跳计时器 */
@property (nonatomic, retain) NSTimer *heartBeatTimer;
@property (nonatomic, strong) NSTimer *reconnectTimer;  // 重连定时器

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
        self.connectStatus = -1;
    }
    return self;
}

/** 连接 socket */
- (void)connectToHost:(NSString *)host port:(UInt16)port delegate:(id)delegate
{
    //创建一个后台队列 等待接收数据
    dispatch_queue_t dQueue = dispatch_queue_create("My socket queue", NULL); //第一个参数是该队列的名字
    
    self.socket = [[GCDAsyncSocket alloc] initWithDelegate:delegate delegateQueue:dQueue];
    NSError *error;
    [self.socket connectToHost:host onPort:port error:&error];
    NSLog(@"connect error: --- %@", error);
    
}

/** socket 连接成功后发送心跳的操作 */
- (void)socketDidConnectBeginSendBeat:(NSString *)beatBody {
    self.connectStatus = 1;
    self.reconnectionCount = 0;
    if (!self.heartBeatTimer) {
        self.heartBeatTimer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                          target:self
                                                        selector:@selector(sendBeat:)
                                                        userInfo:beatBody
                                                         repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.heartBeatTimer forMode:NSRunLoopCommonModes];
    }
}


/** socket 连接失败后重新链接 */
- (void)socketDidDisconectBeginSendReconnect:(NSString *)reconnectBody {
    self.connectStatus = -1;
    
    if (self.reconnectionCount >= 0 && self.reconnectionCount <= kBeatLimit) {
        NSTimeInterval time = pow(2, self.reconnectionCount);
        if (!self.reconnectTimer) {
            self.reconnectTimer = [NSTimer scheduledTimerWithTimeInterval:time
                                                                   target:self
                                                                 selector:@selector(reconnection:)
                                                                 userInfo:reconnectBody
                                                                  repeats:NO];
            [[NSRunLoop mainRunLoop] addTimer:self.reconnectTimer forMode:NSRunLoopCommonModes];
        }
        self.reconnectionCount++;
    } else {
        [self.reconnectTimer invalidate];
        self.reconnectTimer = nil;
        self.reconnectionCount = 0;
    }
}

/** 向服务器发送数据 */
- (void)socketWriteData:(NSString *)data
{
    NSData *requestData = [data dataUsingEncoding:NSUTF8StringEncoding];
    [self.socket writeData:requestData withTimeout:-1 tag:0];
    //[self socketBeginReadData];
}

/** socket 读取数据 */
- (void)socketBeginReadData {
    [self.socket readDataToData:[GCDAsyncSocket CRLFData] withTimeout:10 maxLength:0 tag:0];
}

/** socket 主动断开连接 */
- (void)disconnectSocket {
    self.reconnectionCount = -1;
    [self.socket disconnect];
    
    [self.heartBeatTimer invalidate];
    self.heartBeatTimer = nil;
}

/** 重设心跳次数 */
- (void)resetBeatCount {
    self.beatCount = 0;
}

#pragma mark - 心跳连接
- (void)sendBeat:(NSTimer *)timer {
    if (self.beatCount >= kBeatLimit) {
        [self disconnectSocket];
        return;
    } else {
        self.beatCount++;
    }
    if (timer != nil) {
        [self socketWriteData:timer.userInfo];
    }
}

- (void)reconnection:(NSTimer *)timer {
    NSError *error = nil;
    if (![self.socket connectToHost:HOST onPort:PORT withTimeout:30 error:&error]) {
        self.connectStatus = -1;
    }
}


-(void)checkLongConnectByServe{
    // 向服务器发送固定可是的消息，来检测长连接
    NSString *longConnect = @"connect is here";
    NSData   *data  = [longConnect dataUsingEncoding:NSUTF8StringEncoding];
    [self.socket writeData:data withTimeout:1 tag:1];
}






#pragma mark - GCDAsyncSocketDelegate
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
    
    
}
/** 连接成功 */
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"GCDAsyncSocketDelegate链接服务器成功");
    
    //通过定时器不断发送消息，来检测长连接
    [self socketDidConnectBeginSendBeat:nil];
    
}

/** 连接失败 */
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"GCDAsyncSocket服务器连接失败");
    [self socketDidDisconectBeginSendReconnect:@"重新连接"];
}

/** 接收消息成功 */
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    //服务端返回消息数据量比较大时，可能分多次返回。所以在读取消息的时候，设置MAX_BUFFER表示每次最多读取多少，当data.length < MAX_BUFFER我们认为有可能是接受完一个完整的消息，然后才解析
    if( data.length < MAX_BUFFER )
    {
        //收到结果解析...
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        //解析出来的消息，可以通过通知、代理、block等传出去
    }
    
    [self.socket readDataWithTimeout:READ_TIME_OUT buffer:nil bufferOffset:0 maxLength:MAX_BUFFER tag:0];
    
}

/** 发送消息成功 */
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"数据成功发送到服务器");
    //数据发送成功后，自己调用一下读取数据的方法，接着socket才会调用读取数据的代理方法
    [self.socket readDataWithTimeout:-1 tag:tag];
}





@end
