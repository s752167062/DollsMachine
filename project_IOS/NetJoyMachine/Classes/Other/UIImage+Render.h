//
//  AppDelegate.h
//  com.ygsoft.YGProject
//
//  Created by zhangmeijun on 16/4/25.
//  Copyright © 2016年 ygsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Render)

+ (UIImage *)imageWithOriginalRender:(NSString *)imageName;

+ (UIImage*) imageWithColor:(UIColor*)color size:(CGSize)size;

- (UIImage *)mj_getOpaqueImgSize:(CGSize)imgSize backColor:(UIColor *)backColor;

@end
