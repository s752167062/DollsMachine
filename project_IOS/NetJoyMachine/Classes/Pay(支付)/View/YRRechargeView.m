//
//  YRRechargeView.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/16.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRRechargeView.h"
#import "YRRechargeColCell.h"
#import "YRRechargeColCell.h"
#import "UIView+TYAlertView.h"
#import "YRCoinPayVc.h"
#import "GCDAsyncSocketCommunicationManager.h"
#import "UserInfoTool.h"
#import "YRChargeCardModel.h"

//一行col的个数
static CGFloat cols = 2;

//col中cell的行列间距
static CGFloat const margin = 30.0;


@interface YRRechargeView()<UICollectionViewDataSource , UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleL;


@property (weak, nonatomic) IBOutlet UICollectionView *colView;

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (nonatomic, copy) NSMutableArray *coinArr;

@end

@implementation YRRechargeView

- (NSMutableArray *)coinArr
{
    if (!_coinArr) {
        _coinArr = [NSMutableArray array];
    }
    return _coinArr;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.MJ_width = YRAlert_Relative_Width;
    
    self.MJ_height = YRAlert_Relative_Height;
    
    _titleL.font = MJBlodTitleFont;
    
 
    [self.colView registerNib:[UINib nibWithNibName:NSStringFromClass([YRRechargeColCell class]) bundle:nil] forCellWithReuseIdentifier:YRRechargeColCellID];
    
    [self layoutIfNeeded];
    
    UICollectionViewFlowLayout *colLayout = [[UICollectionViewFlowLayout alloc] init];
    
    CGFloat cellW = ((self.colView.MJ_width - (cols - 1) * margin) / cols) ;
    
    colLayout.itemSize = CGSizeMake(cellW, cellW * 1.25);
    
    self.colView.collectionViewLayout = colLayout;
    
    [self.backView setCornerRadius:12.0];
    
    //获取数据
    [self getRechargeRequest];
}

#pragma mark-- 获取数据
- (void)getRechargeRequest
{
    NSString *userId = [UserInfoTool getUserDefaultKey:UserDefault_UserID];
    
    [SVProgressHUD showWithStatus:YR_Hint_Refreshing];
    [[GCDAsyncSocketCommunicationManager sharedInstance] socketWriteDataWithRequestType:GACRequestType_SendRecharge_List requestBody:@{@"userId":userId ? :@"zz"} completion:^(NSError * _Nullable error, id  _Nullable data) {
        
        NSLog(@"错误:%@数据:%@",error,data);
        [SVProgressHUD dismiss];
        
        if (error || !data) {
            [SVProgressHUD showErrorWithStatus:@"网络繁忙"];
            return;
        }
        
        self.coinArr = [YRChargeCardModel mj_objectArrayWithKeyValuesArray:data[@"cardList"]];
        
        [self.colView reloadData];
        
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.coinArr ? self.coinArr.count : 0;
    
}

static NSString *YRRechargeColCellID = @"YRRechargeColCellID";

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YRRechargeColCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:YRRechargeColCellID forIndexPath:indexPath];
    
    if (indexPath.row < self.coinArr.count) {
        
        cell.cardItem = self.coinArr[indexPath.row];
    }
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self hideView];
    
    if ([self.delegate respondsToSelector:@selector(RechargeViewCellDidClick)]) {
        [self.delegate RechargeViewCellDidClick];
    }
    
}


@end
