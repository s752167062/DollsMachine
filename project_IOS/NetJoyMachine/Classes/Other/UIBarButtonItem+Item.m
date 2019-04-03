//
//  AppDelegate.h
//  com.ygsoft.YGProject
//
//  Created by zhangmeijun on 16/4/25.
//  Copyright © 2016年 ygsoft. All rights reserved.
//

#import "UIBarButtonItem+Item.h"

@implementation UIBarButtonItem (Item)

+ (UIBarButtonItem *)createItemWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highlightedImage forState:UIControlStateHighlighted];
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//    UIView *buttonView = [[UIView alloc] initWithFrame:button.bounds];
//    [buttonView addSubview:button];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)createItemWithBackImage:(UIImage *)image target:(id)target action:(SEL)action
{
	UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
	[button setBackgroundImage:image forState:UIControlStateNormal];
	[button setBackgroundImage:image forState:UIControlStateHighlighted];
	[button sizeToFit];
//	button. = CGRectMake(0, 0, 30, 30);
	[button setCornerRadius:15.0];
	[button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	return [[UIBarButtonItem alloc] initWithCustomView:button];

}



+ (UIBarButtonItem *)createItemWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage target:(id)target action:(SEL)action
{
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but setImage:image forState:UIControlStateNormal];
    [but setImage:selectedImage forState:UIControlStateSelected];
    [but sizeToFit];
    [but addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIView *butV = [[UIView alloc] initWithFrame:but.bounds];
    [butV addSubview:but];
    return [[UIBarButtonItem alloc] initWithCustomView:butV];
}
//设置返回按钮
+ (UIBarButtonItem *)backItemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action title:(NSString *)title
{
    UIButton *buts = [UIButton buttonWithType:UIButtonTypeCustom];
    [buts setTitle:title forState:UIControlStateNormal];
    [buts setImage:image forState:UIControlStateNormal];
    [buts setImage:highImage forState:UIControlStateHighlighted];
    [buts sizeToFit];
	buts.frame = CGRectMake(0, 0, 30.0, 30.0);
    
    //设置内容内边框
//    buts.contentEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    
    [buts setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buts setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    
    [buts addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:buts];
}

+ (UIBarButtonItem *)createItemWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIView *buttonView = [[UIView alloc] initWithFrame:button.bounds];
    [buttonView addSubview:button];
    return [[UIBarButtonItem alloc] initWithCustomView:buttonView];
}

+ (UIBarButtonItem *)createItemWithTitle:(NSString *)title andSeltedTitle:(NSString *)selTitle andTextColor:(UIColor *)textColor target:(id)target action:(SEL)action
{
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	
	[button setTitle:title forState:UIControlStateNormal];
	
	[button setTitle:selTitle forState:UIControlStateSelected];
	
	[button setTitleColor:textColor forState:UIControlStateNormal];
	
	[button setTitleColor:textColor forState:UIControlStateSelected];
	
	button.titleLabel.font = [UIFont systemFontOfSize:17.0];
	[button sizeToFit];
	[button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	
	return [[UIBarButtonItem alloc] initWithCustomView:button];
	
}

+ (UIBarButtonItem *)createItemWithTitle:(NSString *)title andSeltedTitle:(NSString *)selTitle target:(id)target action:(SEL)action;
{
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setTitle:title forState:UIControlStateNormal];
	button.titleLabel.font = [UIFont systemFontOfSize:17.0];
	[button sizeToFit];
	[button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	UIView *buttonView = [[UIView alloc] initWithFrame:button.bounds];
	[buttonView addSubview:button];
	return [[UIBarButtonItem alloc] initWithCustomView:buttonView];
	
}

+ (UIBarButtonItem *)createItemWithTitle:(NSString *)title target:(id)target action:(SEL)action AndMsgNum:(NSString *)numStr
{
    UILabel *mylabel = [[UILabel alloc] init];
    mylabel.text = title;
    [mylabel sizeToFit];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.center = CGPointMake(mylabel.MJ_x + mylabel.MJ_width, mylabel.MJ_y);
    [button setTitle:numStr forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0];
    
    [button sizeToFit];
    button.layer.cornerRadius = button.MJ_width * 0.5;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, button.MJ_width + mylabel.MJ_width, button.MJ_height + mylabel.MJ_height)];
    [buttonView addSubview:button];
    return [[UIBarButtonItem alloc] initWithCustomView:buttonView];
}


+ (UIBarButtonItem *)mj_addRightBarButtonItemWithTitle:(NSString *)itemTitle andTarget:(id)target action:(SEL)action
{
    
    UIButton *rightbBarButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,88,44)];
    [rightbBarButton setTitle:itemTitle forState:(UIControlStateNormal)];
    [rightbBarButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    
    rightbBarButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
    [rightbBarButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    
    rightbBarButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    [rightbBarButton setTitleEdgeInsets:UIEdgeInsetsMake(0,0,0,5 *MJScreenW/375.0)];
    
    return  [[UIBarButtonItem alloc]initWithCustomView:rightbBarButton];
}

+ (UIBarButtonItem *)mj_addLeftBarButtonItemWithTitle:(NSString *)itemTitle andTarget:(id)target action:(SEL)action
{
    UIButton *leftbBarButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,44,44)];
    [leftbBarButton setTitle:itemTitle forState:(UIControlStateNormal)];
    [leftbBarButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    leftbBarButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
    [leftbBarButton addTarget:target action:action forControlEvents:(UIControlEventTouchUpInside)];
    
    leftbBarButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    [leftbBarButton setTitleEdgeInsets:UIEdgeInsetsMake(0,5 *MJScreenW/375.0,0,0)];
    
    
   return [[UIBarButtonItem alloc]initWithCustomView:leftbBarButton];
}


@end
