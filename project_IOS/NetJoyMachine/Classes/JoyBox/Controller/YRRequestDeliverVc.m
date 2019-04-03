//
//  YRRequestDeliverVc.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/20.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRRequestDeliverVc.h"
#import "YRDeliverAdsCell.h"
#import "YRDeliverGoodsCell.h"
#import "YRRequestDeliverModel.h"

@interface YRRequestDeliverVc ()

@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation YRRequestDeliverVc


- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setupDefault];
    
    [self setupUI];
    
    
}

#pragma mark-- 设置默认值
- (void)setupDefault
{
    self.title = @"请求发货";
    
}

#pragma mark-- 初始化视图
- (void)setupUI
{
    [self.view addSubview:self.myTableView];
    
    
    
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRDeliverAdsCell class]) bundle:nil] forCellReuseIdentifier:YRDeliverAdsCellID];
    
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRDeliverGoodsCell class]) bundle:nil] forCellReuseIdentifier:YRDeliverGoodsCellID];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > self.dataArr.count || !self.dataArr) return 0;
    
    YRRequestDeliverModel *model = self.dataArr[indexPath.row];
        
    return model.cornerRadiusCellSize.height;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerV = [[UIView alloc] init];
    
    return headerV;
}



static NSString *const YRDeliverAdsCellID = @"YRDeliverAdsCellID";

static NSString *const YRDeliverGoodsCellID = @"YRDeliverGoodsCellID";


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            {
                YRDeliverAdsCell *cell = [tableView dequeueReusableCellWithIdentifier:YRDeliverAdsCellID];
                
                if (indexPath.row < self.dataArr.count) {
                    
                    cell.deliverItem = self.dataArr[indexPath.row];
                }
                
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
                
            }
            break;
            
        case 1:
        {
            YRDeliverGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:YRDeliverGoodsCellID];
            
            if (indexPath.row < self.dataArr.count) {
                
                cell.deliverItem = self.dataArr[indexPath.row];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
            
        }
            break;
            
        default:
            return [UITableViewCell new];
            break;
    }
    
}

- (NSArray *)dataArr
{
    if (!_dataArr) {
        
        NSMutableArray *arr = [NSMutableArray array];
        
        for (NSInteger i = 0; i < 2; i++) {
            
            YRRequestDeliverModel *model = [[YRRequestDeliverModel alloc] init];
            
            [arr addObject:model];
        }
        
        [YRCornerBaseModel mj_reloveCornerModeWithArr:arr andSize:CGSizeMake(self.myTableView.MJ_width, MJScreenH * 0.14)];
        
        _dataArr = [NSArray arrayWithArray:arr];
        
    }
    return _dataArr;
}



@end
