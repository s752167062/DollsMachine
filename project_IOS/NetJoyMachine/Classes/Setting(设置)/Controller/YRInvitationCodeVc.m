//
//  YRInvitationCodeVc.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/17.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRInvitationCodeVc.h"

@interface YRInvitationCodeVc ()

//兑换按钮
@property (weak, nonatomic) IBOutlet UIButton *exchangeBtn;

//分享按钮
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

//输入框
@property (weak, nonatomic) IBOutlet UITextField *invitationTextF;

//邀请标题
@property (weak, nonatomic) IBOutlet UILabel *joinL;

//邀请规则
@property (weak, nonatomic) IBOutlet UILabel *joinContentL;

//我的邀请码
@property (weak, nonatomic) IBOutlet UILabel *myCodeL;

//邀请码标题
@property (weak, nonatomic) IBOutlet UILabel *codeTitleL;

@end

@implementation YRInvitationCodeVc

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self setupDefault];
    
    [self setupUI];
    
    
}

#pragma mark-- 设置默认值
- (void)setupDefault
{
    self.title = @"邀请码";
    
}

#pragma mark-- 初始化视图
- (void)setupUI
{
    self.invitationTextF.font = MJMiddleBobyFont;
    
    self.exchangeBtn.titleLabel.font = MJBigBobyFont;
    
    self.shareBtn.titleLabel.font = self.exchangeBtn.titleLabel.font;
    
    self.joinL.font = MJBlodTitleFont;
    
    self.joinContentL.font = MJOtherSmallFont;
    
    self.codeTitleL.font = MJBlodTitleFont;
    
    self.myCodeL.font = MJBlodMiddleBobyFont;
    
    
    
    
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.exchangeBtn setCornerRadius:self.exchangeBtn.MJ_height * 0.5];
    
    [self.shareBtn setCornerRadius:self.shareBtn.MJ_height * 0.5];
    
    
}


- (IBAction)exchangeBtnDidClicked:(id)sender {
}

- (IBAction)shareBtnDidClicked:(id)sender {
}

@end
