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

/** 连接 */
- (void)connectToHost:(NSString *)host port:(UInt16)port {
    //创建一个后台队列 等待接收数据
    dispatch_queue_t dQueue = dispatch_queue_create("My socket queue", NULL); //第一个参数是该队列的名字
    
    self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dQueue];
    NSError *error;
    [self.socket connectToHost:host onPort:port error:&error];
    
}

/** 断开连接 */
-(void)cutOffSocket {
    
    [self.socket disconnect];
}



#pragma mark - GCDAsyncSocketDelegate
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"GCDAsyncSocketDelegate链接服务器成功");
    
    
    
   
    //通过定时器不断发送消息，来检测长连接
    self.heartTimeInterval = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(checkLongConnectByServe) userInfo:nil repeats:YES];
    [self.heartTimeInterval fire];
}

-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"GCDAsyncSocket服务器连接失败");
}

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *recData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (tag == 102) {//服务器返回的聊天数据需要展示到表格上
        
    }else if (tag == 101){//登陆返回的数据不需要展示在表格
        
    }
}


-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"数据成功发送到服务器");
    //数据发送成功后，自己调用一下读取数据的方法，接着socket才会调用读取数据的代理方法
    [self.socket readDataWithTimeout:-1 tag:tag];
}

#pragma mark - 心跳连接
-(void)checkLongConnectByServe{
    // 向服务器发送固定可是的消息，来检测长连接
    NSString *longConnect = @"connect is here";
    NSData   *data  = [longConnect dataUsingEncoding:NSUTF8StringEncoding];
    [self.socket writeData:data withTimeout:1 tag:1];
}

@end
