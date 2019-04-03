//
//  YRZegoRoomModel.h
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/23.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRBaseDataModel.h"


#pragma mark-- 房间模型
@interface YRZegoRoomModel : YRBaseDataModel

@property (nonatomic, copy) NSString *room_id;

@property (nonatomic, copy) NSString *anchor_id_name;

@property (nonatomic, copy) NSString *anchor_nick_name;

//房间名字
@property (nonatomic, copy) NSString *room_name;

//流信息
@property (nonatomic, strong) NSMutableArray *stream_info;   // stream_id 列表

@end

#pragma mark-- 流模型
@interface YRZegoStreamModel : YRBaseDataModel

@property (nonatomic, copy) NSString *stream_id;

@end


#pragma mark-- 用户
@interface YRZegoUserModel : YRBaseDataModel

/** 用户 Id */
@property (nonatomic, copy) NSString *userId;
/** 用户名 */
@property (nonatomic, copy) NSString *userName;

@end

#pragma mark-- 队列模型
@interface YRZegoQueueModel : YRBaseDataModel

/** 排队人数 Id */
@property (nonatomic, assign) NSInteger queue_number;

/** 房间总人数 */
@property (nonatomic, assign) NSInteger total;

//当前正在上机的用户
@property (nonatomic, strong) YRZegoUserModel *player;

@end


