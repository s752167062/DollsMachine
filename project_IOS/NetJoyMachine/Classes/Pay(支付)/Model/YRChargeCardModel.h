//
//  YRChargeCardModel.h
//  NetJoyMachine
//
//  Created by ZMJ on 2017/12/7.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRBaseDataModel.h"

@interface YRChargeCardModel : YRBaseDataModel

//游戏币数量
@property (nonatomic, copy) NSString *gameCoin;


@property (nonatomic, strong) NSString *ID;

//游戏币图片
@property (nonatomic, strong) NSString *icon;

//游戏币价格
@property (nonatomic, copy) NSString *price;

//游戏币价格
@property (nonatomic, copy) NSString *name;


@end
