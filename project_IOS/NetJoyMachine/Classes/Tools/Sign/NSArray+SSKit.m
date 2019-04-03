//
//  NSArray+SSKit.m
//  SSKit
//
//  Created by Quincy Yan on 16/7/11.
//  Copyright © 2016年 SSKit. All rights reserved.
//

#import "NSArray+SSKit.h"

@implementation NSArray (SSKit)

- (id)safeObjectAtIndex:(NSUInteger)index{
    if (index < self.count){
        id object = [self objectAtIndex:index];
        if ([object isKindOfClass:[NSNull class]])
            return nil;
        return object;
    }
    return nil;
}

- (NSArray *)objReversely {
    if (self.count <= 1) {
        return self;
    }
    return [[self reverseObjectEnumerator] allObjects];
}

- (NSArray *)objSort {
    return [self sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
}

- (NSArray *)objSort:(id (^)(id))callback {
    return [self sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [callback(obj1) compare:callback(obj2)];
    }];
}

- (NSArray *)objSortReversely {
    return [[self objSort] objReversely];
}

- (NSArray *)objSortCaseInsensitive {
    return [self sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 caseInsensitiveCompare:obj2];
    }];
}

- (NSArray *)objsUnion:(NSArray *)anArray {
    NSMutableOrderedSet *set1 = [NSMutableOrderedSet orderedSetWithArray:self];
    NSMutableOrderedSet *set2 = [NSMutableOrderedSet orderedSetWithArray:anArray];
    [set1 unionOrderedSet:set2];
    return set1.array.copy;
}

- (NSArray *)objsIntersection:(NSArray *)anArray {
    NSMutableOrderedSet *set1 = [NSMutableOrderedSet orderedSetWithArray:self];
    NSMutableOrderedSet *set2 = [NSMutableOrderedSet orderedSetWithArray:anArray];
    [set1 intersectOrderedSet:set2];
    return set1.array.copy;
}

- (NSArray *)objsDifference:(NSArray *)anArray {
    NSMutableOrderedSet *set1 = [NSMutableOrderedSet orderedSetWithArray:self];
    NSMutableOrderedSet *set2 = [NSMutableOrderedSet orderedSetWithArray:anArray];
    [set1 minusOrderedSet:set2];
    return set1.array.copy;
}

- (NSArray *)objsFirst:(NSInteger)count {
    __block NSMutableArray *firsts = [[NSMutableArray alloc] init];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        *stop = !(idx < count);
        if (!(*stop)){
            [firsts addObject:obj];
        }
    }];
    return firsts;
}

- (NSArray *)objsTakeWhile:(BOOL (^)(id))callback {
    __block NSMutableArray *take = [[NSMutableArray alloc] init];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        *stop = !callback(obj);
        if (!(*stop)){
            [take addObject:obj];
        }
    }];
    return take;
}

- (NSArray *)objsUnique:(id (^)(id))callback {
    __block NSMutableDictionary *uniques = [[NSMutableDictionary alloc] init];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([uniques objectForKey:callback(obj)] == nil){
            [uniques setValue:obj forKey:callback(obj)];
        }
    }];
    return [uniques allValues];
}

- (NSArray *)unique {
    return [[self objsUnique:^id(id obj) {
        return obj;
    }] objSort];
}

- (NSArray *)objsFilter:(BOOL (^)(id, NSInteger))callback {
    __block NSMutableArray *arrays = [[NSMutableArray alloc] init];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
        if (callback(obj,idx)) {
            [arrays addObject:obj];
        }
    }];
    return arrays;
}

- (NSArray *)objsMap:(id (^)(id, NSInteger))callback {
    __block NSMutableArray *arrays = [[NSMutableArray alloc] init];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
        id result = callback(obj,idx);
        if (result != nil) {
            [arrays addObject:result];
        }
    }];
    return arrays;
}

@end
