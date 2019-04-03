//
//  YRJoyBoxVc.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/19.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRJoyBoxVc.h"
#import "YRJoyBoxColCell.h"
#import "YRMyPrizeVc.h"
#import "YRJoyPrizeDetail.h"

@interface YRJoyBoxVc ()

@end

@implementation YRJoyBoxVc

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setupDefault];
    
    [self setupUI];
    
}

//MARK:- 设置默认信息
- (void)setupDefault
{
    self.title = @"娃娃盒";
    
    
}

//MARK:- 设置UI
- (void)setupUI
{
    [self.view addSubview:self.private_MsgHeaderV];
    
    
    [self.view addSubview:self.youColView];
    
    
    self.youColView.frame = CGRectMake(0, self.private_MsgHeaderV.MJ_bottom, MJScreenW, MJScreenH - self.private_MsgHeaderV.MJ_height );
    
   UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.youColView.collectionViewLayout;
    
    layout.itemSize = CGSizeMake(MJ_cellWH, MJ_cellWH * 1.4);
    
    [self.youColView registerNib:[UINib nibWithNibName:NSStringFromClass([YRJoyBoxColCell class]) bundle:nil] forCellWithReuseIdentifier:YRJoyBoxColCellID];
    
    //添加右侧barItem
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem mj_addRightBarButtonItemWithTitle:@"我的奖品" andTarget:self action:@selector(rightBarBtnDidClicked)];
    
}



- (void)rightBarBtnDidClicked
{
    YRMyPrizeVc *prizeVc = [[YRMyPrizeVc alloc] init];
    
    [self.navigationController pushViewController:prizeVc animated:YES];
    
}

static NSString *YRJoyBoxColCellID = @"YRJoyBoxColCellID";

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YRJoyBoxColCell *colCell = [collectionView dequeueReusableCellWithReuseIdentifier:YRJoyBoxColCellID forIndexPath:indexPath];
    
    return colCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    YRJoyPrizeDetail *detailVc = [[YRJoyPrizeDetail alloc] init];
    
    [self.navigationController pushViewController:detailVc animated:YES];
    
}


    
@end
