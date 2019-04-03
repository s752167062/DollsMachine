//
//  MJSegmentVc.m
//  MJSegmentBar
//
//  Created by MJ on 2017/5/15.
//  Copyright © 2017年 MJ. All rights reserved.
//

#import "MJSegmentVc.h"




@interface MJSegmentVc ()<UIScrollViewDelegate , MJSegmentBarDelegate>

//内容View,装子控制器
@property (nonatomic, weak) UIScrollView *contentView;


@end

@implementation MJSegmentVc


#pragma mark - 懒加载

//bar头部条
- (MJSegmentBar *)segmentBar
{
    if (!_segmentBar) {
        
        MJSegmentBar *segmentBar = [MJSegmentBar segmentBarWithFrame:CGRectZero];
        segmentBar.delegate = self;
        segmentBar.backgroundColor = [UIColor brownColor];
        [self.view addSubview:segmentBar];
        _segmentBar = segmentBar;

    }
    
    return _segmentBar;
}

//装子控制器的scrollerView
- (UIScrollView *)contentView {
    if (!_contentView) {
        
        UIScrollView *contentView = [[UIScrollView alloc] init];
		if (@available(iOS 11.0, *))
		contentView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
		contentView.bounces = NO;
        contentView.delegate = self;
        contentView.pagingEnabled = YES;
        [self.view addSubview:contentView];
        _contentView = contentView;
    }
    return _contentView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	
	
}

- (void)setUpWithItems: (NSArray <NSString *>*)items childVCs: (NSArray <UIViewController *>*)childVCs
{
	//1.0处理间距
//	[self deleteAutoScrollViewInsets:childVCs];
	self.automaticallyAdjustsScrollViewInsets = NO;
	
    //1.数据过滤,当传过来的item个数和子控制个数不一致的时候
    NSAssert(items.count != 0 || items.count == childVCs.count, @"个数不一致, 请自己检查");
    
    //添加头部标题栏 , 同时懒加载segmentBar控件
    self.segmentBar.items = items;
    
    //先把之前的控制器从父控制器中移除
    [self.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
    
    // 添加几个自控制器
    // 在contentView, 展示子控制器的视图内容
    for (UIViewController *vc in childVCs) {
        [self addChildViewController:vc];
    }
	
    
    //根据子控制器的个数,设置scroller的contentSize
    self.contentView.contentSize = CGSizeMake(items.count * self.view.MJ_width, 0);
    
    //设置bar默认选择index
    self.segmentBar.selectIndex = 0;

	
}

//去掉自动滚动间距
- (void)deleteAutoScrollViewInsets:(NSArray <UIViewController *>*)childVCs
{
	if (@available(iOS 11.0, *)) {
		
		for (UIViewController * childVc in childVCs) {
			
			if ([childVc.view isKindOfClass:[UIScrollView class]])
			{
				
				UIScrollView *scrVc = (UIScrollView *)childVc.view;
				scrVc.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
			}
			
		}
		
	} else {
		self.automaticallyAdjustsScrollViewInsets = NO;
	}
	
}

//MARK:- 布局
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    //假如头部条在控件中,就自己设置其frame
    if (self.segmentBar.superview == self.view) {
        self.segmentBar.frame = CGRectMake(0, 0.0, self.view.MJ_width, Size(40.0, 40.0, 44.0));
        
        CGFloat contentViewY = self.segmentBar.MJ_y + self.segmentBar.MJ_height;
        CGRect contentFrame = CGRectMake(0, contentViewY, self.view.MJ_width, self.view.MJ_height - contentViewY);
        self.contentView.frame = contentFrame;
        self.contentView.contentSize = CGSizeMake(self.childViewControllers.count * self.view.MJ_width, 0);
		
		self.segmentBar.selectIndex = self.segmentBar.selectIndex;
        
        return;
    }
    
    
    CGRect contentFrame = CGRectMake(0, 0,self.view.MJ_width,self.view.MJ_height);
    self.contentView.frame = contentFrame;
    self.contentView.contentSize = CGSizeMake(self.childViewControllers.count * self.view.MJ_width, 0);
    
    
    // 其他的控制器视图, 大小
    // 遍历所有的视图, 重新添加, 重新进行布局
    // 注意: 1个视图
    //
    
    self.segmentBar.selectIndex = self.segmentBar.selectIndex;
    
}

#pragma mark - 选项卡代理方法
- (void)segmentBar:(MJSegmentBar *)segmentBar didSelectIndex:(NSInteger)toIndex fromIndex:(NSInteger)fromIndex
{
    NSLog(@"%zd----%zd", fromIndex, toIndex);
    [self showChildVCViewsAtIndex:toIndex];

}

//MARK:- 滚动到特定的控制器
- (void)showChildVCViewsAtIndex: (NSInteger)index {
    
    if (self.childViewControllers.count == 0 || index < 0 || index > self.childViewControllers.count - 1) {
        return;
    }
    
    UIViewController *vc = self.childViewControllers[index];
    vc.view.frame = CGRectMake(index * self.contentView.MJ_width, 0, self.contentView.MJ_width, self.contentView.MJ_height);
    [self.contentView addSubview:vc.view];
    
    // 滚动到对应的位置
    [self.contentView setContentOffset:CGPointMake(index * self.contentView.MJ_width, 0) animated:YES];
    
}

#pragma mark - UIScrollViewDelegate
//scroller滚动,跳动到对用的bar
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    // 计算最后的索引
    NSInteger index = self.contentView.contentOffset.x / self.contentView.MJ_width;
    
    //[self showChildVCViewsAtIndex:index];
    
    self.segmentBar.selectIndex = index;
    
}


@end
