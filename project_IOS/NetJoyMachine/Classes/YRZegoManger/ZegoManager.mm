//
//  ZegoManager.m
//  WaWaJi
//
//  Created by summery on 16/10/2017.
//  Copyright © 2017 zego. All rights reserved.
//

#import "ZegoManager.h"
#import "ZegoSetting.h"
#import "YRCommonKey.h"

@implementation ZegoManager

static ZegoLiveRoomApi *_apiInstance = nil;

+ (ZegoLiveRoomApi *)api {
    if (_apiInstance == nil) {
        
        [ZegoLiveRoomApi setUseTestEnv:JIGOUJoy_IsDebug];
        
#ifdef DEBUG
        [ZegoLiveRoomApi setVerbose:NO];
#endif
        
        // 初始化用户信息
        [ZegoLiveRoomApi setUserID:[ZegoSetting sharedInstance].userID userName:[ZegoSetting sharedInstance].userName];
        
        // 暂时 hardcode 鉴权信息
#ifdef I18N
        NSString *sign = @"0x5d,0xe6,0x83,0xac,0xa4,0xe5,0xad,0x43,0xe5,0xea,0xe3,0x70,0x6b,0xe0,0x77,0xa4,0x18,0x79,0x38,0x31,0x2e,0xcc,0x17,0x19,0x32,0xd2,0xfe,0x22,0x5b,0x6b,0x2b,0x2f"; // 国际版
#else
        NSString *sign = JIGOUJoy_APPKEY; // 娃娃机专用
#endif
        
        NSData *signData = ConvertStringToSign(sign);
        
#ifdef I18N
        _apiInstance = [[ZegoLiveRoomApi alloc] initWithAppID:3322882036 appSignature:signData];    // 国际版
#else
        _apiInstance = [[ZegoLiveRoomApi alloc] initWithAppID:JIGOUJoy_APPID appSignature:signData]; // 娃娃机专用
#endif
        
    }
    return _apiInstance;
}

+ (void)releaseApi {
    _apiInstance = nil;
}

NSData* ConvertStringToSign(NSString* strSign)
{
    if(strSign == nil || strSign.length == 0)
        return nil;
    strSign = [strSign lowercaseString];
    strSign = [strSign stringByReplacingOccurrencesOfString:@" " withString:@""];
    strSign = [strSign stringByReplacingOccurrencesOfString:@"0x" withString:@""];
    NSArray* szStr = [strSign componentsSeparatedByString:@","];
    int nLen = (int)[szStr count];
    Byte szSign[32];
    for(int i = 0; i < nLen; i++)
    {
        NSString *strTmp = [szStr objectAtIndex:i];
        if(strTmp.length == 1) {
            szSign[i] = toByte(strTmp);
        } else {
            szSign[i] = toByte([strTmp substringWithRange:NSMakeRange(0, 1)]) << 4 | toByte([strTmp substringWithRange:NSMakeRange(1, 1)]);
        }
//        NSLog(@"%x,", szSign[i]);
    }
    
    NSData *sign = [NSData dataWithBytes:szSign length:32];
    return sign;
}

Byte toByte(NSString* c)
{
    NSString *str = @"0123456789abcdef";
    Byte b = [str rangeOfString:c].location;
    return b;
}


@end

