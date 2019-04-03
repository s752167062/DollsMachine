//
//  AppDelegate+HJWholeConfig.m
//  JDH-Store
//
//  Created by ZMJ on 2017/9/11.
//  Copyright © 2017年 HuiJia. All rights reserved.
//

#import "AppDelegate+HJWholeConfig.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <AFNetworking/AFNetworking.h>
#import <IQKeyboardManager/IQKeyboardManager.h>

@implementation AppDelegate (HJWholeConfig)

- (void)setupWholeConfig
{
	//设置消失的时间
	[SVProgressHUD setMinimumDismissTimeInterval:0.2];
	
	[SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
	
	[SVProgressHUD setBackgroundColor:MJHexStrColor(@"#fda1a1", 1.0)];
	
	//遮罩的样式
	[SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];

	[SVProgressHUD setInfoImage:nil];

    [AFHTTPSessionManager manager].requestSerializer.timeoutInterval = 30.f;
	
	//点击键盘其他位置,收起键盘
	[IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;;

}

@end
