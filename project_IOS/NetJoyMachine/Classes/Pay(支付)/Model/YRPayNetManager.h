//
//  YRPayNetManager.h
//  NetJoyMachine
//
//  Created by ZMJ on 2017/12/2.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YRPayModel.h"

typedef enum{
    
    kYRWeiXinPAYStyle = 30,
    kYRAliPayStyle = 22
    
} YRPayStyle;

typedef void (^WebRequestCompleteBlock)(NSDictionary* returnValue,BOOL hasError);

@interface YRPayNetManager : NSObject

+(YRPayNetManager *)shareInstance;

//SDK
- (void)sendWebRequestToSDKInitWithPayStyle:(YRPayStyle)payStyle paymentType:(YRPayModel *)payModel withCompleteBlock:(WebRequestCompleteBlock)block;

@end
