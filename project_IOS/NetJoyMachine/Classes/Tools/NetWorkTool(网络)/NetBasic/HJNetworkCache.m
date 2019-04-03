//
//  HJNetworkCache.m
//  JDH-Store
//
//  Created by ZMJ on 2017/10/31.
//  Copyright © 2017年 HuiJia. All rights reserved.
//

#import "HJNetworkCache.h"
#import <YYCache/YYCache.h>

static NSString *const kMJNetworkResponseCache = @"kMJNetworkResponseCache";

@implementation HJNetworkCache

static YYCache *_dataCache;

#pragma mark-- 初始化(是否创建新对象交给YYCache)
+ (void)initialize {
	_dataCache = [YYCache cacheWithName:kMJNetworkResponseCache];
}

//异步缓存网络数据
+ (void)setHttpCache:(id)httpData URL:(NSString *)URL parameters:(id)parameters
{
	NSString *cacheKey = [self cacheKeyWithURL:URL parameters:parameters];
	
	//异步缓存,不会阻塞主线程
	[_dataCache setObject:httpData forKey:cacheKey withBlock:nil];
	
}

#pragma mark-- 同步取出缓存数据
+ (id)httpCacheForURL:(NSString *)URL parameters:(NSDictionary *)parameters {
	NSString *cacheKey = [self cacheKeyWithURL:URL parameters:parameters];
	return [_dataCache objectForKey:cacheKey];
}

/// 获取网络缓存的总大小 bytes(字节)
+ (NSInteger)getAllHttpCacheSize {
	return [_dataCache.diskCache totalCost];
}

/// 删除所有网络缓存
+ (void)removeAllHttpCache {
	[_dataCache.diskCache removeAllObjects];
}



#pragma mark-- 将url和参数转换为保存的key字符串
+ (NSString *)cacheKeyWithURL:(NSString *)URL parameters:(NSDictionary *)parameters {
	if(!parameters || parameters.count == 0){return URL;};
	// 将参数字典转换成字符串
	NSData *stringData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
	NSString *paraString = [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];
	NSString *cacheKey = [NSString stringWithFormat:@"%@%@",URL,paraString];
	
	return [NSString stringWithFormat:@"%ld",cacheKey.hash];
}


@end
