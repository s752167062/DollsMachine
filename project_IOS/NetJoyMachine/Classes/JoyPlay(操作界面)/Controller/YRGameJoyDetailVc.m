//
//  YRGameJoyDetailVc.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/20.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRGameJoyDetailVc.h"
#import "YRGameJoyDetailCell.h"

@interface YRGameJoyDetailVc ()

@end

@implementation YRGameJoyDetailVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDefault];
    
    [self setupUI];
    
    
}

#pragma mark-- 设置默认值
- (void)setupDefault
{
    self.title = @"娃娃详情";
    
}

#pragma mark-- 初始化视图
- (void)setupUI
{
    [self.view addSubview:self.myTableView];
    
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRGameJoyDetailCell class]) bundle:nil] forCellReuseIdentifier:YRGameJoyDetailCellID];
    
    self.myTableView.rowHeight = MJScreenH * 0.28;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}




static NSString *const YRGameJoyDetailCellID = @"YRGameJoyDetailCellID";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YRGameJoyDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:YRGameJoyDetailCellID];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

@end
