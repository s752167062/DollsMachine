//
//  FIMCommunicationManager.h
//  FlashIMiOSDemo
//
//  Created by Broccoli on 16/4/11.
//  Copyright © 2016年 宫城. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GACConnectConfig.h"

/**
 *  业务类型
 */
typedef NS_ENUM(NSInteger, GACRequestType) {
    GACRequestType_SendBeat = 1000,//发送心跳
    GACRequestType_GetBeat = 1002,//接收心跳
    GACRequestType_Login = 1004,//登陆请求
    GACRequestType_ContentBar = 1010,//主页segmentBar条
    GACRequestType_AdvertisingBar = 1008,//主页广告条
    GACRequestType_SendPersonageMsg = 1033,//请求个人信息
    GACRequestType_GetPersonageMsg = 1034,//收到个人信息
    GACRequestType_GetReceivingAdv = 1014,//获取收货地址
    GACRequestType_SendUser_Token = 1041,//发送用户重连token
    GACRequestType_SendMainPage_JoyList = 1012,//获取主页娃娃列表
    GACRequestType_SendRecharge_List = 1020,//发送收货地址
    GACRequestType_GetRecharge_List = 1021,//收到收货地址
    GACRequestType_GetRequest_OrderQueue = 1036,//发送排队请求
    GACRequestType_GetRequest_DeductionDFee = 1038,//请求开始游戏之前的扣费
};

/**
 *  socket 连接状态
 */
typedef NS_ENUM(NSInteger, GACSocketConnectStatus) {
    GACSocketConnectStatusDisconnected = -1,  // 未连接
    GACSocketConnectStatusConnecting = 0,     // 连接中
    GACSocketConnectStatusConnected = 1       // 已连接
};

typedef void (^SocketDidReadBlock)(NSError *__nullable error, id __nullable data);

@protocol GACSocketDelegate <NSObject>

@optional
/**
 *  监听到服务器发送过来的消息
 *
 *  @param data 数据
 *  @param type 类型 目前就三种情况（receive messge / kick out / default / ConnectionAuthAppraisal）
 */
- (void)socketReadedData:(nullable id)data forType:(NSInteger)type;

/**
 *  连上时
 */
- (void)socketDidConnect;

/**
 *  建连时检测到token失效
 */
- (void)connectionAuthAppraisalFailedWithErorr:(nonnull NSError *)error;

@end


//Communication: 通讯
@interface GCDAsyncSocketCommunicationManager : NSObject

// 连接状态
@property (nonatomic, assign, readonly) GACSocketConnectStatus connectStatus;

// 当前请求通道
@property (nonatomic, strong, nonnull) NSString *currentCommunicationChannel;

// socket 回调
@property (nonatomic, weak, nullable) id<GACSocketDelegate> socketDelegate;

/**
 *  获取单例
 *
 *  @return 单例对象
 */
+ (nullable GCDAsyncSocketCommunicationManager *)sharedInstance;


/**
 初始化 socket 通过自定义协议创建socket连接 切换链接 (用来管理多条连接)

 @param config 配置参数
 token         token
 channel       建连时通道
 host          主机地址
 port          端口号
 socketVersion socket通信协议版本号
 */
- (void)createSocketWithConfig:(nonnull GACConnectConfig *)config;


/**
 初始化 socket 使用默认的连接环境 更加像是最常用的连接 (而我们当前只有一条连接用这个就好)

 @param token 暂时不知
 @param channel channel:通道 通道标识
 */
- (void)createSocketWithToken:(nonnull NSString *)token channel:(nonnull NSString *)channel;

/**
 *  socket断开连接
 */
- (void)disconnectSocket;

/**
 *  向服务器发送数据
 *
 *  @param type    请求类型
 *  @param body    请求体
 */
- (void)socketWriteDataWithRequestType:(GACRequestType)type
                           requestBody:(NSDictionary *_Nullable)body
                            completion:(nullable SocketDidReadBlock)callback;

#pragma mark-- 不需要断线自动重发
- (void)noRetrySocketSendWriteDataWithRequestType:(GACRequestType)type
                           requestBody:(NSDictionary *_Nullable)body
                            completion:(nullable SocketDidReadBlock)callback;

@end
