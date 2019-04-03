//
//  YRJoyGameVc.h
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/14.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRBasicVc.h"

@class YRZegoRoomModel;
@class YRJoyListModel;
@class YRJoyPlayRoomModel;
@class ZegoUser;
@class YRZegoQueueModel;

@interface YRJoyGameVc : YRBasicVc

//@property (nonatomic, strong) YRZegoRoomModel *roomItem;

@property (nonatomic, copy) NSArray *playStreamList;

//房间数据模型
@property (nonatomic, strong) YRJoyPlayRoomModel *roomItem;




@end
