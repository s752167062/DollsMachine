//
//  NSDictionary+Encrypt.h
//  TeleStation
//
//  Created by huangbinbin on 17/3/19.
//  Copyright © 2017年 huangbinbin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Encrypt)

// 加密
// 先添加randomType、appVersion、deviceName、deviceType的键值对
// 然后对参数值中的所有Key进行排序,例如 A B C D..,并生成一个键值对,例如 a=file&b=edit&c=view ....
// 如果用户是登录的,则添加userid
// 然后添加serverPublicKey并进行MD5加密并且小写
// 然后这个作为参数添加到请求的参数里面
- (NSDictionary *)encrypt;


@end

