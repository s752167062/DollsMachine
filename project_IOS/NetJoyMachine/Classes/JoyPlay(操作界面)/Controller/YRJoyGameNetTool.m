//
//  YRJoyGameNetTool.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/23.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRJoyGameNetTool.h"
#import "HJNetworkManager.h"
#import "ZegoManager.h"
#import "YRZegoRoomModel.h"
#import <MJExtension.h>




@implementation YRJoyGameNetTool

//单例
static YRJoyGameNetTool * _instance;

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
        }
    });
    return _instance;
}

+ (instancetype)shareManger
{
    return  [[self alloc] init];
}


- (void)joyGame_login_RoomWithRoomId:(NSString *)roomId andComplete:(void(^)(BOOL isSucceed , ZegoUser *playUser , YRZegoQueueModel *queueModel))completeBlock
{
    //打印操作日志
    [self addLog:[NSString stringWithFormat:NSLocalizedString(@"开始登录房间，房间 ID：%@", nil), roomId]];
    
    //设置房间配置信息
    [[ZegoManager api] setRoomConfig:NO userStateUpdate:NO];
    
    [[ZegoManager api] loginRoom:roomId role:ZEGO_AUDIENCE withCompletionBlock:^(int errorCode, NSArray<ZegoStream *> *streamList) {
       
        if (errorCode == 0) {
            
            //登陆成功,增加登陆成功日志
            [self addLog:[NSString stringWithFormat:NSLocalizedString(@"登录房间成功，房间 ID：%@", nil), roomId]];
            
            if (streamList.count == 0) {
                [self addLog:NSLocalizedString(@"登录成功，房间流列表为空", nil)];
                return;
            }
            
            //推流用户
            ZegoUser *playUser = nil;
            
            //从流附加信息获取房间总人数和当前排队人数
            YRZegoQueueModel *queueModel = nil;
            
            for (ZegoStream *stream in streamList)
            {
                
              playUser = [[ZegoUser alloc] init];
              playUser.userId = stream.userID;
              playUser.userName = stream.userName;

                if (stream.extraInfo.length)
                {
                    
                    //Josn转字典
                    NSDictionary *dict = [self decodeJSONToDictionary:stream.extraInfo];
                    
                    if (dict)
                    {
                        //队列模型
                        queueModel = [YRZegoQueueModel mj_objectWithKeyValues:dict];
                      
                    }
                    
                }
                
            }
            //回调结果
            completeBlock(YES,playUser,queueModel);
            
        }else{
            
            //房间登陆失败
            [self addLog: [NSString stringWithFormat:NSLocalizedString(@"登录房间失败，房间 ID：%@，错误码：%d", nil),roomId, errorCode]];
            
            //回调结果
            completeBlock(NO,nil,nil);
            
        }
        
    }];
    
    
}


- (void)addLog:(NSString *)logString
{
    [self addLogString:logString];
    
#ifdef DEBUG
    NSLog(@"%@", logString);
#endif
}

- (void)addLogString:(NSString *)logString
{
    if (logString.length != 0)
    {
        NSString *totalString = [NSString stringWithFormat:@"%@: %@", [self getCurrentTime], logString];
        [self.logArray insertObject:totalString atIndex:0];

        //发送登陆成功消息
        [[NSNotificationCenter defaultCenter] postNotificationName:@"logUpdateNotification" object:self userInfo:nil];
    }
}

//获取当前时间
- (NSString *)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"[HH:mm:ss:SSS]";
    return [formatter stringFromDate:[NSDate date]];
}

#pragma mark-- 序列化方法
- (NSDictionary *)decodeJSONToDictionary:(NSString *)json
{
    if (json == nil)
        return nil;
    
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    if (jsonData)
    {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        return dictionary;
    }
    
    return nil;
}

- (NSString *)encodeDictionaryToJSON:(NSDictionary *)dict {
    if (dict == nil) {
        return nil;
    }
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    
    if (jsonData) {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
    
    return nil;
}


@end
