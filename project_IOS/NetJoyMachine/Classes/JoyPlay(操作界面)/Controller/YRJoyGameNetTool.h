//
//  YRJoyGameNetTool.h
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/23.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YRZegoQueueModel;
@class ZegoUser;

@interface YRJoyGameNetTool : NSObject

+ (instancetype)shareManger;

- (void)joyGame_login_RoomWithRoomId:(NSString *)roomId;

@property (nonatomic, strong) NSMutableArray *logArray;             // 操作日志

- (void)addLog:(NSString *)logString;

- (void)joyGame_login_RoomWithRoomId:(NSString *)roomId andComplete:(void(^)(BOOL isSucceed , ZegoUser *playUser , YRZegoQueueModel *queueModel))completeBlock;

- (void)addLogString:(NSString *)logString;

#pragma mark-- 序列化方法
- (NSDictionary *)decodeJSONToDictionary:(NSString *)json;

- (NSString *)encodeDictionaryToJSON:(NSDictionary *)dict;

@end
