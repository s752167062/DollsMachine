//
//  FIMSocketManager.m
//  FIMMobSDK
//
//  Created by 宫城 on 15/9/11.
//  Copyright (c) 2015年 宫城. All rights reserved.
//

#import "GCDAsyncSocketManager.h"
#import "GCDAsyncSocket.h"

static const NSInteger TIMEOUT = 5;
//最大重连次数
static const NSInteger kBeatLimit = 3;

//重连最大次数
static const NSInteger kConectAgainLimit = 10;

@interface GCDAsyncSocketManager ()<UIAlertViewDelegate>

@property (nonatomic, strong) GCDAsyncSocket *socket;
//@property (atomic, assign) NSInteger beatCount;      // 发送心跳次数，用于重连
@property (nonatomic, strong) NSTimer *beatTimer;       // 心跳定时器
@property (nonatomic, strong) NSTimer *reconnectTimer;  // 重连定时器
@property (nonatomic, strong) NSString *host;           // Socket连接的host地址
@property (nonatomic, assign) uint16_t port;            // Sokcet连接的port

@end

@implementation GCDAsyncSocketManager

// 发送心跳次数，用于重连
static NSInteger beatCount = 0;

+ (GCDAsyncSocketManager *)sharedInstance {
    static GCDAsyncSocketManager *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
    
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    //初始化链接状态为未连接
    self.connectStatus = -1;
    
    return self;
}

#pragma mark - socket actions 设置连接的host和port
- (void)changeHost:(NSString *)host port:(NSInteger)port {
    self.host = host;
    self.port = port;
}

#pragma mark-- 设置链接的代理
- (void)connectSocketWithDelegate:(id)delegate {
    if (self.connectStatus != -1) {
        NSLog(@"Socket Connect: YES");
        return;
    }
    //连接中
    self.connectStatus = 0;
    
    //创建GCDAsyncSocket对象和设置代理
    self.socket =
    [[GCDAsyncSocket alloc] initWithDelegate:delegate delegateQueue:dispatch_get_main_queue()];
    
    NSError *error = nil;
    
    //链接失败的判断
    if (![self.socket connectToHost:self.host onPort:self.port withTimeout:TIMEOUT error:&error]) {
        self.connectStatus = -1;
        NSLog(@"connect error: --- %@", error);
    }
}

#pragma mark-- 连接成功后发送心跳的操作
- (void)socketDidConnectBeginSendBeat:(NSData *)beatBody {
    //已连接
    self.connectStatus = 1;
    //重置建连失败重连次数
    self.reconnectionCount = 0;
    
    //创建心跳定时器
    if (!self.beatTimer) {
        //5.0s执行一次
        self.beatTimer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                          target:self
                                                        selector:@selector(sendBeat:)
                                                        userInfo:beatBody
                                                         repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.beatTimer forMode:NSRunLoopCommonModes];
    }
}

#pragma mark-- 连接失败后重接的操作
- (void)socketDidDisconectBeginSendReconnect:(NSString *)reconnectBody
{
    //-1未连接
    self.connectStatus = -1;
    
    if (self.reconnectionCount >= 0 && self.reconnectionCount <= kConectAgainLimit)
    {
        //重连的时间间隔
        NSTimeInterval time = 5;
        
        //创建重连定时器
        if (!self.reconnectTimer)
        {
            self.reconnectTimer = [NSTimer scheduledTimerWithTimeInterval:time
                                                                   target:self
                                                                  selector:@selector(reconnection:)
                                                                 userInfo:reconnectBody
                                                                  repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:self.reconnectTimer forMode:NSRunLoopCommonModes];
        }
        
        self.reconnectionCount++;
    } else {
        [self invalidateReconnectTimer];
        //提示链接超时,让用户点击重连
        [self alertMsg:@"网络超时,再试一次"];
    }
}

- (void)alertMsg:(NSString *)msg
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:msg message:msg delegate:self cancelButtonTitle:@"再试一次" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //开启重连
    [self socketDidDisconectBeginSendReconnect:@""];
}

- (void)invalidateReconnectTimer
{
    [self.reconnectTimer invalidate];
    self.reconnectTimer = nil;
    self.reconnectionCount = 0;
}

#pragma mark-- 向服务器发送字符串数据
- (void)socketWriteData:(NSData *)data {
  
    
    [self socketWriteLastData:data];
}


- (void)socketWriteLastData:(nonnull NSData *)data
{
    [self.socket writeData:data withTimeout:-1 tag:0];
    //发送完成,开始读取一次数据
    [self socketBeginReadData];
}

//读取数据
- (void)socketBeginReadData {
//    [self.socket readDataToData:[GCDAsyncSocket CRLFData] withTimeout:10 maxLength:0 tag:0];
    [self.socket readDataWithTimeout:- 1 tag:0];
}

- (void)disconnectSocket {
    self.connectStatus = -1;
    [self.socket disconnect];
    
    [self.beatTimer invalidate];
    self.beatTimer = nil;
}

#pragma mark - public method
- (void)resetBeatCount {
    beatCount = 0;
}

#pragma mark - private method 发送心跳包
- (void)sendBeat:(NSTimer *)timer {
    
    //发送心跳次数，用于重连 > 最大限制次数
    if (beatCount >= kBeatLimit) {
        //主动断开连接
        [self disconnectSocket];
        //重连服务器
        [self socketDidDisconectBeginSendReconnect:@""];
        return;
    } else {
        //累加次数
        beatCount++;
    }
    if (timer != nil) {
        //发送心跳包
        [self socketWriteData:timer.userInfo];
    }
}

#pragma mark-- 发送重新链接服务器的请求
- (void)reconnection:(NSTimer *)timer {
    NSError *error = nil;
    if (![self.socket connectToHost:self.host onPort:self.port withTimeout:TIMEOUT error:&error]) {
        self.connectStatus = -1;
        
    }else{
        //连接成功
        self.connectStatus = 1;
    }
}

@end
