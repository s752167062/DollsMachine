//
//  YRLogNetMgr.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/12/6.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRLogNetMgr.h"

#import "YRLoginUserModel.h"
#import "UserInfoTool.h"
#import <SVProgressHUD.h>



@implementation YRLogNetMgr



#pragma mark- (调起第三方登录)
+ (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType andLoginVc:(UIViewController *)loginVc andComplete:(MJLogResultBlock)resultBlock
{
    [SVProgressHUD showWithStatus:@"请求登录中"];
    //第三方登录信息上传服务器
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:loginVc completion:^(id result, NSError *error) {
        
        NSString *message = nil;
        
        if (error)
        {
            message = @"Get info fail";
            UMSocialLogInfo(@"Get info fail with error %@",error);
            [SVProgressHUD showErrorWithStatus:@"登录错误,请稍后再试"];
            resultBlock(NO);
            
        } else
        {
            
            if ([result isKindOfClass:[UMSocialUserInfoResponse class]]) {
                
                UMSocialUserInfoResponse *resp = result;
                
                // 第三方登录数据(为空表示平台未提供)
                // 授权数据
                NSLog(@" uid: %@", resp.uid);
                NSLog(@" openid: %@", resp.openid);
                NSLog(@" accessToken: %@", resp.accessToken);
                NSLog(@" refreshToken: %@", resp.refreshToken);
                NSLog(@" expiration: %@", resp.expiration);
                //平台
                NSLog(@" expiration: %zd", resp.platformType);
                
                // 用户数据
                NSLog(@" name: %@", resp.name);
                NSLog(@" iconurl: %@", resp.iconurl);
                //性别
                NSLog(@" gender: %@", resp.gender);
                
                YRLoginUserModel *useItem = [[YRLoginUserModel alloc] init];
                
                useItem.uid = resp.uid;
                useItem.name = resp.name;
                useItem.gender = resp.gender ? : @"保密";
                useItem.iconurl = resp.iconurl;
                
                //保存用户信息
                [UserInfoTool setUserInfo:useItem];
                
                // 第三方平台SDK原始数据
                NSLog(@" originalResponse: %@", resp.originalResponse);

                //第三方登录信息上传服务器
                [YRLogNetMgr loginInThirdPartyOpenId:resp.openid andAccessToken:resp.accessToken andComplete:resultBlock];
                
                
            }else{
                
                message = @"失败";
                UMSocialLogInfo(@"Get info fail with  unknow error");
                
            }
            
        }
        
        if (message) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"授权信息"
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"sure", @"确定")
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
    }];
    
    
}

//第三方登录信息上传服务器
+ (void)loginInThirdPartyOpenId:(NSString *)openId andAccessToken:(NSString *)accessToken andComplete:(MJLogResultBlock)resultBlock
{
    NSString *userToken = [UserInfoTool getUserDefaultKey:UserDefault_User_Access_Token];
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    
    [paraDict setValue:@(1) forKey:@"platfromType"];
    
    [paraDict setValue:openId ? : @"" forKey:@"openId"];
    
    [paraDict setValue:accessToken ? : @"" forKey:@"accessToken"];
    
    if (userToken && userToken.length > 0) {
        [paraDict setValue:userToken ? : @"" forKey:@"clientToken"];
    }

    
    NSLog(@"%@",paraDict);
    [[GCDAsyncSocketCommunicationManager sharedInstance] socketWriteDataWithRequestType:GACRequestType_Login requestBody:paraDict completion:^(NSError * _Nullable error, id  _Nullable data) {
        // do something
        
        if (error) {
            NSLog(@"%@",error);
            
            [SVProgressHUD showErrorWithStatus:@"登陆失败,请稍后再试"];
            
            resultBlock(NO);
            
            return;
        }
        
        NSLog(@"%@",data);

        //保存用户id
        [UserInfoTool setUserDefaultName:data[@"userInfo"][@"id"] ? : @"" andKey:UserDefault_UserID];
        
        //保存accessToken
        [UserInfoTool setUserDefaultName:data[@"token"] ? : @"" andKey:UserDefault_User_Access_Token];
        
        //过期时间
        [UserInfoTool setUserDefaultName:data[@"expireTime"] ? : @"" andKey:UserDefault_User_Access_Token_Time];
        
        if (resultBlock) {
            
            resultBlock(YES);
        }
        
        
    }];
    
}


@end
