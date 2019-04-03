//
//  NSDictionary+SSKit.m
//  TeleStation
//
//  Created by huangbinbin on 17/3/19.
//  Copyright © 2017年 huangbinbin. All rights reserved.
//

#import "NSDictionary+SSKit.h"
#import "NSArray+SSKit.h"

@implementation NSDictionary (SSKit)

- (NSMutableDictionary *)dicMutable {
    return [[NSMutableDictionary alloc] initWithDictionary:self];
}

- (NSString *)dicURLSort {
    if (self.allKeys == 0) {
        return @"";
    }
    
    NSString *str = @"";
    for (NSString *key in [self.allKeys objSort]) {
        if ([[self objectForKey:key] isKindOfClass:[NSString class]]) {
            if ([[self objectForKey:key] isEqualToString:@""]) {
                continue;
            }
        }
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@%@",key,[self objectForKey:key]]];
    }
    return [str substringToIndex:str.length];
}

- (NSDictionary *)dicAppendingParams:(NSDictionary *)params{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:self];
    for (NSString *key in params.allKeys) {
        [dic setObject:[params objectForKey:key] forKey:key];
    }
    return dic;
}

- (NSString *)dicUTF8URLSort
{
    if (self.allKeys == 0) {
        return @"";
    }
    
    NSString *str = @"";
    for (NSString *key in [self.allKeys objSort]) {
        NSString *value = [self objectForKey:key];
        if ([[self objectForKey:key] isKindOfClass:[NSString class]]) {
            if ([[self objectForKey:key] isEqualToString:@""]) {
                continue;
            }
            value = [[self objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",key,value]];
    }
    return [str substringToIndex:str.length - 1];
}

@end

