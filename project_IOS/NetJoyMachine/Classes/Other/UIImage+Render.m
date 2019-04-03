//
//  AppDelegate.h
//  com.ygsoft.YGProject
//
//  Created by zhangmeijun on 16/4/25.
//  Copyright © 2016年 ygsoft. All rights reserved.
//

#import "UIImage+Render.h"

static CGContextRef _newBitmapContext(CGSize size)
{
	CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
	size_t imgWith = (size_t)(size.width + 0.5);
	size_t imgHeight = (size_t)(size.height + 0.5);
	size_t bytesPerRow = imgWith * 4;
	
	CGContextRef context = CGBitmapContextCreate(
												 NULL,
												 imgWith,
												 imgHeight,
												 8,
												 bytesPerRow,
												 colorSpaceRef,
												 (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	CGColorSpaceRelease(colorSpaceRef);
	return context;
}


@implementation UIImage (Render)
+ (UIImage *)imageWithOriginalRender:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (UIImage*) imageWithColor:(UIColor*)color size:(CGSize)size
{
	CGContextRef context = _newBitmapContext(size);
	CGContextSetFillColorWithColor(context, color.CGColor);
	CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
	
	CGImageRef imgRef = CGBitmapContextCreateImage(context);
	UIImage* img = [UIImage imageWithCGImage:imgRef];
	
	CGContextRelease(context);
	CGImageRelease(imgRef);
	
	return img;
}



@end
