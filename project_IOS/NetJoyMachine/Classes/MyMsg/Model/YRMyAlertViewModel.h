//
//  YRMyAlertViewModel.h
//  NetJoyMachine
//
//  Created by ZMJ on 2017/12/6.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRBaseDataModel.h"

@interface YRMyAlertViewModel : YRBaseDataModel

@property (nonatomic, strong) NSString *ID;

@property (nonatomic, strong) NSString *nickname;

@property (nonatomic, strong) NSString *gender;

@property (nonatomic, strong) NSString *iconUrl;

//游戏币
@property (nonatomic, strong) NSString *gameCoin;

//金币
@property (nonatomic, strong) NSString *goldCoin;


@end
