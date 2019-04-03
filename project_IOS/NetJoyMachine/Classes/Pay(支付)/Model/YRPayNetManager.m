//
//  YRPayNetManager.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/12/2.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRPayNetManager.h"
#import "HJNetworkManager.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>

#define  kVersionForSDK           @"1" // 表示新接口版本 ，“1”： 表示旧接口版本 。
#define  kPayInitURLForSDK        @"https://pay.heepay.com/Phone/SDK/PayInit.aspx"

#define  kQueryURLForSDK          @"https://pay.heepay.com/Phone/SDK/PayQuery.aspx"

//#warning 这里填写商户号与商户秘钥
//测试号1
#define  kSignKeyForSDK           @"4B05A95416DB4184ACEE4313"
#define  kAgentIdForSDK           @"1664502"

@interface YRPayNetManager()<NSXMLParserDelegate>

@property (nonatomic,copy) WebRequestCompleteBlock completeBlock;

@property (nonatomic,copy) NSMutableDictionary * returnValue;

@property (nonatomic,copy) NSMutableString * tmpStr;

@end

@implementation YRPayNetManager

+(YRPayNetManager *)shareInstance
{
    static YRPayNetManager *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YRPayNetManager alloc] init];
    });
    return instance;
}

- (void)sendWebRequestToSDKInitWithPayStyle:(YRPayStyle)payStyle paymentType:(YRPayModel *)payModel withCompleteBlock:(WebRequestCompleteBlock)block
{
    payModel.userId = @"1000021";
    
    payModel.isPhone = @"1";
    
    payModel.userIp = [self getIPAddress];
    
    payModel.payType = [NSString stringWithFormat:@"%zd",payStyle];
    
    payModel.cardId = payModel.cardId == nil ? @"0" : payModel.cardId;
    
    NSLog(@"%@",[payModel mj_keyValues]);
    
    [SVProgressHUD showWithStatus:@"加载中~"];
    
    [HJNetworkManager setRequestSerializer:MJRequestSerializerJSON];
    
    [HJNetworkManager POST:@"http://192.168.1.210:9000/Pay/addPay" parameters:[payModel mj_keyValues] success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        if ([((NSDictionary *)responseObject).allKeys containsObject:@"payUrl"] && responseObject[@"payUrl"] != nil) {
            //agent_bill_id  agent_id
            [self awakeUpPaySDK:responseObject[@"payUrl"] andBill:responseObject[@"agent_bill_id"] andAgentId:responseObject[@"agent_id"] WithCompleteBlock:block];
            
        }else{
           
        }
        
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
        block(@{
                @"error":[error localizedDescription]
                },YES);
    }];
    
    [HJNetworkManager setRequestSerializer:MJRequestSerializerHTTP];
    
}

#pragma mark-- 唤醒支付
- (void)awakeUpPaySDK:(NSString *)urlStr andBill:(NSString *)billId andAgentId:(NSString *)agentId WithCompleteBlock:(WebRequestCompleteBlock)block
{
    self.completeBlock = block;
    
    NSStringEncoding gb2312 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    //中文转码
    NSString * encodeParams = [urlStr stringByAddingPercentEscapesUsingEncoding:gb2312];
    
    NSMutableURLRequest * theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kPayInitURLForSDK] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0f];
    [theRequest setHTTPMethod:@"POST"];
    
    [theRequest addValue: @"application/x-www-form-urlencoded;charset=GB2312" forHTTPHeaderField:@"Content-Type"];
    
    [theRequest setHTTPBody:[encodeParams dataUsingEncoding:NSUTF8StringEncoding]];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSURLConnection sendAsynchronousRequest:theRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (connectionError) {
                    self.completeBlock(@{
                                         @"error":[connectionError localizedDescription]
                                         },YES);
                }
                else {
                    NSString * xmlString = [[NSString alloc] initWithBytes:[data bytes] length:data.length encoding:NSUTF8StringEncoding];
                    NSLog(@"xml String ::%@",xmlString);
                    _returnValue = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                   @"agent_bill_id":billId,
                                                                                   @"agent_id":agentId,
                                                                                   }];
                    NSXMLParser * parser = [[NSXMLParser alloc] initWithData:data];
                    parser.delegate = self;
                    [parser parse];
                }
            });
        }];
    });
    
}

- (NSString *)getSystemTimeString
{
    NSDate * data = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    NSString * timeString = [formatter stringFromDate:data];
    return timeString;
}

#pragma mark - NSXMLParserDelegate Methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    _tmpStr = [[NSMutableString alloc] init];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [_tmpStr appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"token_id"]) {
        [_returnValue setObject:_tmpStr forKey:@"token_id"];
    }
    else if ([elementName isEqualToString:@"error"]) {
        [_returnValue setObject:_tmpStr forKey:@"error"];
    }
    
    _tmpStr = nil;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    if(self.completeBlock){
        if (_returnValue[@"error"] != nil) {
            self.completeBlock(self.returnValue.copy,YES);
        }
        else {
            
            self.completeBlock(self.returnValue.copy,NO);
        }
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    if(self.completeBlock){
        self.completeBlock(@{
                             @"error":@"解析失败"
                             },YES);
    }
}


// Get IP Address
- (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}



@end
