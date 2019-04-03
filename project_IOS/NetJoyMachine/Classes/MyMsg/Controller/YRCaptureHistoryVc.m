//
//  YRCaptureHistoryVc.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/19.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRCaptureHistoryVc.h"
#import "YRCaptureHistoryCell.h"
#import "YRCapHistoryModel.h"
#import "YRCaptureDetailVc.h"

@interface YRCaptureHistoryVc ()

@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation YRCaptureHistoryVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDefault];
    
    [self setupUI];
    
}

//MARK:- 设置默认信息
- (void)setupDefault
{
    self.title = @"抓取记录";
}

//MARK:- 设置UI
- (void)setupUI
{
    [self.view addSubview:self.myTableView];
    
//    self.myTableView.rowHeight = MJScreenH * 0.2;
    
    self.myTableView.backgroundColor = MJMainRedColor;
    
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRCaptureHistoryCell class]) bundle:nil] forCellReuseIdentifier:YRCaptureHistoryCellID];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr ? self.dataArr.count : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > self.dataArr.count || !self.dataArr) return 0;
    
    YRCapHistoryModel *model = self.dataArr[indexPath.row];
    
    return model.cornerRadiusCellSize.height;
    
}

static NSString *const YRCaptureHistoryCellID = @"YRCaptureHistoryCellID";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YRCaptureHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:YRCaptureHistoryCellID];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row < self.dataArr.count) {
        
        cell.historyItem = self.dataArr[indexPath.row];
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YRCaptureDetailVc *vc = [[YRCaptureDetailVc alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}


- (NSArray *)dataArr
{
    if (!_dataArr) {
        
        NSMutableArray *arr = [NSMutableArray array];
        
        for (NSInteger i = 0; i < 3; i++) {
            
            YRCapHistoryModel *model = [[YRCapHistoryModel alloc] init];
            
            [arr addObject:model];
        }
        
        [YRCornerBaseModel mj_reloveCornerModeWithArr:arr andSize:CGSizeMake(self.myTableView.MJ_width, MJScreenH * 0.2)];
        
        _dataArr = [NSArray arrayWithArray:arr];
        
    }
    return _dataArr;
}


    
    
@end
