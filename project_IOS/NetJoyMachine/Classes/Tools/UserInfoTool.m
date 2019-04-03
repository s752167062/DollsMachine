//
//  UserInfoTool.m
//  TeleStation
//
//  Created by 张小凡 on 2017/3/7.
//  Copyright © 2017年 huangbinbin. All rights reserved.
//

#import "UserInfoTool.h"
#import <MJExtension.h>
#import <UMSocialCore/UMSocialCore.h>
#import "AppDelegate.h"
#import "JPUSHService.h"
#import "YRMainListBarModel.h"

@interface UserInfoTool()<NSCopying>

@end

@implementation UserInfoTool

static UserInfoTool *_instance = nil;

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    
    return _instance;

}

+ (instancetype)shareUserInfoTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (id)copyWithZone:(nullable NSZone *)zone
{
    return _instance;
    
}

#pragma mark- (偏好设置保存)
+ (void)setUserDefaultName:(id)name andKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:key];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

#pragma mark- (偏好设置获取)
+ (id)getUserDefaultKey:(NSString *)userKey
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:userKey] ? : @"";
}

#pragma mark- (保存用户所有的基本信息)
+ (void)setUserInfo:(YRLoginUserModel *)loginModel
{
    NSDictionary *dict = loginModel.mj_keyValues;
    
    for (NSString *key in dict.allKeys) {
        
        if ([dict[key]  isEqual: [NSNull null]] || dict[key] == nil)
        {
            [dict setValue:@"" forKey:key];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:UserDefault_AllUserInfoKey];
}

//保存bar条信息
+ (void)setMainListBarModel:(NSArray<YRMainListBarModel *>*)barModelArr
{
    NSArray *dictArr = [YRMainListBarModel mj_keyValuesArrayWithObjectArray:barModelArr];
    
    [[NSUserDefaults standardUserDefaults] setObject:dictArr forKey:MainPage_ListBarKey];
}



#pragma mark- (获取用户基本信息)
+ (YRLoginUserModel *)getUserInfo
{
    NSDictionary *infoDict = [[NSUserDefaults standardUserDefaults] objectForKey:UserDefault_AllUserInfoKey];
    
    //转模型
    YRLoginUserModel *logItem = [YRLoginUserModel mj_objectWithKeyValues:infoDict];
    
    return logItem;

}

//获取所有的用户基本信息
+ (NSArray<YRMainListBarModel *> *)getMainListBarModel
{
    NSArray *infoArr = [[NSUserDefaults standardUserDefaults] objectForKey:MainPage_ListBarKey];
    
    //转模型
    NSArray *barItemArr = [YRMainListBarModel mj_objectArrayWithKeyValuesArray:infoArr];
    
    return barItemArr;
}

#pragma mark- (判断是否登录 yes表示已经登录)
+ (BOOL)saveUserIsLogined
{
    return [UserInfoTool getUserInfo] == nil ? NO : YES;
}

#pragma mark - (判断用户是否登录，未登录自动弹出登录界面，登陆成功后执行回调)

+ (BOOL)checkLoginWithComplete
{
    return [UserInfoTool checkLoginWithCompleteBlock:nil];
}

+ (BOOL)checkLoginWithCompleteBlock:(LoginCompleteBlock)completeBlock
{
//    if ([UserInfoTool getUserInfo] == nil) {
//        [SharedAppDelegate showLoginViewController:completeBlock];
//    }
    return [UserInfoTool getUserInfo] == nil ? NO : YES;
}

#pragma mark- (退出登录)
+ (void) quitUser
{
    //覆盖逻辑,清空登录信息
    // 当前用户
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:UserDefault_AllUserInfoKey];
    
    //用户的密码
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:UserDefault_LoginNameKey];
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:UserDefault_UserPwdKey];
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:UserDefault_UserID];
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:UserDefault_User_Access_Token];
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:UserDefault_User_Access_Token_Time];
    
    
//    [[NSUserDefaults standardUserDefaults]removeObjectForKey:UserDefault_UserPhoneKey];
    
    //清空推送别名和标签
    [JPUSHService setTags:nil aliasInbackground:@""];
    
    //取消第三方授权登录
    
    //新浪
    [[UMSocialManager defaultManager] cancelAuthWithPlatform:UMSocialPlatformType_Sina completion:^(id result, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
    
    //微信
    [[UMSocialManager defaultManager] cancelAuthWithPlatform:UMSocialPlatformType_WechatSession completion:^(id result, NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
    //QQ
    [[UMSocialManager defaultManager] cancelAuthWithPlatform:UMSocialPlatformType_QQ completion:^(id result, NSError *error) {

        NSLog(@"%@",error);
        
    }];
    
    //清空用户信息
    [[UMSocialDataManager defaultManager] clearAllAuthorUserInfo];
    
    
}





@end
