//
//  YRLogNetMgr.h
//  NetJoyMachine
//
//  Created by ZMJ on 2017/12/6.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRBasicObject.h"
#import <UMSocialCore/UMSocialCore.h>

typedef void(^MJLogResultBlock)(BOOL isSuccess);

@interface YRLogNetMgr : YRBasicObject

+ (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType andLoginVc:(UIViewController *)loginVc andComplete:(MJLogResultBlock)resultBlock;

@end
