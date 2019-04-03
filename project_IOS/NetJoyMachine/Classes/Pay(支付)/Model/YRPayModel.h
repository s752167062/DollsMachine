//
//  YRPayModel.h
//  NetJoyMachine
//
//  Created by ZMJ on 2017/12/3.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRBaseDataModel.h"

@interface YRPayModel : YRBaseDataModel

@property(nonatomic , copy)NSString *userId;

@property(nonatomic , copy)NSString *isPhone;

@property(nonatomic , copy)NSString *userIp;



@property(nonatomic , copy)NSString *cardId;

//必填项
@property(nonatomic , copy)NSString *goodsId;

@property(nonatomic , copy)NSString *payType;

@property(nonatomic , copy)NSString *goodsNum;




@end
