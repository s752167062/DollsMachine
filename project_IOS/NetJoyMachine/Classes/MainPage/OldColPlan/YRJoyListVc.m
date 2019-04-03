//
//  YRJoyListVc.m
//  JoyMachine
//
//  Created by ZMJ on 2017/11/12.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRJoyListVc.h"
#import "YRJoyColCell.h"
#import "YRJoyAdvColCell.h"
//#import "YRAdvHeaderView.h"
#import "YRHouseColCell.h"
#import "UIResponder+Router.h"
#import "YRBannerModel.h"
#import "YRJoyGameVc.h"
#import "YRJoyListModel.h"


//一行col的个数
static CGFloat cols = 2;

//col中cell的行列间距
static CGFloat const margin = 10.0;

//大col的宽度
#define kleftColWidth (kScreenWidth - kLeftWidth - leftMargin * 2)

//单个col cell的宽度
#define cellWH ((MJScreenW - (cols + 1) * margin) / cols)


static NSString *const YRJoyColCellID = @"YRJoyColCellID";
static NSString *const YRJoyAdvColCellID = @"YRJoyAdvColCellID";
//static NSString *const YRAdvHeaderViewID = @"YRAdvHeaderViewID";
static NSString *const YRHouseColCellID = @"YRHouseColCellID";

@interface YRJoyListVc ()<UICollectionViewDataSource , UICollectionViewDelegate>



@property (nonatomic, strong) NSArray *srcStringArray;

@property (nonatomic, strong) NSArray *srcTitleArray;

@property (nonatomic, strong) NSDictionary *bannerDict;

//广告视图是否隐藏 默认为No 就是不隐藏
@property (nonatomic, assign) BOOL IsAdvCellHide;

@property (nonatomic, strong) YRBannerModel *bannerItem;

@end

@implementation YRJoyListVc




- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDefault];
    
    [self setupUI];
    
    
}

#pragma mark-- 设置默认值
- (void)setupDefault
{
    self.navigationController.title = @"主页";
    
    self.IsAdvCellHide = NO;
    
}

#pragma mark-- 初始化视图
- (void)setupUI
{
    [self.view addSubview:self.youColView];
    
    self.youColView.contentInset = UIEdgeInsetsMake(0, 0, MJSafeAreButtomH, 0);
    
    //colViewCell
    [self.youColView registerNib:[UINib nibWithNibName:NSStringFromClass([YRJoyColCell class]) bundle:nil] forCellWithReuseIdentifier:YRJoyColCellID];
    
    [self.youColView registerNib:[UINib nibWithNibName:NSStringFromClass([YRJoyAdvColCell class]) bundle:nil] forCellWithReuseIdentifier:YRJoyAdvColCellID];
    
    [self.youColView registerNib:[UINib nibWithNibName:NSStringFromClass([YRHouseColCell class]) bundle:nil] forCellWithReuseIdentifier:YRHouseColCellID];
    
    //colViewHeader
//    [self.youColView registerNib:[UINib nibWithNibName:NSStringFromClass([YRAdvHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:YRAdvHeaderViewID];
    
    
    
    //添加上下拉刷新
    [self addHeaderRefresh:self.youColView];
         
    [self addFooterRefresh:self.youColView];
    
//    self.youColView.mj_header.ignoredScrollViewContentInsetTop = 100;

//    self.youColView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0);
    
//    self.youColView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    //请求一次数据
    [self getRequestData];
    
}

- (void)getRequestData
{
    for (NSInteger i = 0; i < 4; i++) {
        
        YRJoyListModel *model = [YRJoyListModel new];
        
        [self.basicDataArr addObject:model];
    }
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.youColView reloadData];
        
        [self.youColView.mj_header endRefreshing];
        
        [self.youColView.mj_footer endRefreshing];
        
        
    });
    
}

//因为控制的ViewDidLoad方法在alloc的时候就创建了,而其视图的尺寸是懒加载的,所有需要在这里校准
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.youColView.frame = self.view.bounds;
    
}

#pragma mark-- ColView的代理和数据源方法



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
                
            break;
            
        case 1:
            return 1;
            break;
            
        case 2:
            return self.basicDataArr.count;
            break;
            
        default:
            return 0;
            break;
    }
    
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            YRJoyAdvColCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:YRJoyAdvColCellID forIndexPath:indexPath];
            
            if (self.srcStringArray) {
                
                cell.bannerItem = self.bannerItem;
            }
            
            
            return cell;
        }
            break;
            
        case 1:
        {
           
            YRHouseColCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:YRHouseColCellID forIndexPath:indexPath];
                
            return cell;
            
            
        }
            break;
            
        case 2:
        {
            YRJoyColCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:YRJoyColCellID forIndexPath:indexPath];
            
            return cell;
            
        }
            break;
            
        default:
        {
            return nil;
            
        }
            break;
    }
    
}

//cell的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
                if (self.bannerItem.isAdvClose)
                    return CGSizeMake(MJScreenW, 35.4);
                else
                    return CGSizeMake(MJScreenW, MJScreenH * 0.28);
        }
            break;
            
        case 1:
        {
            
            return CGSizeMake(MJScreenW, Size(40, 44, 50));
        }
            break;
            
        case 2:
        {
            
            
            return CGSizeMake(cellWH, cellWH);
        }
            break;
            
        default:
        {
            return CGSizeZero;
        }
            break;
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    YRJoyGameVc *gameVc = [[YRJoyGameVc alloc] init];
    
    [self.navigationController pushViewController:gameVc animated:YES];
    
}

#pragma mark-- 组头部设置

//返回组头部的视图
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//
//        switch (indexPath.section) {
//            case 1:
//                {
//                    YRAdvHeaderView *headerV = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:YRAdvHeaderViewID forIndexPath:indexPath];
//
//                    return headerV;
//
//                }
//                break;
//
//            default:
//                return nil;
//                break;
//        }
//
//    }
//    return nil;
//}

//返回每组cell的外边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    switch (section) {
        
        case 0:
            return UIEdgeInsetsMake(2, 0, 0, 0);
            break;
        
        case 2:
            return UIEdgeInsetsMake(10, 10, 10, 10);
            break;
            
        default:
            return UIEdgeInsetsZero;
            break;
    }
}


#pragma mark-- 所以响应事件
- (void)mainPage_sectionBtnDidClickedWithStatus:(BOOL)BtnStatus
{
//    self.IsAdvCellHide = BtnStatus;
    self.bannerItem.isAdvClose = BtnStatus;

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self.youColView reloadItemsAtIndexPaths:@[indexPath]];
}

- (void)mainPage_infiniteViewDidClickedWithUrlStr:(NSString *)jumpUrlStr
{
    UIViewController *vc = [[UIViewController alloc] init];
    
    vc.view.backgroundColor = [UIColor orangeColor];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark-- 假数据

- (NSArray *)srcStringArray
{
    if (!_srcStringArray) {
        _srcStringArray = @[
                            @"http://mpic.tiankong.com/dcd/965/dcd96596c1e6eb05da7dc58c3a01ecf3/640.jpg",
                            @"http://mpic.tiankong.com/99c/580/99c58020a1b531f42aa9a22270cd43cf/640.jpg",
                            @"http://mpic.tiankong.com/376/8c0/3768c0106c66f44459bf9e96ad5ccdef/640.jpg",
                            @"http://mpic.tiankong.com/cff/29e/cff29e9c9e7da0a5fa9618ed2126cea0/640.jpg",
                            @"http://mpic.tiankong.com/47e/c3f/47ec3f62c1bd3d8c061726818b771121/640.jpg",
                            @"http://mpic.tiankong.com/d50/573/d505739b0f05461add749c4889538d5d/640.jpg",
                            
                            ];
    }
    return _srcStringArray;
}

- (NSArray *)srcTitleArray
{
    if (!_srcTitleArray) {
        _srcTitleArray = @[
                           @"Super萌萌哒小迷鹿",
                           @"蓝色星球星际宝贝",
                           @"酷炫十足钢铁侠",
                           @"限量版海王贼手办",
                           @"一堆娃娃",
                           @"蜜汁自信小狗狗"
                           ];
    }
    return _srcTitleArray;
}

- (NSDictionary *)bannerDict
{
    if (!_bannerDict) {
        _bannerDict = @{
                        @"bannerImgArr":@[
                                @"http://mpic.tiankong.com/dcd/965/dcd96596c1e6eb05da7dc58c3a01ecf3/640.jpg",
                                @"http://mpic.tiankong.com/99c/580/99c58020a1b531f42aa9a22270cd43cf/640.jpg",
                                @"http://mpic.tiankong.com/376/8c0/3768c0106c66f44459bf9e96ad5ccdef/640.jpg",
                                @"http://mpic.tiankong.com/cff/29e/cff29e9c9e7da0a5fa9618ed2126cea0/640.jpg",
                                @"http://mpic.tiankong.com/47e/c3f/47ec3f62c1bd3d8c061726818b771121/640.jpg",
                                @"http://mpic.tiankong.com/d50/573/d505739b0f05461add749c4889538d5d/640.jpg",
                                
                                ],
                        @"advStrArr":@[
                                @"Super萌萌哒小迷鹿",
                                @"蓝色星球星际宝贝",
                                @"酷炫十足钢铁侠",
                                @"限量版海王贼手办",
                                @"一堆娃娃",
                                @"蜜汁自信小狗狗"
                                ],
                        @"isAdvClose":@0
                        
                        };
    }
    return _bannerDict;
}


@end
