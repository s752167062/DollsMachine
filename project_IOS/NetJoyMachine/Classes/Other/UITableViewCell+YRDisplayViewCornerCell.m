//
//  UITableViewCell+YRDisplayViewCornerCell.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/20.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "UITableViewCell+YRDisplayViewCornerCell.h"

@implementation UITableViewCell (YRDisplayViewCornerCell)


- (void)mj_setCornerRadiusWith:(UIView *)backV andStyle:(NeedCornerRadius)cornerStyle andRadius:(CGFloat)radius
{
    switch (cornerStyle) {
        case NeedCornerRadiusTop:
            
            [backV setCornerRadius:MJcommonCornerRadius atRectCorner:UIRectCornerTopLeft | UIRectCornerTopRight];
            
            break;
        case NeedCornerRadiusButtom:
            
            [backV setCornerRadius:MJcommonCornerRadius atRectCorner:UIRectCornerBottomLeft | UIRectCornerBottomRight];
            
            break;
        case NeedCornerRadiusAll:
            [backV setCornerRadius:MJcommonCornerRadius atRectCorner:UIRectCornerAllCorners];
            
            break;
            
        default:
            [backV setCornerRadius:0 atRectCorner:UIRectCornerAllCorners];
            break;
    }
    
}

@end
