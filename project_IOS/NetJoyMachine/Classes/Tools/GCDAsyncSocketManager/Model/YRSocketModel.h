//
//  YRSocketModel.h
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/29.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import <Foundation/Foundation.h>

//协议: 消息长度(int) | 标记位(byte) | 请求消息ID(int) | 响应消息ID(int) | 协议号(int) | 消息体(消息内容Json)

@interface YRSocketModel : NSObject

//4个字节 消息长度
@property (nonatomic, assign) uint32_t contentLength;

//标记位(byte)用来预留做加密
@property (nonatomic, assign) uint8_t byteId;

//消息请求ID 用来做请求同步
@property (nonatomic, assign) uint32_t requestId;

//相应ID 用来做请求同步
@property (nonatomic, assign) uint32_t responseId;

//4个字节 协议类型
@property (nonatomic, assign) uint32_t typeId;

//消息内容
@property (nonatomic, strong) NSString *bobyMsg;


@end
