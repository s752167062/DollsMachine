//
//  NSString+HJCommon.h
//  JDH-Store
//
//  Created by ZMJ on 2017/9/25.
//  Copyright © 2017年 HuiJia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HJCommon)

/**
 *  获取字体大小
 *
 *  @param FontSize1 5s字体
 *  @param FontSize2 6s字体
 *  @param FontSize3 6p字体
 *
 *  @return 当前需要的字体大小
 */
+ (CGFloat)MJ_getCurrentFontSizeWith5S:(NSInteger)FontSize1
								 With6S:(NSInteger)FontSize2
								 With6P:(NSInteger)FontSize3;


@end
