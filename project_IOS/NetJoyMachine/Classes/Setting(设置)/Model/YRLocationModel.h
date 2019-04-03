//
//  YRLocationModel.h
//  NetJoyMachine
//
//  Created by ZMJ on 2017/12/6.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRBaseDataModel.h"

@interface YRLocationModel : YRBaseDataModel

@property (nonatomic, strong) NSString *ID;

@property (nonatomic, copy) NSString *locale1;

@property (nonatomic, copy) NSString *locale2;

@property (nonatomic, copy) NSString *locale3;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *userName;


@end
