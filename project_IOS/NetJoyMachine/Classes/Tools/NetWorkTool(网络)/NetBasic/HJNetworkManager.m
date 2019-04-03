//
//  HJNetworkManager.m
//  JDH-Store
//
//  Created by ZMJ on 2017/10/31.
//  Copyright © 2017年 HuiJia. All rights reserved.
//

#import "HJNetworkManager.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"

#ifdef DEBUG
#define ZMJLog(...) printf("[%s] %s [第%d行]: %s\n", __TIME__ ,__PRETTY_FUNCTION__ ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String])
#else
#define ZMJLog(...)
#endif

#define NSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]

@implementation HJNetworkManager
// 是否已开启日志打印
static BOOL _isOpenLog;

//所有的网络请求任务
static NSMutableArray *_allSessionTask;

//AFN绘画管理者
static AFHTTPSessionManager *_sessionManager;


#pragma mark-- 懒加载
/**
 存储着所有的请求task数组
 */
+ (NSMutableArray *)allSessionTask {
	if (!_allSessionTask) {
		_allSessionTask = [[NSMutableArray alloc] init];
	}
	return _allSessionTask;
}


#pragma mark - 初始化AFHTTPSessionManager相关属性
/**
 开始监测网络状态
 */
+ (void)load {
	[[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

/**
 *  所有的HTTP请求共享一个AFHTTPSessionManager
 *  原理参考地址:http://www.jianshu.com/p/5969bbb4af9f
 每次都新建Session的操作将导致每次的网络请求都开启一个TCP的三次握手.而共享Session将会复用TCP的连接，达到加速了整个网络的请求时间效果.
 
 load和initialize方法都会在实例化对象之前调用，以main函数为分水岭，前者在main函数之前调用，后者在之后调用。这两个方法会被自动调用，不能手动调用它们。
 
 load和initialize方法都不用显示的调用父类的方法而是自动调用，即使子类没有initialize方法也会调用父类的方法，而load方法则不会调用父类。
 
 load方法通常用来进行Method Swizzle，initialize方法一般用于初始化全局变量或静态变量。
 
 load和initialize方法内部使用了锁，因此它们是线程安全的。实现时要尽可能保持简单，避免阻塞线程，不要再使用锁。
 
 */
+ (void)initialize {
	
	_sessionManager = [AFHTTPSessionManager manager];
	
	//请求过期时间
	_sessionManager.requestSerializer.timeoutInterval = 30.f;
	//响应解析格式
	_sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
	
	// 打开状态栏的等待菊花
	[AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
}

#pragma mark - 重置AFHTTPSessionManager相关属性

//利用block将sessionManager传出去,避免外部的创建烦恼
+ (void)setAFHTTPSessionManagerProperty:(void (^)(AFHTTPSessionManager *))sessionManager {
	sessionManager ? sessionManager(_sessionManager) : nil;
}

//设置解析格式
+ (void)setRequestSerializer:(MJRequestSerializer)requestSerializer {
	_sessionManager.requestSerializer = requestSerializer==MJRequestSerializerHTTP ? [AFHTTPRequestSerializer serializer] : [AFJSONRequestSerializer serializer];
}

//设置超时
+ (void)setRequestTimeoutInterval:(NSTimeInterval)time {
	_sessionManager.requestSerializer.timeoutInterval = time;
}

//设置请求头
+ (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
	[_sessionManager.requestSerializer setValue:value forHTTPHeaderField:field];
}

//设置是否需要转菊花
+ (void)openNetworkActivityIndicator:(BOOL)open {
	[[AFNetworkActivityIndicatorManager sharedManager] setEnabled:open];
}

+ (void)setSecurityPolicyWithCerPath:(NSString *)cerPath validatesDomainName:(BOOL)validatesDomainName {
	NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
	// 使用证书验证模式
	AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
	// 如果需要验证自建证书(无效证书)，需要设置为YES
	securityPolicy.allowInvalidCertificates = YES;
	// 是否需要验证域名，默认为YES;
	securityPolicy.validatesDomainName = validatesDomainName;
	securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:cerData, nil];
	
	[_sessionManager setSecurityPolicy:securityPolicy];
}



#pragma mark - GET请求无缓存

//GET请求无缓存
+ (NSURLSessionTask *)GET:(NSString *)URL
parameters:(id)parameters
success:(MJHttpRequestSuccess)success
failure:(MJHttpRequestFailed)failure {
	
	return [self GET:URL parameters:parameters responseCache:nil success:success failure:failure];
}

//GET请求自动缓存
+ (NSURLSessionTask *)GET:(NSString *)URL
parameters:(id)parameters
responseCache:(MJHttpRequestCache)responseCache
success:(MJHttpRequestSuccess)success
failure:(MJHttpRequestFailed)failure
{
	//读取缓存并且回调出去
	responseCache!=nil ? responseCache([HJNetworkCache httpCacheForURL:URL parameters:parameters]) : nil;
	
	NSURLSessionTask *sessionTask = [_sessionManager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
		
	} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		
		if (_isOpenLog) {ZMJLog(@"responseObject = %@",responseObject);}
		
		//任务完成从任务数组中移除任务
		[[self allSessionTask] removeObject:task];
		
		//数据传出去
		success ? success(responseObject) : nil;
		
		//对数据进行异步缓存(需要缓存的话)
		responseCache!=nil ? [HJNetworkCache setHttpCache:responseObject URL:URL parameters:parameters] : nil;
		
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		
		if (_isOpenLog) {ZMJLog(@"error = %@",error);}
		
		//移除请求失败的请求任务
		[[self allSessionTask] removeObject:task];
		
		failure ? failure(error) : nil;
		
	}];
	
	// 添加sessionTask到数组
	sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
	
	return sessionTask;
	
}


#pragma mark - POST请求

//POST请求无缓存
+ (NSURLSessionTask *)POST:(NSString *)URL
parameters:(id)parameters
success:(MJHttpRequestSuccess)success
failure:(MJHttpRequestFailed)failure {
	return [self POST:URL parameters:parameters responseCache:nil success:success failure:failure];
}

//POST请求自动缓存
+ (NSURLSessionTask *)POST:(NSString *)URL
parameters:(id)parameters
responseCache:(MJHttpRequestCache)responseCache
success:(MJHttpRequestSuccess)success
failure:(MJHttpRequestFailed)failure
{
	//读取缓存
	responseCache!=nil ? responseCache([HJNetworkCache httpCacheForURL:URL parameters:parameters]) : nil;
	
	NSURLSessionTask *sessionTask = [_sessionManager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
		
	} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		
		if (_isOpenLog) {ZMJLog(@"responseObject = %@",responseObject);}
		
		//移除任务
		[[self allSessionTask] removeObject:task];
		
		//回调 (曾经的我在这里把参数给搞错了)
		success ? success(responseObject) : nil;
		
		//对数据进行异步缓存
		responseCache != nil ? [HJNetworkCache setHttpCache:responseCache URL:URL parameters:parameters] : nil;
		
		
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		
		//移除任务
		
		//回调错误
		if (_isOpenLog) {ZMJLog(@"error = %@",error);}
		[[self allSessionTask] removeObject:task];
		failure ? failure(error) : nil;
	}];
	
	// 添加最新的sessionTask到数组
	sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
	
	return sessionTask;
}




#pragma mark - 上传文件
+ (NSURLSessionTask *)uploadFileWithURL:(NSString *)URL
parameters:(id)parameters
name:(NSString *)name
filePath:(NSString *)filePath
progress:(MJHttpProgress)progress
success:(MJHttpRequestSuccess)success
failure:(MJHttpRequestFailed)failure
{
	//表单上传数据
	NSURLSessionTask *sessionTask = [_sessionManager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
		
		NSError *error = nil;
		//AFN内部做了拼接上传格式操作
		[formData appendPartWithFileURL:[NSURL URLWithString:filePath] name:name error:&error];
		
		//验证拼接数据的准确性
		(failure && error) ? failure(error) : nil;
		
	} progress:^(NSProgress * _Nonnull uploadProgress) {
		
		//上传进度
		dispatch_sync(dispatch_get_main_queue(), ^{
			progress ? progress(uploadProgress) : nil;
		});
		
	} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		
		if (_isOpenLog) {ZMJLog(@"responseObject = %@",responseObject);}
		
		[[self allSessionTask] removeObject:task];
		
		success ? success(responseObject) : nil;
		
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		
		if (_isOpenLog) {ZMJLog(@"error = %@",error);}
		[[self allSessionTask] removeObject:task];
		failure ? failure(error) : nil;
		
	}];
	
	// 添加sessionTask到数组
	sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
	
	return sessionTask;
}


#pragma mark - 上传多张图片
+ (NSURLSessionTask *)uploadImagesWithURL:(NSString *)URL
parameters:(id)parameters
name:(NSString *)name
images:(NSArray<UIImage *> *)images
fileNames:(NSArray<NSString *> *)fileNames
imageScale:(CGFloat)imageScale
imageType:(NSString *)imageType
progress:(MJHttpProgress)progress
success:(MJHttpRequestSuccess)success
failure:(MJHttpRequestFailed)failure
{
	//Multipart: 多部件
	NSURLSessionTask *sessionTask = [_sessionManager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
		
		for (NSUInteger i = 0; i < images.count; i++) {
			
			// 图片经过等比压缩后得到的二进制文件
			NSData *imageData = UIImageJPEGRepresentation(images[i], imageScale ?: 1.f);
			
			// 默认图片的文件名, 若fileNames为nil就使用日期
			NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
			
			formatter.dateFormat = @"yyyyMMddHHmmss";
			
			NSString *str = [formatter stringFromDate:[NSDate date]];
			
			NSString *imageFileName = NSStringFormat(@"%@%ld.%@",str,i,imageType?:@"jpg");
			
			[formData appendPartWithFileData:imageData
										name:name
									fileName:fileNames ? NSStringFormat(@"%@.%@",fileNames[i],imageType?:@"jpg") : imageFileName
									mimeType:NSStringFormat(@"image/%@",imageType ?: @"jpg")];
		}
		
	} progress:^(NSProgress * _Nonnull uploadProgress) {
		
		//上传进度
		dispatch_sync(dispatch_get_main_queue(), ^{
			progress ? progress(uploadProgress) : nil;
		});
		
	} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		
		if (_isOpenLog) {ZMJLog(@"responseObject = %@",responseObject);}
		
		[[self allSessionTask] removeObject:task];
		
		success ? success(responseObject) : nil;
		
		
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		
		if (_isOpenLog) {ZMJLog(@"error = %@",error);}
		
		[[self allSessionTask] removeObject:task];
		
		failure ? failure(error) : nil;
	}];
	
	// 添加sessionTask到数组
	sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
	
	return sessionTask;
	
}

#pragma mark - 下载文件
+ (NSURLSessionTask *)downloadWithURL:(NSString *)URL
fileDir:(NSString *)fileDir
progress:(MJHttpProgress)progress
success:(void(^)(NSString *))success
failure:(MJHttpRequestFailed)failure
{
	//根据url生成请求对象
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
	
	__block NSURLSessionDownloadTask *downloadTask =
	[_sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
		
		//下载进度
		dispatch_sync(dispatch_get_main_queue(), ^{
			progress ? progress(downloadProgress) : nil;
		});
		
	} destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
		
		//拼接缓存目录
		NSString *downloadDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileDir ? fileDir : @"Download"];
		
		//打开文件管理器
		NSFileManager *fileManager = [NSFileManager defaultManager];
		
		//创建Download目录
		[fileManager createDirectoryAtPath:downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
		
		//拼接文件路径
		NSString *filePath = [downloadDir stringByAppendingPathComponent:response.suggestedFilename];
		
		//返回文件位置的URL路径
		return [NSURL fileURLWithPath:filePath];
		
	} completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
		
		[[self allSessionTask] removeObject:downloadTask];
		
		if(failure && error) {failure(error) ; return ;};
		
		//捡漏
		success ? success(filePath.absoluteString /** NSURL->NSString*/) : nil;
	}];
	
	//开始下载
	[downloadTask resume];
	
	// 添加sessionTask到数组
	downloadTask ? [[self allSessionTask] addObject:downloadTask] : nil ;
	
	return downloadTask;
}


#pragma mark-- 检测网络状况

+ (BOOL)isNetwork {
	return [AFNetworkReachabilityManager sharedManager].reachable;
}

+ (BOOL)isWWANNetwork {
	return [AFNetworkReachabilityManager sharedManager].reachableViaWWAN;
}

+ (BOOL)isWiFiNetwork {
	return [AFNetworkReachabilityManager sharedManager].reachableViaWiFi;
}

+ (void)openLog {
	_isOpenLog = YES;
}

+ (void)closeLog {
	_isOpenLog = NO;
}


#pragma mark-- 取消所有网络请求
+ (void)cancelAllRequest
{
	//锁操作
	@synchronized(self) {
		
		[[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
			[task cancel];
		}];
		[[self allSessionTask] removeAllObjects];
	}
	
}

/// 取消指定URL的HTTP请求
+ (void)cancelRequestWithURL:(NSString *)URL {
	
	if (!URL) { return; }
	
	@synchronized (self) {
		
		[[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
			
			if ([task.currentRequest.URL.absoluteString  hasPrefix:URL]) {
				[task cancel];
				
				[[self allSessionTask] removeObject:task];
				
				*stop = YES;
			}
			
		}];
		
	}
}

#pragma mark - 开始监听网络
+ (void)networkStatusWithBlock:(MJNetworkStatus)networkStatus {
	
	[[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
		switch (status) {
			case AFNetworkReachabilityStatusUnknown:
				networkStatus ? networkStatus(MJNetworkStatusUnknown) : nil;
				if (_isOpenLog) ZMJLog(@"未知网络");
				break;
			case AFNetworkReachabilityStatusNotReachable:
				networkStatus ? networkStatus(MJNetworkStatusNotReachable) : nil;
				if (_isOpenLog) ZMJLog(@"无网络");
				break;
			case AFNetworkReachabilityStatusReachableViaWWAN:
				networkStatus ? networkStatus(MJNetworkStatusReachableViaWWAN) : nil;
				if (_isOpenLog) ZMJLog(@"手机自带网络");
				break;
			case AFNetworkReachabilityStatusReachableViaWiFi:
				networkStatus ? networkStatus(MJNetworkStatusReachableViaWiFi) : nil;
				if (_isOpenLog) ZMJLog(@"WIFI");
				break;
		}
	}];
	
}

@end





#pragma mark - NSDictionary,NSArray的分类
/*
 ************************************************************************************
 *新建NSDictionary与NSArray的分类, 控制台打印json数据中的中文
 ************************************************************************************
 */

#ifdef DEBUG
@implementation NSArray (PP)

- (NSString *)descriptionWithLocale:(id)locale {
    NSMutableString *strM = [NSMutableString stringWithString:@"(\n"];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [strM appendFormat:@"\t%@,\n", obj];
    }];
    [strM appendString:@")"];

    return strM;
}

@end

@implementation NSDictionary (PP)

- (NSString *)descriptionWithLocale:(id)locale {
    NSMutableString *strM = [NSMutableString stringWithString:@"{\n"];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [strM appendFormat:@"\t%@ = %@;\n", key, obj];
    }];

    [strM appendString:@"}\n"];

    return strM;
}
@end
#endif

