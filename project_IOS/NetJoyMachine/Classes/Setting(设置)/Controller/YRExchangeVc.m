//
//  YRExchangeVc.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/17.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRExchangeVc.h"

@interface YRExchangeVc ()

@property (weak, nonatomic) IBOutlet UITextField *textF;

@property (weak, nonatomic) IBOutlet UIButton *exchangeBtn;

@end

@implementation YRExchangeVc

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupDefault];
    
    [self setupUI];
    
    
}

#pragma mark-- 设置默认值
- (void)setupDefault
{
    self.title = @"兑换";
    
}

#pragma mark-- 初始化视图
- (void)setupUI
{
    self.textF.font = MJMiddleBobyFont;
    
    self.exchangeBtn.titleLabel.font = MJBigBobyFont;
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.exchangeBtn setCornerRadius:self.exchangeBtn.MJ_height * 0.5];
    
    
}

- (IBAction)exchangeBtnDIdClicked:(id)sender
{
    
    
}



@end
