//
//  UINavigationBar+HJChangeBarColor.m
//  JDH-Store
//
//  Created by ZMJ on 2017/9/13.
//  Copyright © 2017年 HuiJia. All rights reserved.
//

#import "UINavigationBar+HJChangeBarColor.h"

@interface UINavigationBar()

//@property(nonatomic , weak) UIImageView * shadowImg;

@end

@implementation UINavigationBar (HJChangeBarColor)

static UIImageView *shadowImg = nil;

- (void)HJ_star {
	shadowImg = [self findNavLineImageViewOn:self];
	shadowImg.hidden = YES;
	[self setBackgroundColor:nil];
}

- (void)HJ_changeColor:(UIColor *)color WithScrollView:(UIScrollView *)scrollView AndValue:(CGFloat)value {
	
//	NSLog(@"%f",scrollView.contentOffset.y);
	
	if (scrollView.contentOffset.y < 0) {
		//下拉时导航栏隐藏
		self.hidden = YES;
	}else {
		self.hidden = NO;
		//计算透明度
		CGFloat alpha = scrollView.contentOffset.y /30.0 >0.95f ? 0.95 : scrollView.contentOffset.y / 30.0;

		
		if (alpha >= 0.95) {
			
			if (BarChanged) {
    
				BarChanged(YES);
			}
			shadowImg.hidden = NO;
		}else{
			shadowImg.hidden = YES;
			
			if (BarChanged) {
    
				BarChanged(NO);
			}

		}
		//设置一个颜色并转化为图片
		UIImage *image = [self imageWithColor:[color colorWithAlphaComponent:alpha]];
		[self setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
	}
}

static void(^BarChanged)(BOOL overflow);

- (void)HJ_resloveBarChangesEvent:(void(^)(BOOL overflow)) BarStatusChanged
{
	BarChanged = BarStatusChanged;
}

- (void)HJ_reset {
	
	shadowImg.hidden = NO;
	[self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

//寻找导航栏下的横线
- (UIImageView *)findNavLineImageViewOn:(UIView *)view {
	if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
		return (UIImageView *)view;
	}
	for (UIView *subview in view.subviews) {
		UIImageView *imageView = [self findNavLineImageViewOn:subview];
		if (imageView) {
			return imageView;
		}
	}
	return nil;
}

#pragma mark - Color To Image
- (UIImage *)imageWithColor:(UIColor *)color {
	//创建1像素区域并开始图片绘图
	CGRect rect = CGRectMake(0, 0, 1, 1);
	UIGraphicsBeginImageContext(rect.size);
	
	//创建画板并填充颜色和区域
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context, [color CGColor]);
	CGContextFillRect(context, rect);
	
	//从画板上获取图片并关闭图片绘图
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return image;
}



@end
