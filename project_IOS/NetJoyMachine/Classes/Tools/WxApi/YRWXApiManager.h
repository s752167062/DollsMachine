//
//  YRWXApiManager.h
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/26.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WXApi.h>

@protocol WXApiManagerDelegate <NSObject>

@optional

- (void)managerDidRecvGetMessageReq:(GetMessageFromWXReq *)request;

- (void)managerDidRecvShowMessageReq:(ShowMessageFromWXReq *)request;

- (void)managerDidRecvLaunchFromWXReq:(LaunchFromWXReq *)request;

- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response;

//接收到登录授权消息
- (void)managerDidRecvAuthResponse:(SendAuthResp *)response;

- (void)managerDidRecvAddCardResponse:(AddCardToWXCardPackageResp *)response;

- (void)managerDidRecvChooseCardResponse:(WXChooseCardResp *)response;

- (void)managerDidRecvChooseInvoiceResponse:(WXChooseInvoiceResp *)response;

//- (void)managerDidRecvSubscribeMsgResponse:(WXSubscribeMsgResp *)response;
//
//- (void)managerDidRecvLaunchMiniProgram:(WXLaunchMiniProgramResp *)response;

@end

@interface YRWXApiManager : NSObject<WXApiDelegate>

@property (nonatomic, weak) id<WXApiManagerDelegate> delegate;

+ (instancetype)sharedManager;

@end
