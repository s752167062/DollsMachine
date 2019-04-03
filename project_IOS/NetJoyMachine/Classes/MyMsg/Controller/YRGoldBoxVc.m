//
//  YRGoldBoxVc.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/17.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRGoldBoxVc.h"
#import "YRMyPrizeVc.h"

@interface YRGoldBoxVc ()

@end

@implementation YRGoldBoxVc

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self setupDefault];
    
    [self setupUI];
    
    
}

#pragma mark-- 设置默认值
- (void)setupDefault
{
    self.title = @"金币开箱";
    
    
    
}

#pragma mark-- 初始化视图
- (void)setupUI
{
    //添加右侧barItem
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem mj_addRightBarButtonItemWithTitle:@"我的奖品" andTarget:self action:@selector(rightBarBtnDidClicked)];
    
}

- (void)rightBarBtnDidClicked
{
    YRMyPrizeVc *prizeVc = [[YRMyPrizeVc alloc] init];
    
    [self.navigationController pushViewController:prizeVc animated:YES];
    
}
    

@end
