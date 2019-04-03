//
//  UserInfoTool.h
//  TeleStation
//
//  Created by 张小凡 on 2017/3/7.
//  Copyright © 2017年 huangbinbin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YRLoginUserModel.h"
@class YRMainListBarModel;

typedef void (^LoginCompleteBlock)();

@interface UserInfoTool : NSObject

@property (nonatomic, copy) LoginCompleteBlock completeBlock;

//单例
+ (instancetype)shareUserInfoTool;

//偏好设置保存
+ (void)setUserDefaultName:(NSString *)name andKey:(NSString *)key;

//偏好设置获取
+ (id)getUserDefaultKey:(NSString *)userKey;

//保存用户所有的基本信息
+ (void)setUserInfo:(YRLoginUserModel *)loginModel;

//保存bar条信息
+ (void)setMainListBarModel:(NSArray<YRMainListBarModel *>*)barModelArr;

//获取所有的用户基本信息
+ (YRLoginUserModel *)getUserInfo;

//获取主页bar信息
+ (NSArray<YRMainListBarModel *> *)getMainListBarModel;

//(判断是否登录,YES表示已经登录)
+ (BOOL)saveUserIsLogined;

//(退出登录)
+ (void) quitUser;

// 判断用户是否登录，未登录自动弹出登录界面，登陆成功后执行回调
+ (BOOL)checkLoginWithComplete;

@end
