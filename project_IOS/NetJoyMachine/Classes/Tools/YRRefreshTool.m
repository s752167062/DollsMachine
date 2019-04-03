//
//  YRRefreshTool.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/15.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRRefreshTool.h"

@implementation YRRefreshTool


@end

@implementation YRRefreshHeader

- (void)prepare
{
    [super prepare];
    
    // 自动切换透明度
    self.automaticallyChangeAlpha = YES;
    // 隐藏时间
    self.lastUpdatedTimeLabel.hidden = YES;
    // 修改状态文字的颜色
    //    self.stateLabel.textColor = [UIColor orangeColor];
    // 修改状态文字
    [self setTitle:@"赶紧再下拉" forState:MJRefreshStateIdle];
    [self setTitle:@"松开🐴上刷新" forState:MJRefreshStatePulling];
    [self setTitle:@"正在玩命刷新中..." forState:MJRefreshStateRefreshing];
    
}

@end

@implementation YRRefreshFooter

- (void)prepare
{
    [super prepare];
    
    // 自动切换透明度
    self.automaticallyChangeAlpha = YES;
    
    // 修改状态文字的颜色
    //    self.stateLabel.textColor = [UIColor orangeColor];
    // 修改状态文字
    [self setTitle:@"上拉查看详情页" forState:MJRefreshStateIdle];
    [self setTitle:@"松开🐴上马上呈现" forState:MJRefreshStatePulling];
    [self setTitle:@"正在玩命刷新中..." forState:MJRefreshStateRefreshing];
    
}

@end
