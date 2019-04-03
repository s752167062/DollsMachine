//
//  AppDelegate.h
//  com.ygsoft.YGProject
//
//  Created by zhangmeijun on 16/4/25.
//  Copyright © 2016年 ygsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Item)

/**
 *  创建UIBarButtonItem,高亮
 *
 *  @param image    图片
 *  @param highlightedImage 高亮图片
 *  @param target   监听者
 *  @param action   监听者调用的方法
 *
 */
+ (UIBarButtonItem *)createItemWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage target:(id)target action:(SEL)action;

+ (UIBarButtonItem *)createItemWithBackImage:(UIImage *)image target:(id)target action:(SEL)action;

/**
 *  创建UIBarButtonItem,选中
 *
 *  @param image    图片
 *  @param selectedImage 高亮图片
 *  @param target   监听者
 *  @param action   监听者调用的方法
 *
 */
+ (UIBarButtonItem *)createItemWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage target:(id)target action:(SEL)action;

/**
 *  创建返回按钮
 *
 *  @param image     返回按钮图片
 *  @param highImage 高亮图片
 *  @param target    监听者
 *  @param action    监听者调用的方法
 *  @param title     标题
 *
 */
+ (UIBarButtonItem *)backItemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action title:(NSString *)title;

+ (UIBarButtonItem *)createItemWithTitle:(NSString *)title target:(id)target action:(SEL)action;

+ (UIBarButtonItem *)createItemWithTitle:(NSString *)title andSeltedTitle:(NSString *)selTitle andTextColor:(UIColor *)textColor target:(id)target action:(SEL)action;

+ (UIBarButtonItem *)createItemWithTitle:(NSString *)title target:(id)target action:(SEL)action AndMsgNum:(NSString *)numStr;


//设配ios的barItem  右侧文字按钮
+ (UIBarButtonItem *)mj_addRightBarButtonItemWithTitle:(NSString *)itemTitle andTarget:(id)target action:(SEL   _Nullable )action;


//左侧 文字按钮

+ (UIBarButtonItem *)mj_addLeftBarButtonItemWithTitle:(NSString *)itemTitle andTarget:(id)target action:(SEL)action;


@end
