
//
//  FIMCommunicationManager.m
//  FlashIMiOSDemo
//
//  Created by Broccoli on 16/4/11.
//  Copyright © 2016年 宫城. All rights reserved.
//

#import "GCDAsyncSocketCommunicationManager.h"
#import "GCDAsyncSocket.h"
#import "GCKeyChainManager.h"
#import "GCDAsyncSocketManager.h"
#import "YRCommonKey.h"
#import <UIKit/UIKit.h>
#import "AFNetworkReachabilityManager.h"
#import "GACErrorManager.h"
#import "YRSocketModel.h"
#import <MJExtension.h>
#import "YMSocketUtils.h"
#import "NSDictionary+Encrypt.h"
#import <SVProgressHUD.h>
#import "UserInfoTool.h"

/**
 *  默认通信协议版本号
 */
static NSUInteger PROTOCOL_VERSION = 7;

// 后面NSString这是运行时能获取到的C语言的类型
NSString * const TYPE_UINT8   = @"TC";// char是1个字节，8位
NSString * const TYPE_UINT16   = @"TS";// short是2个字节，16位
NSString * const TYPE_UINT32   = @"TI";//4个字节
NSString * const TYPE_UINT64   = @"TQ";//8个字节
NSString * const TYPE_STRING   = @"T@\"NSString\"";
NSString * const TYPE_ARRAY   = @"T@\"NSArray\"";

@interface GCDAsyncSocketCommunicationManager () <GCDAsyncSocketDelegate>

@property (nonatomic, strong) NSString *socketAuthAppraisalChannel;  // socket验证通道，支持多通道
@property (nonatomic, strong) NSMutableDictionary *requestsMap; //请求回调block

@property (nonatomic, strong) NSMutableDictionary *failRequestMap; //发送未成功的任务缓存

@property (nonatomic, strong) GCDAsyncSocketManager *socketManager;
@property (nonatomic, assign) NSTimeInterval interval;  //服务器与本地时间的差值
//连接配置对象
@property (nonatomic, strong, nonnull) GACConnectConfig *connectConfig;

//最终编码完成需要传输的协议数据
@property (nonatomic, strong) NSMutableData *lastData;

@property (nonatomic,strong)id object;

@property (nonatomic, strong) NSMutableData *cacheData;

@end

@implementation GCDAsyncSocketCommunicationManager

@dynamic connectStatus;


#pragma mark-- 懒加载
- (NSMutableData *)lastData
{
    if (!_lastData) {
        _lastData = [NSMutableData data];
    }
    return _lastData;
}

- (NSMutableData *)cacheData
{
    if (!_cacheData) {
        _cacheData = [NSMutableData new];
    }
    return _cacheData;
}

#pragma mark - init 单例 初始化方法

+ (GCDAsyncSocketCommunicationManager *)sharedInstance {
    static GCDAsyncSocketCommunicationManager *instance = nil;
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
    //创建socketManager对象
    self.socketManager = [GCDAsyncSocketManager sharedInstance];
    self.requestsMap = [NSMutableDictionary dictionary];
    self.failRequestMap = [NSMutableDictionary dictionary];
    //开启网络监听
    [self startMonitoringNetwork];
    return self;
}

#pragma mark - socket actions 通过自定义协议创建socket连接

- (void)createSocketWithConfig:(nonnull GACConnectConfig *)config
{
    //处理为空的判断
    if (!config.token.length || !config.channels.length || !config.host.length) {
        return;
    }
    
    self.connectConfig = config;
    self.socketAuthAppraisalChannel = config.channels;
    [GCKeyChainManager sharedInstance].token = config.token;
    //开始建立连接
    [self.socketManager changeHost:config.host port:config.port];
    PROTOCOL_VERSION = config.socketVersion;
    
    //设置链接的代理为自己
    [self.socketManager connectSocketWithDelegate:self];
}

//使用默认的连接环境
- (void)createSocketWithToken:(nonnull NSString *)token channel:(nonnull NSString *)channel {
    if (!token || !channel) {
        return;
    }

    self.socketAuthAppraisalChannel = channel;
    [GCKeyChainManager sharedInstance].token = token;
    //通用连接 192.168.1.70 9001 127.0.0.1  8080
    [self.socketManager changeHost:YR_SOCKET_HOST port:YR_SOCKET_PORT];
    
    [self.socketManager connectSocketWithDelegate:self];
}

//断开连接
- (void)disconnectSocket {
    [self.socketManager disconnectSocket];
}

#pragma mark-- 向服务器发送数据
//pid
static int YRSocketPid = 0;

static int YRRequestID = 100;

static int YRFailRequestID = 500;

- (void)socketWriteDataWithRequestType:(GACRequestType)type
                           requestBody:(NSDictionary *)body
                            completion:(nullable SocketDidReadBlock)callback
{
//    [self socketWriteDataWithRequestType:type andNeedAnswer:YES andResponseId:0 requestBody:body completion:callback];
    
    [self socketWriteDataWithRequestType:type andNeedAnswer:YES andNeedRetrySend:YES andResponseId:0 requestBody:body completion:callback];
}

#pragma mark-- 不需要断线自动重发
- (void)noRetrySocketSendWriteDataWithRequestType:(GACRequestType)type
                                      requestBody:(NSDictionary *_Nullable)body
                                       completion:(nullable SocketDidReadBlock)callback
{
    [self socketWriteDataWithRequestType:type andNeedAnswer:YES andNeedRetrySend:NO andResponseId:0 requestBody:body completion:callback];
}



/**
 发送消息

 @param type 消息类型
 @param NeedAnswer 是否需要响应 为No是请求ID为0 不响应,其它时候
 @param needRetrySend 断线未发送成功是否需要重新自动发送 Yes表示需要
 @param responseId 响应ID 为0表示服务器不需要响应
 @param body 消息内容 JSON
 @param callback 消息回调 同步请求使用
 */
- (void)socketWriteDataWithRequestType:(GACRequestType)type andNeedAnswer:(BOOL)NeedAnswer andNeedRetrySend:(BOOL)needRetrySend andResponseId:(uint32_t)responseId requestBody:(NSDictionary *)body completion:(nullable SocketDidReadBlock)callback
{
    //判断连接状态
    NSLog(@"%zd",self.socketManager.connectStatus);
    
    //FiXME:状态问题Map
//    if (self.socketManager.connectStatus != 1) {
//        //不是连接成功的状态
//
//
//    }
    
    
    //同步请求ID
    int currentRequestID = NeedAnswer ? (YRRequestID +=1) : 0;
    
    //为了完成回调,一对一 使用时间戳为key来获取回调block
    NSString *blockRequestIDStr = [NSString stringWithFormat:@"%zd",currentRequestID];
    
    //不是心跳包
    if (type != GACRequestType_SendBeat &&callback) {
        [self.requestsMap setObject:callback forKey:blockRequestIDStr];
    }
    //协议: 消息长度(int) | 标记位(byte) | 请求消息ID(int) | 响应消息ID(int) | 协议号(int) | 消息体(消息内容Json)
    YRSocketModel *socketItem = [[YRSocketModel alloc] init];
    //类型
    socketItem.typeId = type;
    //标记位
    socketItem.byteId = (YRSocketPid += 1);
    
    //消息请求ID
    socketItem.requestId = currentRequestID;
    
    //消息响应ID
    socketItem.responseId = responseId;
    
    //将消息boby转为json字符串
    NSString * bobyStrJson  = [body encrypt].mj_JSONString;
    
    //字符串一个中文在3个字节.需要用下面这个方法获取长度
    NSUInteger bytesLength = [bobyStrJson lengthOfBytesUsingEncoding:NSUTF8StringEncoding] + 13;
    
    //消息长度
    socketItem.contentLength = (int)bytesLength;
    
    //消息内容
    socketItem.bobyMsg = bobyStrJson;
    
    //自定义协议编码
    NSData *codeData = [self RequestSpliceAttribute:socketItem];
    
    if (codeData == nil) {
        NSLog(@"协议编码失败");
    }
    
    //判断socket连接状态,来判断是否保存任务
    if (self.socketManager.connectStatus != 1) {
 
        if (needRetrySend) {
            //保存任务
            [self.failRequestMap setObject:codeData forKey:[NSString stringWithFormat:@"%zd",(YRFailRequestID + 1)]];
        }
        
        if (self.socketManager.connectStatus == -1) {
            
            NSLog(@"socket 未连通");
            if (callback) {
                callback([GACErrorManager errorWithErrorCode:2003],
                         nil);
            }
            
            //开启重连
            [self.socketManager socketDidDisconectBeginSendReconnect:@""];
        }
    }else{
        
        //发送
        [self.socketManager socketWriteLastData:codeData];
        
    }
    
}


#pragma mark - GCDAsyncSocketDelegate

//将要连接上socket的时候 我们这里传一些通用参数
- (void)socket:(GCDAsyncSocket *)socket didConnectToHost:(NSString *)host port:(UInt16)port
{
    //修改连接状态
    self.socketManager.connectStatus = 1;
    NSLog(@"socket:%p didConnectToHost:%@ port:%hu", socket, host, port);
    NSLog(@"Cool, I'm connected! That was easy.");
    
    //关闭重连定时器
    [self.socketManager invalidateReconnectTimer];
    //开启心跳
//    [self beginHeartbeat];
    
    //发送用户标识
    [self sendUser_Token];
  
}

#pragma mark-- 发送用户标识
- (void)sendUser_Token
{
    NSString *userToken = [UserInfoTool getUserDefaultKey:UserDefault_User_Access_Token];
    ZMJWeakSelf(self);
    if (userToken.length > 0) {
        [self socketWriteDataWithRequestType:GACRequestType_SendUser_Token requestBody:@{@"clientToken":userToken} completion:^(NSError * _Nullable error, id  _Nullable data) {
            
            //保存token
            if (data[@"token"]) {
                [UserInfoTool setUserDefaultName:data[@"token"] ? : @"" andKey:UserDefault_User_Access_Token];
            }
            NSLog(@"%@",data);
            //发送上次没有成功发送的消息
            for (NSData *failData in weakself.failRequestMap.allValues) {
                if (failData == nil || failData.length == 0) {
                    continue;
                }
                [weakself.socketManager socketWriteLastData:failData];
            }
            [weakself.failRequestMap removeAllObjects];
            
        }];
    }
    
    
}

- (void)beginHeartbeat
{
    //协议: 消息长度(int) | 标记位(byte) | 请求消息ID(int) | 响应消息ID(int) | 协议号(int) | 消息体(消息内容Json)
    YRSocketModel *socketItem = [[YRSocketModel alloc] init];
    //类型
    socketItem.typeId = GACRequestType_SendBeat;
    //标记位
    socketItem.byteId = 0;
    
    //消息请求ID
    socketItem.requestId = 0;
    
    //消息响应ID
    socketItem.responseId = 0;
    
    //将消息boby转为json字符串
//    NSDictionary * boby  = @{@"age":@"18"};
    
    //将消息boby转为json字符串
    NSString * bobyStrJson  = nil;
    
    //字符串一个中文在3个字节.需要用下面这个方法获取长度
    NSUInteger bytesLength = [bobyStrJson lengthOfBytesUsingEncoding:NSUTF8StringEncoding] + 13;
    
    //消息长度
    socketItem.contentLength = (int)bytesLength;
    
    //消息内容
    socketItem.bobyMsg = bobyStrJson;
    
    //自定义协议编码
    NSData *codeData = [self RequestSpliceAttribute:socketItem];
    
    [self.socketManager socketDidConnectBeginSendBeat:codeData];
}

#pragma mark-- 断开重连
- (void)socketDidDisconnect:(GCDAsyncSocket *)socket withError:(NSError *)err {
    
    //连接失败的状态
    self.socketManager.connectStatus = -1;
    //发送断开重连
    NSLog(@"socketDidDisconnect:%p withError: %@", socket, err);
    //修改连接状态
    
    [self.socketManager socketDidDisconectBeginSendReconnect:@""];

}

//接收到数据
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    //由于获取data数据可能为多个数据的拼接或是不完整 先加入cachedata中再解析
    [self analyticalData:data];
    
    //处理完一段数据后,继续读取数据
    [self.socketManager socketBeginReadData];
    
    
}

//协议头长度
static NSInteger const headerLength = 17;

#pragma mark 解析数据
- (void)analyticalData:(NSData *)data
{
    //将接收到的数据保存到缓存数据中
    [self.cacheData appendData:data];
    
    //协议: 消息长度(int) | 标记位(byte) | 请求消息ID(int) | 响应消息ID(int) | 协议号(int) | 消息体(消息内容Json)
    //协议占12位，所以至少大于17位才开始解析 等于17一般为一个心跳包

    while (_cacheData.length >= headerLength)
    {
        //取出数据包boby数据长度+数据包头部长度,计算出总个包的长度
        NSData *bobyLength = [_cacheData subdataWithRange:NSMakeRange(0, 4)];
        
        int dataLenInt = CFSwapInt32BigToHost(*(int*)([bobyLength bytes]));
        
        NSInteger lengthInteger = 0;
        lengthInteger = (NSInteger)dataLenInt;
        NSInteger complateDataLength = lengthInteger + 4;//算出一个包完整的长度(内容长度＋头长度)
        NSLog(@"data = %ld  ----   length = %d  ",data.length,dataLenInt);
        
        
        if (_cacheData.length < complateDataLength) { //如果缓存中的数据长度小于包头长度 则继续拼接
            
            [self.socketManager socketBeginReadData];//socket读取数据
            break;
            
        }else {
            
            //截取完整数据包
            NSData *dataOne = [_cacheData subdataWithRange:NSMakeRange(0, complateDataLength)];
            
            [self handleTcpResponseData:dataOne];//处理包数据
            
            //读完数据清楚缓存
            [_cacheData replaceBytesInRange:NSMakeRange(0, complateDataLength) withBytes:nil length:0];
            
            
        }
    }

}

//处理完整的数据包
- (void)handleTcpResponseData:(NSData *)responseData
{
    NSData *head = [responseData subdataWithRange:NSMakeRange(0, headerLength)];//取得头部数据
    
    //head中定义前4个字节为消息协议
    NSData *msgLengthData = [head subdataWithRange:NSMakeRange(0, 4)];
    //先要转换大小端
//    NSData *reverTypeDate = [YMSocketUtils dataWithReverse:typeData];
//
//    NSInteger typeLength = [YMSocketUtils valueFromBytes:reverTypeDate];
    int msgLength = CFSwapInt32BigToHost(*(int*)([msgLengthData bytes])) - 13;
    
    NSLog(@"消息长度是 %zd",msgLength);
    
    //从head中取出和服务器协商的pid
    NSData *signData = [head subdataWithRange:NSMakeRange(4, 1)];
    
    int signLength = CFSwapInt32BigToHost(*(int*)([signData bytes]));
    
    NSLog(@"标记位是 %zd",signLength);
    
    NSData *requestData = [head subdataWithRange:NSMakeRange(5, 4)];
    
    int requestID = CFSwapInt32BigToHost(*(int*)([requestData bytes]));
    
    NSLog(@"请求ID是 %zd",requestID);
    
    NSData *responData = [head subdataWithRange:NSMakeRange(9, 4)];
    
    int responseID = CFSwapInt32BigToHost(*(int*)([responData bytes]));
    
    NSLog(@"响应ID是 %zd",responseID);
    
    NSData *dealData = [head subdataWithRange:NSMakeRange(13, 4)];
    
    int dealID = CFSwapInt32BigToHost(*(int*)([dealData bytes]));
    
    NSLog(@"协议ID是 %zd",dealID);
    
    //取出boday
    NSData *bodyData = [responseData subdataWithRange:NSMakeRange(headerLength, msgLength)];
    
    NSString * bobyText = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
    
    NSLog(@"内容是 %@",bobyText);
    
    if (dealID == GACRequestType_GetBeat) //表示接受到系统消息包
    {
        //重置心跳次数
        [self.socketManager resetBeatCount];
        
        return;
    }
    
    //判断消息响应ID是否需要响应
    if (responseID != 0 && [self.requestsMap.allKeys containsObject:[NSString stringWithFormat:@"%zd",responseID]]) {
        
        
        NSError *error = [GACErrorManager errorWithErrorCode:1];
        
        SocketDidReadBlock didReadBlock = self.requestsMap[[NSString stringWithFormat:@"%zd",responseID]];
        
        //data反序列化
        NSDictionary *resultDict = [bodyData mj_JSONObject];
        
        if ([resultDict.allKeys containsObject:@"result"] && [resultDict[@"result"] isEqualToString:@"success"])
        {
            if (didReadBlock) {
                didReadBlock(nil,resultDict);
            }
            
            //block回调完成,从记录中移除
            [self.requestsMap removeObjectForKey:[NSString stringWithFormat:@"%zd",responseID]];
            
        }else{
            if (didReadBlock) {
                didReadBlock(error,nil);
            }
//            [SVProgressHUD showInfoWithStatus:@"请求失败,请稍后再试~"];
        }
 
    }else
    {
        //其他消息,响应代理
        if ([self.socketDelegate respondsToSelector:@selector(socketReadedData:forType:)]) {
            [self.socketDelegate socketReadedData:bobyText forType:dealID];
        }
        
    }
    
}


#pragma mark-- private method
- (NSString *)createRequestID {
    NSInteger timeInterval = [NSDate date].timeIntervalSince1970 * 1000000;
    NSString *randomRequestID = [NSString stringWithFormat:@"%ld%d", timeInterval, arc4random() % 100000];
    return randomRequestID;
}

- (void)differenceOfLocalTimeAndServerTime:(long long)serverTime {
    if (serverTime == 0) {
        self.interval = 0;
        return;
    }
    
    NSTimeInterval localTimeInterval = [NSDate date].timeIntervalSince1970 * 1000;
    self.interval = serverTime - localTimeInterval;
}

- (long long)simulateServerCreateTime {
    NSTimeInterval localTimeInterval = [NSDate date].timeIntervalSince1970 * 1000;
    localTimeInterval += 3600 * 8;
    localTimeInterval += self.interval;
    return localTimeInterval;
}

- (void)didConnectionAuthAppraisal {
    if ([self.socketDelegate respondsToSelector:@selector(socketDidConnect)]) {
        [self.socketDelegate socketDidConnect];
    }
    
//    GACSocketModel *socketModel = [[GACSocketModel alloc] init];
//    socketModel.version = PROTOCOL_VERSION;
//    socketModel.reqType = GACRequestType_Beat;
//    socketModel.user_mid = 0;
//    
//    NSString *beatBody = [NSString stringWithFormat:@"%@\r\n", [socketModel toJSONString]];
//    [self.socketManager socketDidConnectBeginSendBeat:beatBody];
}

#pragma mark-- 使用AFN的网络监听
- (void)startMonitoringNetwork {
    AFNetworkReachabilityManager *networkManager = [AFNetworkReachabilityManager sharedManager];
    [networkManager startMonitoring];
    __weak __typeof(&*self) weakSelf = self;
    [networkManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                if (weakSelf.socketManager.connectStatus != -1) {
                    [self disconnectSocket];
                }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                if (weakSelf.socketManager.connectStatus == -1) {
                    [self createSocketWithToken:[GCKeyChainManager sharedInstance].token
                                        channel:self.socketAuthAppraisalChannel];
                }
                break;
            default:
                break;
        }
    }];
}

#pragma mark - getter
- (GACSocketConnectStatus)connectStatus {
    return self.socketManager.connectStatus;
}

#pragma mark-- 占用多少的字节通过类型来辨别
- (NSData *)RequestSpliceAttribute:(id)obj{
    
    if (obj == nil) {
        NSLog(@"传输的协议对象为空");
        return nil;
    }
    
    NSMutableData *codeData = [NSMutableData data];
    
    unsigned int numIvars; //成员变量个数
    
    objc_property_t *propertys = class_copyPropertyList(NSClassFromString([NSString stringWithUTF8String:object_getClassName(obj)]), &numIvars);
    
    NSString *type = nil;
    NSString *name = nil;
    
    for (int i = 0; i < numIvars; i++) {
        objc_property_t thisProperty = propertys[i];
        
        name = [NSString stringWithUTF8String:property_getName(thisProperty)];
        //        NSLog(@"%d.name:%@",i,name);
        type = [[[NSString stringWithUTF8String:property_getAttributes(thisProperty)] componentsSeparatedByString:@","] objectAtIndex:0]; //获取成员变量的数据类型
        //        NSLog(@"%d.type:%@",i,type);
        
        id propertyValue = [obj valueForKey:[(NSString *)name substringFromIndex:0]];
        //        NSLog(@"%d.propertyValue:%@",i,propertyValue);
        //
        //        NSLog(@"\n");
        
        if ([type isEqualToString:TYPE_UINT8]) {
            uint8_t i = [propertyValue charValue];// 8位
            [codeData appendData:[YMSocketUtils byteFromUInt8:i]];
        }else if([type isEqualToString:TYPE_UINT16]){
            uint16_t i = [propertyValue shortValue];// 16位
            [codeData appendData:[YMSocketUtils bytesFromUInt16:i]];
        }else if([type isEqualToString:TYPE_UINT32]){
            uint32_t i = [propertyValue intValue];// 32位
            [codeData appendData:[YMSocketUtils bytesFromUInt32:i]];
        }else if([type isEqualToString:TYPE_UINT64]){
            uint64_t i = [propertyValue longLongValue];// 64位
            [codeData appendData:[YMSocketUtils bytesFromUInt64:i]];
        }else if([type isEqualToString:TYPE_STRING]){
            NSData *data = [(NSString*)propertyValue \
                            dataUsingEncoding:NSUTF8StringEncoding];// 通过utf-8转为data
            
            // 用2个字节拼接字符串的长度拼接在字符串data之前(这我们不需要)
            //            [self.data appendData:[YMSocketUtils bytesFromUInt16:data.length]];
            // 然后拼接字符串
            [codeData appendData:data];
            
        }else {
            NSLog(@"RequestSpliceAttribute:未知类型");
            NSAssert(YES, @"RequestSpliceAttribute:未知类型");
        }
    }
    
    // hy: 记得释放C语言的结构体指针
    free(propertys);
    
    return codeData;
    
}

@end
