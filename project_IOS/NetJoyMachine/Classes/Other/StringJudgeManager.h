//
//  UrlJudgeManager.h
//  offlineTemplate
//
//  Created by admin on 13-4-16.
//  Copyright (c) 2013年 张美君. All rights reserved.
//



#import <Foundation/Foundation.h>

static NSString * const EmailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; // 邮箱
static NSString * const UrlRegex = @"http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?"; // url
static NSString * const MobilePhoneNumRegex = @"^1[3|4|5|8][0-9]\\d{8}$"; // 手机
static NSString * const PhoneNumRegex = @"^[0-9]{3,6}$|^[0-9]{7,8}$|^[0-9]{3}-[0-9]{8}$|^[0-9]{4}-[0-9]{7}$"; // 座机
static NSString * const ID_CardNumRegex = @"^(\\d{15}$|^\\d{18}$|^\\d{17}(\\d|X|x))$"; // 身份证
static NSString * const AllSpaceRegex = @"^\\s+$"; // 全都是空格

// ("^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$") //邮箱
// @"^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}" // 手机
// \\d{17}[[0-9],0-9xX] // 身份证

@interface StringJudgeManager : NSObject

/**
 * 方法描述: 判断字符串是否符合某种格式
 * 输入参数: 需要判断的字符串,格式要求
 * 返回值: BOOL
 * 创建人: 龚俊慧
 * 创建时间: 2013-11-27
 */
+ (BOOL)isValidateStr:(NSString *)str regexStr:(NSString *)regexStr;


#pragma mark - 判断输入
/// 电话号码判断
+ (BOOL)judgePhoneNum:(NSString *)aString;

#pragma mark-- 去掉空格
+ (NSString *)removeBlack:(NSString *)str;


@end

