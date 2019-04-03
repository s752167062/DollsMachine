//
//  NSDictionary+Encrypt.m
//  TeleStation
//
//  Created by huangbinbin on 17/3/19.
//  Copyright © 2017年 huangbinbin. All rights reserved.
//

#import "NSDictionary+Encrypt.h"
#import "NSString+SSKit.h"
#import "NSDictionary+SSKit.h"

static NSString *const MMServerPublicKey = @"yourui";

@implementation NSDictionary (Encrypt)

- (NSDictionary *)encrypt {
    
//    UInt64 randomTime = [[NSDate date] timeIntervalSince1970] * 1000;
//    NSDictionary *params = @{@"randomTime":@(randomTime),
//                             @"appVersion":[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],
//                             @"deviceName":[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"],
//                             @"deviceType":@"ios"};
//
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[self dicAppendingParams:params]];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:self];
    
    NSString *sign = [self dicURLSort];
    
    sign = [sign stringByAppendingString:MMServerPublicKey];
    sign = [[sign stringMD5Encode] lowercaseString];
    [dic setObject:sign forKey:@"sign"];
    NSLog(@"%@",dic);
    
    return dic;
}

- (NSDictionary *)dicAppendingParams:(NSDictionary *)params{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:self];
    for (NSString *key in params.allKeys) {
        [dic setObject:[params objectForKey:key] forKey:key];
    }
    return dic;
}

@end
