//
//  YRLoginVc.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/17.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRLoginVc.h"
//#import <UMSocialCore/UMSocialCore.h>
//#import "YRLoginUserModel.h"
//#import "UserInfoTool.h"
#import <SVProgressHUD.h>
#import "UIAlertView+WX.h"
#import "MainPageVc.h"
#import "YRMainNavVc.h"
//#import "UIViewController+YRUMShared.h"
#import "YRLogNetMgr.h"
#import "UserInfoTool.h"

@interface YRLoginVc ()

//UM登录模型
@property (nonatomic ,weak)UMSocialUserInfoResponse *UMSocialUserInfo;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@end

@implementation YRLoginVc



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginBtn.hidden = self.canAutoLogin;
    
    if (self.canAutoLogin) {
        [self weixinLoginBtnDidClicked:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//微信登录按钮点击
- (IBAction)weixinLoginBtnDidClicked:(id)sender
{
    //调起第三方登录
//    [self getUserInfoForPlatform:UMSocialPlatformType_WechatSession];
    ZMJWeakSelf(self);
    
    
    
    [YRLogNetMgr getUserInfoForPlatform:UMSocialPlatformType_WechatSession andLoginVc:self andComplete:^(BOOL isSuccess) {
        if (isSuccess) {
            [SVProgressHUD showInfoWithStatus:@"登录成功"];
            MJKeyWindow.rootViewController = [[YRMainNavVc alloc] initWithRootViewController:[[MainPageVc alloc] init]];
        }else{
            weakself.loginBtn.hidden = NO;
        }
        
    }];

}


//#pragma mark- (调起第三方登录)
//- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType
//{
//    //第三方登录信息上传服务器
//    ZMJWeakSelf(self);
//    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
//
//        NSString *message = nil;
//
//        if (error)
//        {
//            message = @"Get info fail";
//            UMSocialLogInfo(@"Get info fail with error %@",error);
//
//        } else
//        {
//
//            if ([result isKindOfClass:[UMSocialUserInfoResponse class]]) {
//
//                UMSocialUserInfoResponse *resp = result;
//
//                // 第三方登录数据(为空表示平台未提供)
//                // 授权数据
//                NSLog(@" uid: %@", resp.uid);
//                NSLog(@" openid: %@", resp.openid);
//                NSLog(@" accessToken: %@", resp.accessToken);
//                NSLog(@" refreshToken: %@", resp.refreshToken);
//                NSLog(@" expiration: %@", resp.expiration);
//                //平台
//                NSLog(@" expiration: %zd", resp.platformType);
//
//                // 用户数据
//                NSLog(@" name: %@", resp.name);
//                NSLog(@" iconurl: %@", resp.iconurl);
//                //性别
//                NSLog(@" gender: %@", resp.gender);
//
//                YRLoginUserModel *useItem = [[YRLoginUserModel alloc] init];
//
//                useItem.uid = resp.uid;
//                useItem.name = resp.name;
//                useItem.gender = resp.gender ? : @"保密";
//                useItem.iconurl = resp.iconurl;
//
//                //保存用户信息
//                [UserInfoTool setUserInfo:useItem];
//
//                // 第三方平台SDK原始数据
//                NSLog(@" originalResponse: %@", resp.originalResponse);
//
//                weakself.UMSocialUserInfo = resp;
//
//                //第三方登录信息上传服务器
//                [self loginInThirdParty];
//
//
//            }else{
//
//                message = @"失败";
//                UMSocialLogInfo(@"Get info fail with  unknow error");
//
//            }
//
//        }
//
//        if (message) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"授权信息"
//                                                            message:message
//                                                           delegate:nil
//                                                  cancelButtonTitle:NSLocalizedString(@"sure", @"确定")
//                                                  otherButtonTitles:nil];
//            [alert show];
//        }
//
//    }];
//
//
//}
//
////第三方登录信息上传服务器
//- (void)loginInThirdParty
//{
//
//    NSDictionary *params = @{@"platfromType":@(1),
//                                 @"openId":self.UMSocialUserInfo.openid,
//                             @"accessToken":self.UMSocialUserInfo.accessToken
//
//                                 };
//
//    ZMJWeakSelf(self);
//
//    [SVProgressHUD showWithStatus:@"登录中,请稍等~"];
//    [[GCDAsyncSocketCommunicationManager sharedInstance] socketWriteDataWithRequestType:GACRequestType_Login requestBody:params completion:^(NSError * _Nullable error, id  _Nullable data) {
//        // do something
//        if (error) {
//            NSLog(@"%@",error);
//
//            [SVProgressHUD showErrorWithStatus:@"登陆失败,请稍后再试"];
//
//            return;
//        }
//
//        NSLog(@"%@",data);
//        [SVProgressHUD dismiss];
//        //保存用户id
//        [UserInfoTool setUserDefaultName:data[@"userInfo"][@"id"] ? : @"" andKey:UserDefault_UserID];
//
//        if (!weakself.needChangeRootVc) {
//
//            MJKeyWindow.rootViewController = [[YRMainNavVc alloc] initWithRootViewController:[[MainPageVc alloc] init]];
//        }
//
//    }];
//
//}

- (IBAction)clauseBtnDidClicked:(id)sender
{
    
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

@end
