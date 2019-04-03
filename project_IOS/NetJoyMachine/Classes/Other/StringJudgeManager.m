//
//  UrlJudgeManager.m
//  offlineTemplate
//
//  Created by admin on 13-4-16.
//  Copyright (c) 2013年 张美君. All rights reserved.
//

#import "StringJudgeManager.h"

@implementation StringJudgeManager

#pragma mark (BOOL)利用谓词验证

+ (BOOL)isValidateStr:(NSString *)str regexStr:(NSString *)regexStr
{
    if (!str || 0 == str.length || !regexStr || 0 == regexStr) return NO;
    
    NSPredicate *strPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexStr];
    return [strPredicate evaluateWithObject:str];
}

#pragma mark - 判断输入
/// 电话号码判断
+ (BOOL)judgePhoneNum:(NSString *)aString
{
    BOOL isPhone = NO;
    
    if (aString && 0 < aString.length && [StringJudgeManager isValidateStr:aString regexStr:MobilePhoneNumRegex])
    {
        isPhone = YES;
    }
    
    return isPhone;
}

#pragma mark-- 去掉空格
+ (NSString *)removeBlack:(NSString *)str
{
    NSString *lastStr = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return lastStr;
}

@end
