//
//  YRNoticeVc.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/20.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRNoticeVc.h"
#import "YRNoticeCell.h"
#import "YRNoticeModel.h"
#import "YRNoticeHeaderView.h"
#import "UIResponder+Router.h"

@interface YRNoticeVc ()

@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation YRNoticeVc

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self setupDefault];
    
    [self setupUI];
    
    
}

#pragma mark-- 设置默认值
- (void)setupDefault
{
    self.title = @"通知消息";
    
}

#pragma mark-- 初始化视图
- (void)setupUI
{
    [self.view addSubview:[self getTableViewWithStyle:MyTableView_StyleGrouped]];
    
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRNoticeCell class]) bundle:nil] forCellReuseIdentifier:YRNoticeCellID];
    
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRNoticeHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:YRNoticeHeaderViewID];
    
    self.myTableView.estimatedRowHeight = 100.0;
    
    self.myTableView.rowHeight = UITableViewAutomaticDimension;
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section > self.dataArr.count - 1) return 0;
    
    YRNoticeModel *item = self.dataArr[section];
    
    if (item.isOpen) {
        
        return 1;
    }else{
        return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArr ? self.dataArr.count : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    YRNoticeHeaderView *headerV = [tableView dequeueReusableHeaderFooterViewWithIdentifier:YRNoticeHeaderViewID];
    
    if (section < self.dataArr.count) {
        headerV.noticeItem = self.dataArr[section];
    }
    
    return headerV;
}


static NSString *const YRNoticeCellID = @"YRNoticeCellID";
static NSString *const YRNoticeHeaderViewID = @"YRNoticeHeaderViewID";


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YRNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:YRNoticeCellID];
    
    if (indexPath.row < self.dataArr.count) {
        cell.noticeItem = self.dataArr[indexPath.row];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

#pragma mark-- 点击事件

- (void)notice_MsgSectionHeaderDidClicked:(NSInteger)sectionNum
{
    [self.myTableView reloadData];
    
//    if (sectionNum > self.myTableView.numberOfSections)
//        return;
//    
//    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:sectionNum];
//    
//    [self.myTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark-- 懒加载假数据
- (NSArray *)dataArr
{
    if (!_dataArr) {
        
        NSMutableArray *arr = [NSMutableArray array];
        
        for (NSInteger i = 0; i < 4; i++) {
            
            YRNoticeModel *noticeItem = [YRNoticeModel new];
            
            noticeItem.secitonNum = i;
            
            noticeItem.isOpen = i % 2 == 0;
            
            [arr addObject:noticeItem];
        }
        
        _dataArr = [NSArray arrayWithArray:arr];
        
    }
    return _dataArr;
}

@end
