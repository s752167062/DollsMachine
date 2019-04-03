//
//  PublicMacro.h
//  ZMJCommunity
//
//  Created by zhangmeijun on 2016/11/9.
//  Copyright © 2016年 ygsoft. All rights reserved.
//

#define ApplicationDelegate                 ((AppDelegate *)[[UIApplication sharedApplication] delegate])
//2.获取通知中心
#define MJNotificationCenter [NSNotificationCenter defaultCenter]

//3.设置随机颜色
#define MJRandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]

//4.设置RGB颜色/设置RGBA颜色
#define MJRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define MJRGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(r)/255.0 blue:(r)/255.0 alpha:a]





//6.弱引用/强引用
#define ZMJWeakSelf(type)  __weak typeof(type) weak##type = type;
#define ZMJStrongSelf(type)  __strong typeof(type) type = weak##type;

//7.设置颜色
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue &0xFF00) >>8))/255.0 blue:((float)(rgbValue &0xFF))/255.0 alpha:1.0]
//#define UIColorFromRGBA(rgbValue, alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0  green:((float)((rgbValue & 0x00FF00) >> 8))/255.0  blue:((float)(rgbValue & 0x0000FF))/255.0  alpha:alphaValue]
#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 blue:((float)(rgbValue & 0x0000FF))/255. alpha:alphaValue]
//[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//设置颜色与透明度
#define HEXCOLORAL(rgbValue, al) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:al]
//颜色
#define RGB(A,B,C) [UIColor colorWithRed:A/255.0 green:B/255.0 blue:C/255.0 alpha:1.0]
#define RGBA(A,B,C,D) [UIColor colorWithRed:A/255.0 green:B/255.0 blue:C/255.0 alpha:D]

//获取图片资源
#define kGetImage(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]

//设置圆角边框
#define ZMJViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

/**  判断文字中是否包含表情 */
#define IsTextContainFace(text) [text containsString:@"["] &&  [text containsString:@"]"] && [[text substringFromIndex:text.length - 1] isEqualToString:@"]"]
