//
//  YRCaptureDetailVc.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/19.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRCaptureDetailVc.h"
#import "YRCapDetailTextCell.h"
#import "YRCaptureDetailCell.h"
#import "YRCaptureDetailModel.h"
#import "UIResponder+Router.h"
#import "YROtherThingsVc.h"
#import "YRBasicVc+YROtherPackageMethod.h"

static NSString *const YRCapDetailTextCellID = @"YRCapDetailTextCellID";

static NSString *const YRCaptureDetailCellID = @"YRCaptureDetailCellID";

@interface YRCaptureDetailVc ()

@property (nonatomic, strong) NSArray *titleArr;

@end

@implementation YRCaptureDetailVc

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setupDefault];
    
    [self setupUI];
    
    
}

#pragma mark-- 设置默认值
- (void)setupDefault
{
    self.title = @"抓取详情";
    
}

#pragma mark-- 初始化视图
- (void)setupUI
{
    [self.view addSubview:self.myTableView];
    
    self.myTableView.estimatedRowHeight = 120;
    
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRCapDetailTextCell class]) bundle:nil] forCellReuseIdentifier:YRCapDetailTextCellID];
    
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRCaptureDetailCell class]) bundle:nil] forCellReuseIdentifier:YRCaptureDetailCellID];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    
    return self.titleArr ? self.titleArr.count : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return MJScreenH * 0.24;
    }
    
    return UITableViewAutomaticDimension;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            YRCaptureDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:YRCaptureDetailCellID];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
            
        }
            break;
            
        case 1:
        {
            YRCapDetailTextCell *cell = [tableView dequeueReusableCellWithIdentifier:YRCapDetailTextCellID];
            
            if (indexPath.row < self.titleArr.count) {
                cell.detailItem = self.titleArr[indexPath.row];
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

#pragma mark-- 响应点击事件

- (void)captureDetailAppealBtnDidClick:(NSArray <NSString *>*)dataArr
{
    ZMJWeakSelf(self)
    
    UIAlertController *actionSheetController = [YRBasicVc addReportSheetControllerWithTitleArr:dataArr andName:@"报修" andPush:^(UIAlertAction * _Nonnull action) {
        
        YROtherThingsVc *thingVc = [[YROtherThingsVc alloc]init];
        
        [weakself.navigationController pushViewController:thingVc animated:YES];
        
    }];
    
    [self presentViewController:actionSheetController animated:YES completion:nil];
    
}

#pragma mark-- 懒加载假数据

- (NSArray *)titleArr
{
    if (!_titleArr) {
        NSArray *dataArr = @[
                      @{
                          @"contentDetail":@"如在游戏过程遇到如下问题\n1.画面黑屏或者定格\n2.操作按钮失灵\n3.爪子卡主不动了\n4.其他影响操作的问题\n可以申请退还游戏币,运营团队将尽快对你的申请作出回复",
                          @"titleName":@"申请退游戏币",
                          @"fixContentArr":@[
                              @"画面黑屏或定格",
                              @"操作按键失灵",
                              @"爪子卡住动不了",
                              @"其他影响操作的问题"
                              ]
                          },
                      @{
                          @"contentDetail":@"如在游戏过程遇到如下问题\n抓取成功系统判定失败\n可以申请退还游戏币,运营团队将尽快对你的申请作出回复",
                          @"titleName":@"申诉娃娃",
                          @"fixContentArr":@[
                              @"抓取成功系统判定失败",
                              @"其他情况",
                              ]
                          }
                     ];
        
        _titleArr = [YRCaptureDetailModel mj_objectArrayWithKeyValuesArray:dataArr];
    }
    
    return _titleArr;
}

@end
