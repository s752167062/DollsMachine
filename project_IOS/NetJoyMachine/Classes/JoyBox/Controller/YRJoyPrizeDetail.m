//
//  YRJoyPrizeDetail.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/20.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRJoyPrizeDetail.h"
#import "YRPrizeDetailBtnCell.h"
#import "YRPrizeDetailTitleCell.h"
#import "YRJoyPrizeDetailCell.h"
#import "YRRequestDeliverVc.h"


static NSString *const YRPrizeDetailBtnCellID = @"YRPrizeDetailBtnCellID";
static NSString *const YRPrizeDetailTitleCellID = @"YRPrizeDetailTitleCellID";
static NSString *const YRJoyPrizeDetailCellID = @"YRJoyPrizeDetailCellID";

@interface YRJoyPrizeDetail ()

@end

@implementation YRJoyPrizeDetail

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
    
    self.myTableView.backgroundColor = MJMainRedColor;
    
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRPrizeDetailBtnCell class]) bundle:nil] forCellReuseIdentifier:YRPrizeDetailBtnCellID];
    
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRPrizeDetailTitleCell class]) bundle:nil] forCellReuseIdentifier:YRPrizeDetailTitleCellID];
    
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRJoyPrizeDetailCell class]) bundle:nil] forCellReuseIdentifier:YRJoyPrizeDetailCellID];
    
    self.myTableView.estimatedRowHeight = 64;
   
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 5;
            break;
        case 2:
            return 2;
            break;
            
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return MJScreenH * 0.2;
            break;
            
        default:
            return UITableViewAutomaticDimension;
            break;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    switch (indexPath.section) {
        case 0:
            {
                YRJoyPrizeDetailCell *detailCell = [tableView dequeueReusableCellWithIdentifier:YRJoyPrizeDetailCellID];
                
                detailCell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return detailCell;
                
            }
            break;
            
        case 1:
        {
            YRPrizeDetailTitleCell *titleCell = [tableView dequeueReusableCellWithIdentifier:YRPrizeDetailTitleCellID];
            
            titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return titleCell;
            
        }
            break;
            
        case 2:
        {
            YRPrizeDetailBtnCell *btnCell = [tableView dequeueReusableCellWithIdentifier:YRPrizeDetailBtnCellID];
            
            btnCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return btnCell;
            
        }
            break;
            
        default:
            return nil;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YRRequestDeliverVc *deliverVc = [[YRRequestDeliverVc alloc] init];
    
    [self.navigationController pushViewController:deliverVc animated:YES];
    
}


@end
