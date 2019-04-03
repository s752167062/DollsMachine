//
//  NSDictionary+SSKit.h
//  TeleStation
//
//  Created by huangbinbin on 17/3/19.
//  Copyright © 2017年 huangbinbin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SSKit)

/**
 转换成可变字典
 */
- (NSMutableDictionary *)dicMutable;

/**
 对字典中的键值进行‘类URL’排序
 例如: {
 a : 111,
 e : 222,
 c : 333,
 b : 444
 }
 => a=111&b=444&c=333&e=222
 */
- (NSString *)dicURLSort;

/**
 添加另外的字典的数据
 */
- (NSDictionary *)dicAppendingParams:(NSDictionary *)params;

/// 将中文utf-8编码处理进行排序
- (NSString *)dicUTF8URLSort;

@end
