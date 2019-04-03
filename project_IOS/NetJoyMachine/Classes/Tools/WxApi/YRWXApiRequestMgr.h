//
//  YRWXApiRequestMgr.h
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/26.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YRWXApiRequestMgr : NSObject

//发送授权登录请求
+ (BOOL)sendAuthRequestScope:(NSString *)scope
                       State:(NSString *)state
                      OpenID:(NSString *)openID
            InViewController:(UIViewController *)viewController;

@end
