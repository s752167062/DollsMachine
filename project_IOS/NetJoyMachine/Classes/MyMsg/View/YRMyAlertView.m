//
//  YRMyAlertView.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/16.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRMyAlertView.h"
#import "YRRechargeView.h"
#import "UIView+TYAlertView.h"
#import "UserInfoTool.h"
#import "YRLoginUserModel.h"
#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>
#import "GCDAsyncSocketCommunicationManager.h"
#import "YRMyAlertViewModel.h"
#import <SVProgressHUD.h>
#import <MJExtension.h>

@interface YRMyAlertView()

//背景视图
@property (weak, nonatomic) IBOutlet UIView *backV;

//头像按钮
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;

//性别图片
@property (weak, nonatomic) IBOutlet UIImageView *sexImgV;

//名字
@property (weak, nonatomic) IBOutlet UILabel *iconNameL;


//游戏币按钮
@property (weak, nonatomic) IBOutlet UIButton *gameCoinBtn;

//金币兑换按钮
@property (weak, nonatomic) IBOutlet UIButton *moneyBtn;

//游戏币充值
@property (weak, nonatomic) IBOutlet UILabel *gameCoinL;

//金币兑换
@property (weak, nonatomic) IBOutlet UILabel *moneyL;

@property (weak, nonatomic) IBOutlet UILabel *msgNumL;

@end

@implementation YRMyAlertView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    
    [self setupDefault];
    
    [self setupUI];
    
    //获取个人信息(金币等)
    [self getPersonMsgData];
}

#pragma mark-- 设置默认值
- (void)setupDefault
{
    self.MJ_width = YRAlert_Relative_Width;
    
    self.MJ_height = YRAlert_Relative_Height;
    
    _gameCoinBtn.titleLabel.font = MJBigTitleFont;
    _moneyBtn.titleLabel.font = MJBigTitleFont;
    
    _gameCoinL.font = MJBlodMiddleBobyFont;
    _moneyL.font = MJBlodMiddleBobyFont;
    
    [self layoutIfNeeded];
    
    [_msgNumL setCornerRadius:_msgNumL.MJ_width * 0.5];
    
    [self.iconBtn setCornerRadius:self.iconBtn.MJ_width * 0.5];
    
    [self.gameCoinBtn setCornerRadius:self.gameCoinBtn.MJ_height * 0.5];
    
    [self.moneyBtn setCornerRadius:self.moneyBtn.MJ_height * 0.5];
    
//    //阴影的颜色
//    self.iconBtn.layer.shadowColor = [UIColor blackColor].CGColor;
//    //阴影的透明度
//
//    self.iconBtn.layer.shadowOpacity = 0.8f;
//    //阴影的圆角
//
//    self.iconBtn.layer.shadowRadius = 10.f;
//    //阴影偏移量
//
//    self.iconBtn.layer.shadowOffset = CGSizeMake(4,4);
}

#pragma mark-- 初始化视图
- (void)setupUI
{
    YRLoginUserModel *userItem = [UserInfoTool getUserInfo];
    
    [self.iconBtn sd_setImageWithURL:[NSURL URLWithString:userItem.iconurl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"cart_superMan"]];
    
    self.iconNameL.text = userItem.name;
    
}

#pragma mark-- 获取数据
- (void)getPersonMsgData
{
    NSString *userId = [UserInfoTool getUserDefaultKey:UserDefault_UserID];
    
    ZMJWeakSelf(self);
    [SVProgressHUD showWithStatus:@"加载中~"];
    [[GCDAsyncSocketCommunicationManager sharedInstance] socketWriteDataWithRequestType:GACRequestType_SendPersonageMsg requestBody:@{@"userId":userId ? :@"zz"} completion:^(NSError * _Nullable error, id  _Nullable data) {
        [SVProgressHUD dismiss];
        
        if (error || !data) {
            [SVProgressHUD showErrorWithStatus:@"网络繁忙"];
            return;
        }
        
        
        YRMyAlertViewModel *alertItem = [YRMyAlertViewModel mj_objectWithKeyValues:data[@"info"]];
        
        [weakself.gameCoinBtn setTitle:alertItem.gameCoin forState:UIControlStateNormal];
        
        [weakself.moneyBtn setTitle:alertItem.goldCoin forState:UIControlStateNormal];
        
        NSLog(@"%@",data);
        
    }];
}

- (void)layoutIfNeeded
{
    [super layoutIfNeeded];
    
    
    
}

#pragma mark-- 点击事件

- (IBAction)closeBtnDidClicked:(id)sender
{
    [self hideView];
}



//头像的点击
- (IBAction)iconImgBtnDidClicked:(id)sender
{
    if (![self.MyAlertViewDelegate respondsToSelector:@selector(myAletViewChildBtnDidClicked:)]) return;
    
    [self.MyAlertViewDelegate myAletViewChildBtnDidClicked:MyAlertView_iconBtn];
}

//设置按钮的点击
- (IBAction)settingBtnDidClicked:(id)sender
{
    
    if (![self.MyAlertViewDelegate respondsToSelector:@selector(myAletViewChildBtnDidClicked:)]) return;
    
    [self.MyAlertViewDelegate myAletViewChildBtnDidClicked:MyAlertView_settingBtn];
}

//游戏币充值按钮点击
- (IBAction)gamecoinBtnDidClicked:(id)sender
{
    [self hideView];
    
    if (![self.MyAlertViewDelegate respondsToSelector:@selector(myAletViewChildBtnDidClicked:)]) return;
        
    [self.MyAlertViewDelegate myAletViewChildBtnDidClicked:MyAlertView_gamecoinBtn];
    
}

//金币兑换按钮点击
- (IBAction)moneyChangeBtnDidClicked:(id)sender
{
//    [self hideView];
    
    if (![self.MyAlertViewDelegate respondsToSelector:@selector(myAletViewChildBtnDidClicked:)]) return;
    
    [self.MyAlertViewDelegate myAletViewChildBtnDidClicked:MyAlertView_moneyChangeBtn];
}

//抓取记录按钮点击
- (IBAction)getItBtnDidClicked:(id)sender
{
    if (![self.MyAlertViewDelegate respondsToSelector:@selector(myAletViewChildBtnDidClicked:)]) return;
    
    [self.MyAlertViewDelegate myAletViewChildBtnDidClicked:MyAlertView_getItBtn];
}

//通知消息按钮点击
- (IBAction)notificationMsgBtnDidClicked:(id)sender
{
    if (![self.MyAlertViewDelegate respondsToSelector:@selector(myAletViewChildBtnDidClicked:)]) return;
    
    [self.MyAlertViewDelegate myAletViewChildBtnDidClicked:MyAlertView_notiMsgBtn];
}

//金币开箱按钮点击
- (IBAction)coinOpenBtnDidClicked:(id)sender
{
    if (![self.MyAlertViewDelegate respondsToSelector:@selector(myAletViewChildBtnDidClicked:)]) return;
    
    [self.MyAlertViewDelegate myAletViewChildBtnDidClicked:MyAlertView_coinOpenBtn];
}

- (void)dealloc
{
    
    
}

@end
