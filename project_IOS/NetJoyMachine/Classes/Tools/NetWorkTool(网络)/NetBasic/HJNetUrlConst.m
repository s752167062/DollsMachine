//
//  HJNetUrlConst.m
//  JDH-Store
//
//  Created by ZMJ on 2017/10/31.
//  Copyright © 2017年 HuiJia. All rights reserved.
//

#import "HJNetUrlConst.h"

@implementation HJNetUrlConst

+ (NSString *)verifyRequestNameSpace:(NSString *)urlStr
{
	
	if (urlStr && 0 != urlStr.length)
	{
		if ([urlStr hasPrefix:@"/"])
		{
			return urlStr;
		}
		else
		{
			return [NSString stringWithFormat:@"/%@",urlStr];
		}
	}
	
	return nil;
}

+ (NSString *)getRequestUrlByrequestUrlStr:(NSString *)requestUrlStr
{
	
	if (requestUrlStr && 0 != requestUrlStr.length)
		return [kApiPrefix stringByAppendingFormat:@"/%@",[HJNetUrlConst verifyRequestNameSpace:requestUrlStr]];
	else
	return nil;
	
}




@end


//注意服务器基础地址最后不用加'/'
#if DevelopSever
/** 接口前缀-开发服务器*/
NSString *const kApiPrefix = @"接口服务器的请求前缀 例: http://192.168.10.10:8080";
#elif TestSever
/** 接口前缀-测试服务器*/
NSString *const kApiPrefix = @"https://www.baidu.com";
#elif ProductSever
/** 接口前缀-生产服务器*/
NSString *const kApiPrefix = @"https://www.baidu.com";
#endif


//注意具体地址前面最好加'/',虽然已经做好了对应的判断
/** 登录*/
NSString *const kLogin = @"/login";
/** 平台会员退出*/
NSString *const kExit = @"/exit";




