//
//  YRGoldCoinVc.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/16.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRGoldCoinVc.h"
#import "YRYRGoldCoinColCell.h"
#import "YRCoinAlertView.h"
#import "UIView+TYAlertView.h"

//一行col的个数
static CGFloat cols = 2;

//col中cell的行列间距
static CGFloat const margin = 10.0;

//大col的宽度
#define kleftColWidth (kScreenWidth - kLeftWidth - leftMargin * 2)

//单个col cell的宽度
#define cellWH ((MJScreenW - (cols + 1) * margin) / cols)

@interface YRGoldCoinVc ()<UICollectionViewDataSource , UICollectionViewDelegate>

@property(nonatomic , weak) UICollectionView *colView;

//头像
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;


@property (weak, nonatomic) IBOutlet UILabel *nameL;

@property (weak, nonatomic) IBOutlet UIButton *numL;



@end

@implementation YRGoldCoinVc

#pragma mark-- 懒加载
- (UICollectionView *)colView
{
    if (!_colView) {

        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];

        UICollectionView *col = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 60.0 , MJScreenW, MJScreenH - 60.0 - MJNavMaxY - MJSafeAreButtomH) collectionViewLayout:flowLayout];
        
        col.backgroundColor = [UIColor clearColor];

        col.dataSource = self;

        col.delegate = self;

        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;

        flowLayout.minimumLineSpacing = margin;

        flowLayout.minimumInteritemSpacing = margin;
        
        //colView的边距
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);

        flowLayout.itemSize = CGSizeMake(cellWH, cellWH);


        [self.view addSubview:col];

        _colView = col;

    }
    return _colView;
}

static NSString *const YRYRGoldCoinColCellID = @"YRYRGoldCoinColCellID";

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupDefault];

    [self setupUI];


}

#pragma mark-- 设置默认值
- (void)setupDefault
{
    self.title = @"金币兑换";
    
    self.nameL.font = MJBlodMiddleBobyFont;
    self.nameL.textColor = MJWhiteColor;
    
    self.numL.titleLabel.font = MJBlodMiddleBobyFont;

}

#pragma mark-- 初始化视图
- (void)setupUI
{
    [self.colView registerNib:[UINib nibWithNibName:NSStringFromClass([YRYRGoldCoinColCell class]) bundle:nil] forCellWithReuseIdentifier:YRYRGoldCoinColCellID];

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 7;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YRYRGoldCoinColCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:YRYRGoldCoinColCellID forIndexPath:indexPath];

    return cell;

}

//colCell的点击
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    YRCoinAlertView *coinView = [YRCoinAlertView createViewFromNib];

    coinView.autoresizingMask = UIViewAutoresizingNone;
    
    [coinView showInController:self preferredStyle:TYAlertControllerStyleAlert transitionAnimation:TYAlertTransitionAnimationFade backgoundTapDismissEnable:YES];
}


@end
