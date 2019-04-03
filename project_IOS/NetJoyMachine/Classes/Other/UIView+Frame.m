//
//  UIView+Frame.m
//  01-BuDeJie
//
//  Created by MJ on 16/1/18.
//  Copyright © 2016年 xiaomage. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (BOOL)MJ_intersectWithView:(UIView *)view
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    
    CGRect rect1 = [self convertRect:self.bounds toView:nil];
    CGRect rect2 = [view convertRect:view.bounds toView:nil];
    return CGRectIntersectsRect(rect1, rect2);
}

- (CGFloat)MJ_height
{
    return self.frame.size.height;
}
- (void)setMJ_height:(CGFloat)MJ_height
{
    CGRect frame = self.frame;
    frame.size.height = MJ_height;
    self.frame = frame;
}
- (CGFloat)MJ_width
{
     return self.frame.size.width;
}

- (void)setMJ_width:(CGFloat)MJ_width
{
    CGRect frame = self.frame;
    frame.size.width = MJ_width;
    self.frame = frame;
}

- (void)setMJ_x:(CGFloat)MJ_x
{
    CGRect frame = self.frame;
    frame.origin.x = MJ_x;
    self.frame = frame;

}
- (CGFloat)MJ_x
{
    return self.frame.origin.x;
}

- (void)setMJ_y:(CGFloat)MJ_y
{
    CGRect frame = self.frame;
    frame.origin.y = MJ_y;
    self.frame = frame;
}
- (CGFloat)MJ_y
{
    return self.frame.origin.y;
}

- (void)setMJ_centerX:(CGFloat)MJ_centerX
{
    CGPoint center = self.center;
    center.x = MJ_centerX;
    self.center = center;
}
- (CGFloat)MJ_centerX
{
    return self.center.x;
}
- (void)setMJ_centerY:(CGFloat)MJ_centerY
{
    CGPoint center = self.center;
    center.y = MJ_centerY;
    self.center = center;
}
- (CGFloat)MJ_centerY
{
    return self.center.y;
}

- (void)setMJ_bottom:(CGFloat)MJ_bottom
{
	CGRect frame = self.frame;
	frame.origin.y = MJ_bottom - frame.size.height;
	self.frame = frame;
}

- (CGFloat)MJ_bottom
{
	return self.frame.origin.y + self.frame.size.height;
}

- (void)setMJ_right:(CGFloat)MJ_right
{
	CGRect frame = self.frame;
	frame.origin.x = MJ_right - frame.size.width;
	self.frame = frame;
}

- (CGFloat)MJ_right
{
	return self.frame.origin.x + self.frame.size.width;
}

#pragma mark- (从nib文件中装载view)
+ (id) loadFromNibNamed:(NSString*)name isKindOf:(Class)cls
{
    NSArray* array = [[NSBundle mainBundle] loadNibNamed:name owner:nil options:0];
    for (NSObject* object in array)
    {
        if ([object isKindOfClass:cls])
        {
            return object;
        }
    }
    return nil;
}

+ (id) loadFromNibNamed:(NSString*)name
{
    return [self loadFromNibNamed:name isKindOf:self];
}

+ (id) loadFromNib
{
    NSString* clsName = NSStringFromClass(self);
    return [self loadFromNibNamed:clsName isKindOf:self];
}

#pragma mark- (AutoLayout)

- (NSLayoutConstraint *)addWidthConstraint:(CGFloat)width
{
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:width];
    [self addConstraint:widthConstraint];
    return widthConstraint;
}

- (NSLayoutConstraint *)addHeightConstraint:(CGFloat)height
{
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:height];
    [self addConstraint:heightConstraint];
    return heightConstraint;
}

- (void)addFlexibleWidthConstraintToView:(UIView *)view margin:(CGFloat)margin
{
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[view]-margin-|" options:0 metrics:@{@"margin": [NSNumber numberWithDouble:margin]} views:@{@"view":view}]];
}

- (void)addFlexibleHeightConstraintToView:(UIView *)view margin:(CGFloat)margin
{
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[view]-margin-|" options:0 metrics:@{@"margin": [NSNumber numberWithDouble:margin]} views:@{@"view":view}]];
}

- (void)addFlexibleWidthConstraintToView:(UIView *)view leftMargin:(CGFloat)leftMargin rightMargin:(CGFloat)rightMargin
{
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-left-[view]-right-|" options:0 metrics:@{@"left": [NSNumber numberWithDouble:leftMargin], @"right": [NSNumber numberWithDouble:rightMargin]} views:@{@"view":view}]];
}

- (void)addFlexibleHeightConstraintToView:(UIView *)view topMargin:(CGFloat)topMargin bottomMargin:(CGFloat)bottomMargin
{
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-top-[view]-bottom-|" options:0 metrics:@{@"top": [NSNumber numberWithDouble:topMargin], @"bottom": [NSNumber numberWithDouble:bottomMargin]} views:@{@"view":view}]];
}

- (void)addFlexibleFullConstraintToView:(UIView *)view top:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left
{
    [self addFlexibleWidthConstraintToView:view leftMargin:left rightMargin:right];
    [self addFlexibleHeightConstraintToView:view topMargin:top bottomMargin:bottom];
}

- (void)addStayTopConstraintToView:(UIView *)view height:(CGFloat)height
{
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:@{@"view": view}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view(height)]" options:0 metrics:@{@"height":[NSNumber numberWithDouble:height]} views:@{@"view":view}]];
}

- (void)addStayBottomConstraintToView:(UIView *)view height:(CGFloat)height;
{
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:@{@"view": view}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(height)]-0-|" options:0 metrics:@{@"height":[NSNumber numberWithDouble:height]} views:@{@"view":view}]];
}

#pragma mark- (Layer)

/// 设置圆角
- (void)setCornerRadius:(CGFloat)radius
{
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

/// 设置圆角（指定角）
- (void)setCornerRadius:(CGFloat)radius atRectCorner:(UIRectCorner)corners
{
    [self setCornerRadius:radius atRectCorner:corners withFrame:self.bounds];
}

/// 设置圆角（指定角）
- (void)setCornerRadius:(CGFloat)radius atRectCorner:(UIRectCorner)corners withFrame:(CGRect)frame
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners:corners cornerRadii:CGSizeMake(radius, corners)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = frame;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    self.layer.masksToBounds = YES;
}

/// 设置边框
- (void)setBoarderWidth:(CGFloat)width color:(UIColor *)color
{
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
    self.layer.masksToBounds = YES;
}

/// 设置虚线边框
- (void)setBoarderWidth:(CGFloat)width color:(UIColor *)color lineDashPattern:(NSArray *)lineDashPattern
{
    CAShapeLayer *border = [CAShapeLayer layer];
    border.strokeColor = color.CGColor;
    border.fillColor = nil;
    border.lineDashPattern = lineDashPattern;
    border.lineWidth = width;
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(self.layer.cornerRadius, UIRectCornerAllCorners)];
    border.path = borderPath.CGPath;
    border.frame = self.bounds;
    [self.layer addSublayer:border];
}


#pragma mark- (快速从xib中加载)
+ (instancetype)MJ_viewFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}


@end
