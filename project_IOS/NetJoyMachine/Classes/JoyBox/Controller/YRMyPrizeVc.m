//
//  YRMyPrizeVc.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/19.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRMyPrizeVc.h"
#import "YRMyPrizeCell.h"


@interface YRMyPrizeVc ()

@end

@implementation YRMyPrizeVc

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self setupDefault];
    
    [self setupUI];
    
}

//MARK:- 设置默认信息
- (void)setupDefault
{
    self.title = @"我的奖品";
}

//MARK:- 设置UI
- (void)setupUI
{
    [self.view addSubview:self.myTableView];
    
    self.myTableView.rowHeight = MJScreenH * 0.16;
    
    self.myTableView.backgroundColor = MJMainRedColor;
    
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRMyPrizeCell class]) bundle:nil] forCellReuseIdentifier:YRMyPrizeCellID];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}


static NSString *const YRMyPrizeCellID = @"YRMyPrizeCellID";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YRMyPrizeCell *cell = [tableView dequeueReusableCellWithIdentifier:YRMyPrizeCellID];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

@end
