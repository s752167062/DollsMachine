//
//  YRPayHistoryVc.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/17.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRPayHistoryVc.h"
#import "YRPayHistoryCell.h"

@interface YRPayHistoryVc ()

@end

@implementation YRPayHistoryVc

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
    [self.view insertSubview:self.private_MsgHeaderV atIndex:0];
    
    
    [self.view addSubview:self.myTableView];
    
    
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRPayHistoryCell class]) bundle:nil] forCellReuseIdentifier:YRPayHistoryCellID];
    
    self.myTableView.frame = CGRectMake(0, self.private_MsgHeaderV.MJ_bottom, MJScreenW, MJScreenH - self.private_MsgHeaderV.MJ_height - MJNavMaxY);
    
    self.myTableView.backgroundColor = MJMainRedColor;
    
    
    self.myTableView.rowHeight = Size(60, 70, 80);
    
}

static NSString *YRPayHistoryCellID = @"YRPayHistoryCellID";

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YRPayHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:YRPayHistoryCellID];
    
    return cell;
    
}

@end
