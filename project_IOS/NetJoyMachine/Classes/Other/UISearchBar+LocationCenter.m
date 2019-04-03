//
//  UISearchBar+LocationCenter.m
//  JDH-Store
//
//  Created by ZMJ on 2017/9/15.
//  Copyright © 2017年 HuiJia. All rights reserved.
//

#import "UISearchBar+LocationCenter.h"

@implementation UISearchBar (LocationCenter)

-(void)changeLeftPlaceholder:(NSString *)placeholder
{
	self.placeholder = placeholder;
	
	//从str获取方法
	SEL centerSelector = NSSelectorFromString([NSString stringWithFormat:@"%@%@", @"setCenter", @"Placeholder:"]);
	
	if ([self respondsToSelector:centerSelector]) {
		BOOL centeredPlaceholder = NO;
		
		//创建方法签名
		NSMethodSignature *signature = [[UISearchBar class] instanceMethodSignatureForSelector:centerSelector];
		
		NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
		
		[invocation setTarget:self];
		
		[invocation setSelector:centerSelector];
		
		[invocation setArgument:&centeredPlaceholder atIndex:2];
		
		[invocation invoke];
	}
}


@end
