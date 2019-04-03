//
//  YRZegoRoomModel.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/23.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRZegoRoomModel.h"
#import <MJExtension.h>

@implementation YRZegoRoomModel


+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"stream_info":@"YRZegoStreamModel"};
}

@end


@implementation YRZegoStreamModel


@end

//用户
@implementation YRZegoUserModel


/**
 *  将属性名换为其他key去字典中取值
 *
 *  @return 字典中的key是属性名，value是从字典中取值用的key
 */
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"userId":@"id",
             @"userName":@"name"
             };
}


@end

//房间队列模型
@implementation YRZegoQueueModel



@end


