//
//  NSArray+SSKit.h
//  SSKit
//
//  Created by Quincy Yan on 16/7/11.
//  Copyright © 2016年 SSKit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (SSKit)

- (id)safeObjectAtIndex:(NSUInteger)index;

/**
 根据元素依次倒序输出
 */
- (NSArray *)objReversely;

/**
 排序
 大小写敏感
 */
- (NSArray *)objSort;
- (NSArray *)objSort:(id(^)(id obj))callback;
- (NSArray *)objSortReversely;

/**
 排序
 大小写不敏感
 */
- (NSArray *)objSortCaseInsensitive;

/**
 集合
 */
- (NSArray *)objsUnion:(NSArray *)anArray;
- (NSArray *)objsIntersection:(NSArray *)anArray;
- (NSArray *)objsDifference:(NSArray *)anArray;

/**
 返回前'count'个数据
 */
- (NSArray *)objsFirst:(NSInteger)count;

/**
 根据条件取数据
 直到返回‘NO’
 */
- (NSArray *)objsTakeWhile:(BOOL(^)(id obj))callback;

/**
 去除相同的元素,并获取一个唯一的数据数据
 */
- (NSArray *)unique;

/**
 根据条件返回值
 */
- (NSArray *)objsFilter:(BOOL(^)(id obj, NSInteger index))callback;
- (NSArray *)objsMap:(id(^)(id obj, NSInteger index))callback;

@end
