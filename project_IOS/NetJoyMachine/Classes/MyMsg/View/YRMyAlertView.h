//
//  YRMyAlertView.h
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/16.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum YRMyAlertView_btnClick_type
{
    MyAlertView_iconBtn = 0,//头像
    MyAlertView_settingBtn,//设置
    MyAlertView_gamecoinBtn,//游戏币充值
    MyAlertView_moneyChangeBtn,//金币兑换
    MyAlertView_getItBtn,//抓取记录
    MyAlertView_notiMsgBtn,//通知消息
    MyAlertView_coinOpenBtn//金币开箱
    
} MyAlertView_Btntype;

@class YRMyAlertView;

@protocol YRMyAlertViewDelegate <NSObject>

- (void)myAletViewChildBtnDidClicked:(MyAlertView_Btntype)btnType;


@end

@interface YRMyAlertView : UIView

@property (nonatomic, weak) id<YRMyAlertViewDelegate> MyAlertViewDelegate;

@end
