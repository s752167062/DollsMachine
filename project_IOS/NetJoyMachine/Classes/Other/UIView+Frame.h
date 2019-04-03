//
//  UIView+Frame.h
//  01-BuDeJie
//
//  Created by MJ on 16/1/18.
//  Copyright © 2016年 xiaomage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

//又可以是左
@property CGFloat MJ_x;
//又是上
@property CGFloat MJ_y;
@property CGFloat MJ_width;
@property CGFloat MJ_height;
@property CGFloat MJ_centerX;
@property CGFloat MJ_centerY;
@property CGFloat MJ_bottom;
@property CGFloat MJ_right;

/**
 *  判断self和view是否重叠
 */
- (BOOL)MJ_intersectWithView:(UIView *)view;

// 从nib文件中装载view
+ (id) loadFromNibNamed:(NSString*)name isKindOf:(Class)cls;
+ (id) loadFromNibNamed:(NSString*)name;
+ (id) loadFromNib;


// AutoLayout

- (NSLayoutConstraint *)addWidthConstraint:(CGFloat)width;

- (NSLayoutConstraint *)addHeightConstraint:(CGFloat)height;

- (void)addFlexibleWidthConstraintToView:(UIView *)view margin:(CGFloat)margin;

- (void)addFlexibleHeightConstraintToView:(UIView *)view margin:(CGFloat)margin;

- (void)addFlexibleWidthConstraintToView:(UIView *)view leftMargin:(CGFloat)leftMargin rightMargin:(CGFloat)rightMargin;

- (void)addFlexibleHeightConstraintToView:(UIView *)view topMargin:(CGFloat)topMargin bottomMargin:(CGFloat)bottomMargin;

- (void)addFlexibleFullConstraintToView:(UIView *)view top:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;

- (void)addStayTopConstraintToView:(UIView *)view height:(CGFloat)height;

- (void)addStayBottomConstraintToView:(UIView *)view height:(CGFloat)height;

// Layer

/// 设置圆角
- (void)setCornerRadius:(CGFloat)radius;
/// 设置圆角（指定角）
- (void)setCornerRadius:(CGFloat)radius atRectCorner:(UIRectCorner)corners;
/// 设置圆角（指定角）
- (void)setCornerRadius:(CGFloat)radius atRectCorner:(UIRectCorner)corners withFrame:(CGRect)frame;
/// 设置边框
- (void)setBoarderWidth:(CGFloat)width color:(UIColor *)color;
/// 设置虚线边框，lineDashPattern:@[@4,@2],虚线小段长度,虚线间隙
- (void)setBoarderWidth:(CGFloat)width color:(UIColor *)color lineDashPattern:(NSArray *)lineDashPattern;

//快速从xib中加载View
+ (instancetype)MJ_viewFromXib;
@end
