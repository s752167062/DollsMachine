//
//  YRPayVc.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/17.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRPayVc.h"

@interface YRPayVc ()

@end

@implementation YRPayVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDefault];
    
    [self setupUI];
    
    
}

#pragma mark-- 设置默认值
- (void)setupDefault
{
    self.title = @"充值记录";
    
}

#pragma mark-- 初始化视图
- (void)setupUI
{
    [self.view addSubview:self.private_MsgHeaderV];
    
    [self.view addSubview:self.myTableView];
    
}

@end
