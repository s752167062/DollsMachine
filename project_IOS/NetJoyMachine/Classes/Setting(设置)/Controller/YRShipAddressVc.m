//
//  YRShipAddressVc.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/17.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRShipAddressVc.h"
#import "YRShipAdsCell.h"
#import "YRAddNewAddressVc.h"
#import "UserInfoTool.h"
#import "YRLocationModel.h"

@interface YRShipAddressVc ()

@end

@implementation YRShipAddressVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDefault];
    
    [self setupUI];
    
    [self addHeaderRefresh:self.myTableView];
//    [self addFooterRefresh:self.myTableView];
    
    [self getRequestData];
    
}

- (void)getRequestData
{
    NSString *userId = [UserInfoTool getUserDefaultKey:UserDefault_UserID];
    
    [SVProgressHUD showWithStatus:YR_Hint_Refreshing];
    [[GCDAsyncSocketCommunicationManager sharedInstance] socketWriteDataWithRequestType:GACRequestType_GetReceivingAdv requestBody:@{@"userid":userId,@"type":@"5"} completion:^(NSError * _Nullable error, id  _Nullable data) {
        
        NSLog(@"错误: %@,数据:%@",error,data);
        [SVProgressHUD dismiss];
        
        if (error || !data) {
            [SVProgressHUD showErrorWithStatus:@"网络繁忙"];
            return;
        }
        [self.myTableView.mj_header endRefreshing];
        
        self.basicDataArr = [YRLocationModel mj_objectArrayWithKeyValuesArray:data[@"resultList"]];
        
        
        [self.myTableView reloadData];
    }];
    
}

//MARK:- 设置默认信息
- (void)setupDefault
{
    self.title = @"收货地址";
}

//MARK:- 设置UI
- (void)setupUI
{
    
    [self.view insertSubview:self.myTableView atIndex:0];
    
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRShipAdsCell class]) bundle:nil] forCellReuseIdentifier:YRShipAdsCellID];
    
    self.myTableView.backgroundColor = MJMainRedColor;
    
    self.myTableView.estimatedRowHeight = 50;
    
    self.myTableView.rowHeight = UITableViewAutomaticDimension;
    
    //添加右侧barItem
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem mj_addRightBarButtonItemWithTitle:@"添加" andTarget:self action:@selector(rightBtnDidClicked)];
    
}

- (void)rightBtnDidClicked
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"YRAddNewAddressVc" bundle:nil];
    
    YRAddNewAddressVc *vc = [sb instantiateInitialViewController];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}



static NSString *YRShipAdsCellID = @"YRShipAdsCellID";

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.basicDataArr ? self.basicDataArr.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YRShipAdsCell *cell = [tableView dequeueReusableCellWithIdentifier:YRShipAdsCellID];
    
    if (indexPath.row < self.basicDataArr.count) {
        cell.locationItem = self.basicDataArr[indexPath.row];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > self.basicDataArr.count - 1) return;
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"YRAddNewAddressVc" bundle:nil];
    
    YRAddNewAddressVc *vc = [sb instantiateInitialViewController];
    
    vc.locationItem = self.basicDataArr[indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
