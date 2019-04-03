//
//  YRMainHeaderV.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/22.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRMainHeaderV.h"
#import "SDCycleScrollView.h"
#import "UIResponder+Router.h"
#import "YRBannerModel.h"
#import "FlowerLabel.h"
#import "YRMainConst.h"

@interface YRMainHeaderV()<SDCycleScrollViewDelegate>

@property (nonatomic, weak) FlowerLabel *advL;

@property (nonatomic, weak) UIButton *openBtn;

@property (nonatomic, weak) SDCycleScrollView *InfiniteScrView;

@end

@implementation YRMainHeaderV

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setupDefault];
        
        [self setupUI];
        
    }
    return self;
    
}

#pragma mark-- 设置默认值
- (void)setupDefault
{
    
    
}



#pragma mark-- 初始化视图
- (void)setupUI
{
    //headerView
    UIView *backHeaderV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.MJ_width, MainPage_BarH)];
    
    backHeaderV.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:backHeaderV];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGFloat btn_y = 0.0;
    
    CGFloat rlMargin = 12.0;
    
    CGFloat btnWH = backHeaderV.MJ_height - 2 * btn_y;
    
    btn.frame = CGRectMake(self.MJ_width - btnWH - rlMargin , btn_y, btnWH, btnWH);
    
    [btn setImage:[UIImage imageNamed:@"guanggao_zhankai_button_Top"] forState:UIControlStateNormal];
    
    [btn setImage:[UIImage imageNamed:@"guanggao_zhankai_button"] forState:UIControlStateSelected];
    
    [btn addTarget:self action:@selector(openBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.openBtn = btn;
    
    [backHeaderV addSubview:btn];
    
    //广告label
    FlowerLabel *label = [[FlowerLabel alloc] init];
    
    label.text = @"呵呵呵呵呵呵呵";
    
    label.textColor = [UIColor whiteColor];
    
    label.textAlignment = NSTextAlignmentCenter;
    
    label.frame = backHeaderV.bounds;
    
    [backHeaderV addSubview:label];
    
    self.advL = label;
    
    //滚动广告视图
    SDCycleScrollView *cycleV = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, backHeaderV.MJ_bottom, self.MJ_width, self.MJ_height - backHeaderV.MJ_bottom) delegate:self placeholderImage:[UIImage imageNamed:@"guanggaolan_jiazai"]];
    
    [self addSubview:cycleV];
    
    self.InfiniteScrView = cycleV;

}

- (void)openBtnDidClicked:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    self.barItem.isAdvClose = btn.selected;
    
    self.InfiniteScrView.showPageControl = !self.barItem.isAdvClose;
    
    if (self.barItem.isAdvClose) {
        self.InfiniteScrView.MJ_height = 0.001;
       
        
    }else{
        
        self.InfiniteScrView.MJ_height = MainPage_BarAdvScrVH;
    }
    
    [self mainPage_sectionBtnDidClickedWithStatus:self.barItem.isAdvClose];
}



- (void)setBarItem:(YRBannerModel *)barItem
{
    _barItem = barItem;
    
    self.advL.text = barItem.advStrArr.firstObject ? : @"公告";
    
    self.InfiniteScrView.showPageControl = !self.barItem.isAdvClose;
    
    self.openBtn.selected = barItem.isAdvClose;
    
    self.InfiniteScrView.imageURLStringsGroup = barItem.bannerImgArr;
}


- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    if (index > self.barItem.advStrArr.count - 1) return;
    
    self.advL.text = self.barItem.advStrArr[index];
}

#pragma mark-- 图片点击回调
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (index > self.barItem.redirectArr.count - 1) return;
    
    [self mainPage_infiniteViewDidClickedWithUrlStr:self.barItem.redirectArr[index]];
}

@end
