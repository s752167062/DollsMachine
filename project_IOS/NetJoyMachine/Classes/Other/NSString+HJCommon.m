//
//  NSString+HJCommon.m
//  JDH-Store
//
//  Created by ZMJ on 2017/9/25.
//  Copyright © 2017年 HuiJia. All rights reserved.
//

#import "NSString+HJCommon.h"

@implementation NSString (HJCommon)

#pragma mark - 获取字体大小

+ (CGFloat)MJ_getCurrentFontSizeWith5S:(NSInteger)FontSize1 With6S:(NSInteger)FontSize2 With6P:(NSInteger)FontSize3 {
	if (iPhone5) {
		return FontSize1;
	}
	if (iPhone6 || iPhoneX) {
		return FontSize2;
	}
	if (iPhone6p) {
		return FontSize3;
	}
	return FontSize1;
}

@end
