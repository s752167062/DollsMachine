//
//  NSString+SSKit.h
//  SSKit
//
//  Created by Quincy Yan on 16/7/11.
//  Copyright © 2016年 SSKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (SSKit)

- (CGSize)stringSizeWithFont:(NSUInteger)font maxSize:(CGSize)maxSize;

- (BOOL)stringContains:(NSString *)string;

- (NSString *)stringClearWhiteSpace;
- (NSString *)stringClearWhiteSpaceWithEmptyLine;

/**
 获取一个随机的字符串
 */
- (NSString *)stringRandomly;

- (NSDictionary *)stringConvertToDictionary;

- (NSString *)stringMD5Encode;
- (NSData *)stringHMACSHA1Encode:(NSString *)key;
- (NSString *)stringSHA1Encode;
- (NSString *)stringSHA224Encode;
- (NSString *)stringSHA256Encode;
- (NSString *)stringSHA384Encode;
- (NSString *)stringSHA512Encode;

/**
 比较版本大小
 比较'version2' 是否大于 'version1'
 位数不同,取两者之间的最小值
 例: 1.0.0 比较 1.0.1
 */
+ (BOOL)stringVersionCompare:(NSString *)version1 alsoVersion:(NSString *)version2;

- (BOOL)stringIsMarkdown;
- (BOOL)isExist;

@end
