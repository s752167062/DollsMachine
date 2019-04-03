//
//  YRJoyListCell.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/22.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRJoyListCell.h"
#import "YRJoyColCell.h"
#import "YRJoyListModel.h"
#import "YRMainConst.h"
#import "UIResponder+Router.h"
#import "TYShowAlertView.h"
#import "YRMyAlertView.h"
#import "YRZegoRoomModel.h"
#import "YRJoyPlayRoomModel.h"

@interface YRJoyListCell()<UICollectionViewDataSource , UICollectionViewDelegate>

//@property (weak, nonatomic) IBOutlet UICollectionView *colView;
@property(nonatomic , weak) UICollectionView *colView;

//@property (nonatomic, weak) UICollectionViewFlowLayout *colLayout;

@end

@implementation YRJoyListCell

#pragma mark-- 懒加载
- (UICollectionView *)colView
{
    if (!_colView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        layout.minimumLineSpacing = MainPage_margin;
        
        layout.minimumInteritemSpacing = MainPage_margin;
        
        //colView的边距
        layout.sectionInset = UIEdgeInsetsMake(MainPage_margin, MainPage_margin, MainPage_margin, MainPage_margin);
        
        layout.itemSize = CGSizeMake(MainPage_colCellWH, MainPage_colCellWH);
        
        
        UICollectionView *col = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        
        col.backgroundColor = MJEBGrayColor;
        
        col.dataSource = self;
        
        col.delegate = self;
        
        [col registerNib:[UINib nibWithNibName:NSStringFromClass([YRJoyColCell class]) bundle:nil] forCellWithReuseIdentifier:YRJoyColCellID];
        
        col.scrollEnabled = NO;
        [self.contentView addSubview:col];
        
        _colView = col;
        
    }
    return _colView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.colView.backgroundColor = MJMainGrayColor;
    
    self.colView.scrollEnabled = NO;
    
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.colView.frame = self.contentView.bounds;
}

- (void)setRoomArr:(NSArray *)roomArr
{
    _roomArr = roomArr;
    
    [self.colView reloadData];
}

static NSString *const YRJoyColCellID = @"YRJoyColCellID";

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.roomArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    YRJoyColCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:YRJoyColCellID forIndexPath:indexPath];
    
    if (indexPath.row < self.roomArr.count) {
        
        cell.roomItem = self.roomArr[indexPath.row];
    }
            
    return cell;
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > self.roomArr.count - 1) return;
    
    [self mainPage_joyColDidClickedWithStatus:indexPath];
    
}



@end
