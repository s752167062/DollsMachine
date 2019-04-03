//
//  AppDelegate.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/13.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "AppDelegate.h"
#import "YRCommonKey.h"
#import "AppDelegate+HJWholeConfig.h"
#import <Bugly/Bugly.h>
#import "ZegoManager.h"
#import "YRLoginVc.h"
#import "YRLogNetMgr.h"
#import <UMSocialCore/UMSocialCore.h>
#import "YRMainNavVc.h"
#import "MainPageVc.h"
#import <JPUSHService.h>
#import "JNetManager.h"
#import "GCDAsyncSocketCommunicationManager.h"
#import "YRSocketVc.h"
#import <AdSupport/AdSupport.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#define kDefaultChannel @"dkf"

@interface AppDelegate ()<JPUSHRegisterDelegate>

@property (nonatomic, strong) GCDAsyncSocketCommunicationManager *socketMgr;

@end

@implementation AppDelegate


#pragma mark-- App载入
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    //连接业务服务器Socket
    [self connectionToSocket];
    
    //初始化即构 SDK
    [self setupJiGouSDK];
    
    //设置全局配置
    [self setupWholeConfig];
    
    //初始化友盟
    [self setupUMApi];
    
    //初始化极光推送
    [self setupJiGuang:launchOptions];
    
    //设置窗口根控制器
    [self setupRootVc];
    
    [self.window makeKeyAndVisible];
    

    return YES;
}

#pragma mark-- 连接socket
- (void)connectionToSocket
{
    // 1. 使用默认的连接环境
    
    self.socketMgr = [GCDAsyncSocketCommunicationManager sharedInstance];
    
    [self.socketMgr createSocketWithToken:@"f14c4e6f6c89335ca5909031d1a6efa9" channel:kDefaultChannel];
}

#pragma mark-- 初始化即构API
- (void)setupJiGouSDK
{
    // 初始化 SDK
    [ZegoManager api];
    
    // 初始化 Bugly
    [Bugly startWithAppId:jgKAppKey];
}

#pragma mark-- 初始化友盟APi
- (void)setupUMApi
{
    /* 打开日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    
    //控制每次登陆是否需要重新登陆
    [UMSocialGlobal shareInstance].isClearCacheWhenGetUserInfo = NO;
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:USHARE_APPKEY];
    
    /*
     设置微信的appKey和appSecret 平台的在这里设置
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:wxKAppKey appSecret:wxKAppSecret redirectURL:@"http://mobile.umeng.com/social"];
    
    //新浪
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:wbKAppKey appSecret:wbKAppSecret redirectURL:commonRedirectURL];
    
}

#pragma mark-- 初始化极光APi
- (void)setupJiGuang:(NSDictionary *)launchOptions
{
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    //Entity:实体
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    //注册
    [JPUSHService setupWithOption:launchOptions appKey:JPushAppKey
                          channel:JPushChannel
                 apsForProduction:isJPushProduction
            advertisingIdentifier:advertisingId];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
    
    
}

#pragma mark-- 设置窗口根控制器
- (void)setupRootVc
{
    BOOL isLogin = [[UMSocialDataManager defaultManager] isAuth:UMSocialPlatformType_WechatSession];

//    if (isLogin) {
//
//        self.window.rootViewController = [[YRMainNavVc alloc] initWithRootViewController:[[MainPageVc alloc] init]];
//
////        [YRLogNetMgr getUserInfoForPlatform:UMSocialPlatformType_WechatSession andLoginVc:self.window.rootViewController andComplete:^(BOOL isSuccess) {
////
////            if (!isSuccess) {
////                [SVProgressHUD showInfoWithStatus:@"登录过期,请重新登录"];
////                [self.window.rootViewController presentViewController:[[YRLoginVc alloc]init] animated:YES completion:nil];
////            }else{
////                [SVProgressHUD showInfoWithStatus:@"登录成功"];
////            }
////        }];
//
//    }else{
//
//        YRLoginVc *logVc = [[YRLoginVc alloc]init];
//
//        self.window.rootViewController = logVc;
//    }
    
    YRLoginVc *logVc = [[YRLoginVc alloc]init];
    
    logVc.canAutoLogin = isLogin;
    
    self.window.rootViewController = logVc;
    NSLog(@"登录:%zd",isLogin);
    
    

}



//#define __IPHONE_10_0    100000
#if __IPHONE_OS_VERSION_MAX_ALLOWED > 100000
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响。
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
        return [JNetManager application:app openURL:url];
    }
    return result;
}

#endif

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
        return [JNetManager application:application openURL:url];
    }
    return result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}



#pragma mark-- JPush的代理方法
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings
{
    
}


- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler
{
    
}

- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler
{
    
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
        
//        [rootViewController addNotificationCount];
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
//        [rootViewController addNotificationCount];
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

#pragma mark-- App将要进入非活动状态
- (void)applicationWillResignActive:(UIApplication *)application
{
   
}

#pragma mark-- 程序进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

#pragma mark-- 程序从后台重新进入前台
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

#pragma mark-- 进行进入活动状态
- (void)applicationDidBecomeActive:(UIApplication *)application
{
   
    
}

#pragma mark-- 程序将要退出结束
- (void)applicationWillTerminate:(UIApplication *)application
{
   
}


@end
