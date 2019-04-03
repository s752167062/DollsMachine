//
//  YRWXApiRequestMgr.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/26.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRWXApiRequestMgr.h"
#import <WXApi.h>
#import "YRWXApiManager.h"

@implementation YRWXApiRequestMgr


+ (BOOL)sendAuthRequestScope:(NSString *)scope
                       State:(NSString *)state
                      OpenID:(NSString *)openID
            InViewController:(UIViewController *)viewController {
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = scope; // @"post_timeline,sns"
    req.state = state;
    req.openID = openID;
    
    return [WXApi sendAuthReq:req
               viewController:viewController
                     delegate:[YRWXApiManager sharedManager]];
}


@end
