//
//  YRJoyAdvColCell.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/14.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRJoyAdvColCell.h"
#import "SDCycleScrollView.h"
#import "UIResponder+Router.h"
#import "FlowerLabel.h"

@interface YRJoyAdvColCell()<SDCycleScrollViewDelegate>

//@property (nonatomic ,weak)SDCycleScrollView *InfiniteScrView;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;


@property (weak, nonatomic) IBOutlet SDCycleScrollView *InfiniteScrView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colH;


@property (weak, nonatomic) IBOutlet FlowerLabel *advLabel;

@end

@implementation YRJoyAdvColCell

//无尽的滚动视图
//- (SDCycleScrollView *)InfiniteScrView
//{
//    if (!_InfiniteScrView) {
//
//        SDCycleScrollView *cycleV = [SDCycleScrollView cycleScrollViewWithFrame:self.contentView.bounds delegate:self placeholderImage:[UIImage imageNamed:GoodsDetail_placeholderImage]];
//
//
//        [self.contentView addSubview:cycleV];
//
//        _InfiniteScrView = cycleV;
//
//    }
//    return _InfiniteScrView;
//}

#pragma mark-- 初始化

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
    
    }
    return self;
    
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    //初始化无限轮播视图
//    self.InfiniteScrView.autoScrollTimeInterval = 10.0;
    
    self.InfiniteScrView.delegate = self;
    
    self.InfiniteScrView.showPageControl = NO;
    
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    

    
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    
    self.InfiniteScrView.autoScrollTimeInterval = 2.0;
    
    //pageControl的显示和隐藏
    self.InfiniteScrView.showPageControl = NO;
    
    self.InfiniteScrView.contentMode = UIViewContentModeScaleAspectFit;
    
}

#pragma mark-- 设置数据
- (void)setBannerItem:(YRBannerModel *)bannerItem
{
    _bannerItem = bannerItem;
    
    
    
//    NSLog(@"当前页%zd",[self.InfiniteScrView valueForKeyPath:@"pageControl.currentPage"]);
    
    //设置按钮选中状态
    self.closeBtn.selected = bannerItem.isAdvClose;
    
    self.InfiniteScrView.imageURLStringsGroup = bannerItem.bannerImgArr;
    
    self.InfiniteScrView.placeholderImage = [UIImage imageNamed:@"beijing_xiongmao"];
    
    ZMJWeakSelf(self)
    if (bannerItem.isAdvClose) {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            weakself.InfiniteScrView.alpha = 0;
        }];
        
    }else{
        
        [UIView animateWithDuration:0.5 animations:^{
            
            weakself.InfiniteScrView.alpha = 1.0;
        }];
    }
    
    self.advLabel.text = bannerItem.advStrArr.firstObject;
    
//    [self cycleScrollView:self.InfiniteScrView didScrollToIndex:0];
    
}

#pragma mark-- 滚动视图的代理方法
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    if (index < self.bannerItem.advStrArr.count) {
        
        self.advLabel.text = self.bannerItem.advStrArr[index];
    }
    
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
//    [self mainPage_infiniteViewDidClickedWithUrlStr:@"https://www.baidu.com"];
    
//    self.InfiniteScrView.hidden = YES;
    
}

//banner打开和关闭
- (IBAction)closeBtnDidClicked:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    NSLog(@"%zd",sender.isSelected);
    
    
    [self mainPage_sectionBtnDidClickedWithStatus:sender.selected];
    
}



@end
