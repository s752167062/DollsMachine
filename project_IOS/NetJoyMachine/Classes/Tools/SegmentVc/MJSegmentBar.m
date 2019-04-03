//
//  MJSegmentBar.m
//  MJSegmentBar
//
//  Created by MJ on 2017/5/15.
//  Copyright © 2017年 MJ. All rights reserved.
//

#import "MJSegmentBar.h"


#define kMinMargin 30

@interface MJSegmentBar()
{
    // 记录最后一次点击的按钮
    UIButton *_lastBtn;
}

/** 内容承载视图 */
@property (nonatomic, weak) UIScrollView *contentView;

/** 添加的按钮数据 */
@property (nonatomic, strong) NSMutableArray <UIButton *>*itemBtns;

/** 指示器 */
@property (nonatomic, weak) UIView *indicatorView;
@property (nonatomic, strong) MJSegmentBarConfig *config;

@end



@implementation MJSegmentBar

//MARK:- 懒加载

//按钮的个数数组
- (NSMutableArray<UIButton *> *)itemBtns {
    if (!_itemBtns) {
        _itemBtns = [NSMutableArray array];
    }
    return _itemBtns;
}

//配置信息
- (MJSegmentBarConfig *)config {
    if (!_config) {
        _config = [MJSegmentBarConfig defaultConfig];
    }
    return _config;
}

//内容的滚动视图
- (UIScrollView *)contentView {
    if (!_contentView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.showsHorizontalScrollIndicator = NO;
		if (@available(iOS 11.0, *))
		{
			scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
			
			scrollView.scrollIndicatorInsets = scrollView.contentInset;
		}
        [self addSubview:scrollView];
        _contentView = scrollView;
    }
    return _contentView;
}

//指示器
- (UIView *)indicatorView {
    if (!_indicatorView) {
        CGFloat indicatorH = self.config.indicatorHeight;
        UIView *indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, self.MJ_height - indicatorH, 0, indicatorH)];
        indicatorView.backgroundColor = self.config.indicatorColor;
        [self.contentView addSubview:indicatorView];
        _indicatorView = indicatorView;
    }
    return _indicatorView;
}

#pragma mark - 接口
+ (instancetype)segmentBarWithFrame: (CGRect)frame {
    MJSegmentBar *segmentBar = [[MJSegmentBar alloc] initWithFrame:frame];
    
    // 添加内容承载视图
    return segmentBar;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = self.config.segmentBarBackColor;
    }
    return self;
}

//MARK:- 设置样式配置信息
- (void)updateWithConfig: (void(^)(MJSegmentBarConfig *config))configBlock {
    
    if (configBlock) {
        configBlock(self.config);
    }
    
    // 按照当前的 self.config 进行刷新
    self.backgroundColor = self.config.segmentBarBackColor;
    
    for (UIButton *btn in self.itemBtns) {
        [btn setTitleColor:self.config.itemNormalColor forState:UIControlStateNormal];
        [btn setTitleColor:self.config.itemSelectColor forState:UIControlStateSelected];
        
        [self updateBtnStatusFont:btn];
    }
    
    // 指示器
    self.indicatorView.backgroundColor = self.config.indicatorColor;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    
}

#pragma mark- (按钮不同状态下的文字大小)
- (void)updateBtnStatusFont:(UIButton *)btn
{
    if (!btn.selected)
        btn.titleLabel.font = self.config.itemNormalFont;
    else
        btn.titleLabel.font = self.config.itemSelectFont;

}

- (void)setItems:(NSArray<NSString *> *)items
{
    _items = items;
    
    // 删除之前添加过多额组件 makeObjectsPerformSelector数组中的每个元素都执行某个方法
    [self.itemBtns makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.itemBtns = nil;

    // 根据所有的选项数据源， 创建Button, 添加到内容视图
    for (NSString *item in items) {
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = self.itemBtns.count;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        [btn setTitleColor:self.config.itemNormalColor forState:UIControlStateNormal];
        [btn setTitleColor:self.config.itemSelectColor forState:UIControlStateSelected];
        [self updateBtnStatusFont:btn];
        [btn setTitle:item forState:UIControlStateNormal];
        [self.contentView addSubview:btn];
        [self.itemBtns addObject:btn];
//        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    }

    // 手动刷新布局
    [self setNeedsLayout];
    [self layoutIfNeeded];

}

#pragma mark - bar中按钮的点击
- (void)btnClick:(UIButton *)btn {
    
    if ([self.delegate respondsToSelector:@selector(segmentBar:didSelectIndex:fromIndex:)]) {
        [self.delegate segmentBar:self didSelectIndex:btn.tag fromIndex:_lastBtn.tag];
    }
    
    _selectIndex = btn.tag;
    
    _lastBtn.selected = NO;

    btn.selected = YES;
  
    _lastBtn = btn;
    
    [UIView animateWithDuration:0.1 animations:^{
        self.indicatorView.MJ_width = btn.MJ_width + self.config.indicatorExtraW * 2;
        self.indicatorView.MJ_centerX = btn.MJ_centerX;
        
    }];
    
    
    // 1. 县滚动到btn的位置
    
    CGFloat scrollX = btn.MJ_centerX - self.contentView.MJ_width * 0.5;
    
    if (scrollX < 0) {
        scrollX = 0;
    }
    if (scrollX > self.contentView.contentSize.width - self.contentView.MJ_width) {
        scrollX = self.contentView.contentSize.width - self.contentView.MJ_width;
    }
    
    [self.contentView setContentOffset:CGPointMake(scrollX, 0) animated:YES];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
}

#pragma mark - 布局
- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
    
    // 计算margin
    CGFloat totalBtnWidth = 0;
    for (UIButton *btn in self.itemBtns) {
        [self updateBtnStatusFont:btn];
        [btn sizeToFit];
        totalBtnWidth += btn.MJ_width;
    }
    
    CGFloat caculateMargin = (self.MJ_width - totalBtnWidth) / (self.items.count + 1);
    if (caculateMargin < kMinMargin) {
        caculateMargin = kMinMargin;
    }
    
    
    CGFloat lastX = caculateMargin;
    for (UIButton *btn in self.itemBtns) {
        // w, h
        [btn sizeToFit];
        // y 0
        // x, y,
        btn.MJ_y = 0;
        
        btn.MJ_x = lastX;
		
        //给btn高度,不然让按钮sizeToFit的话,其文字会显示在底部
        btn.MJ_height = self.MJ_height - self.config.indicatorHeight;
        
        lastX += btn.MJ_width + caculateMargin;
        
        
        
    }
    
    self.contentView.contentSize = CGSizeMake(lastX, 0);
    
    if (self.itemBtns.count == 0) {
        return;
    }
    UIButton *btn = self.itemBtns[self.selectIndex];
    self.indicatorView.MJ_width = btn.MJ_width + self.config.indicatorExtraW * 2;
    self.indicatorView.MJ_centerX = btn.MJ_centerX;
    self.indicatorView.MJ_height = self.config.indicatorHeight;
    self.indicatorView.MJ_y = self.MJ_height - self.indicatorView.MJ_height - 6.0;
}

//MARK:- 设置头部视图的选择项
- (void)setSelectIndex:(NSInteger)selectIndex {
    // 数据过滤
    if (self.itemBtns.count == 0 || selectIndex < 0 || selectIndex > self.itemBtns.count - 1) {
        return;
    }
    _selectIndex = selectIndex;
    UIButton *btn = self.itemBtns[selectIndex];
    [self btnClick:btn];
}


@end
