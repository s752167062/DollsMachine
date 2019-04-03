//
//  YRJoyPlayRoomModel.h
//  NetJoyMachine
//
//  Created by ZMJ on 2017/12/7.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRBaseDataModel.h"
@class YRJoyRoomStreamModel;

@interface YRJoyPlayRoomModel : YRBaseDataModel

//房间流列表
@property (nonatomic, copy) NSArray *streamList;

//单位
@property (nonatomic, copy) NSString *currency;

//价格
@property (nonatomic, copy) NSString *price;


@property (nonatomic, copy) NSString *type;

//房间号
@property (nonatomic, copy) NSString *roomid;

//名字
@property (nonatomic, copy) NSString *name;

//描述
@property (nonatomic, strong) NSString *desc;

//娃娃图
@property (nonatomic, strong) NSString *icon;

@end

@interface YRJoyRoomStreamModel : YRBaseDataModel

@property (nonatomic, copy) NSString *streamUrl;

@property (nonatomic, copy) NSString *streamId;


@end
