//
//  UITableViewCell+YRDisplayViewCornerCell.h
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/20.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YRCornerBaseModel.h"

@interface UITableViewCell (YRDisplayViewCornerCell)


/**
 给cell设置只有第一条和最后一条有圆角,中间为平直的样式

 @param backV 需要切圆角的背景视图
 @param cornerStyle 圆角样式
 @param radius 圆角大小
 */
- (void)mj_setCornerRadiusWith:(UIView *)backV andStyle:(NeedCornerRadius)cornerStyle andRadius:(CGFloat)radius;

@end
