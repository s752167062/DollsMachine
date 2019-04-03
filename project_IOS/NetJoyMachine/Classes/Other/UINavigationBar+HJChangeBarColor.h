//
//  UINavigationBar+HJChangeBarColor.h
//  JDH-Store
//
//  Created by ZMJ on 2017/9/13.
//  Copyright © 2017年 HuiJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (HJChangeBarColor)


/**
 *  隐藏导航栏下的横线，背景色置空
 */
- (void)HJ_star;

/**
 *  @param color 最终显示颜色
 *  @param scrollView 当前滑动视图
 *  @param value 滑动临界值，依据需求设置
 */
- (void)HJ_changeColor:(UIColor *)color WithScrollView:(UIScrollView *)scrollView AndValue:(CGFloat)value;

/**
 *  还原导航栏
 */
- (void)HJ_reset;


/**
 滚动视图事件传递

 @param BarStatusChanged 需要做个事
 */
- (void)HJ_resloveBarChangesEvent:(void(^)(BOOL overflow)) BarStatusChanged;





@end
