//
//  YRJoyListTableVc.h
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/22.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRBasicVc.h"

@interface YRJoyListTableVc : YRBasicVc

//当页的数据请求type参数
@property (nonatomic, copy) NSString *jumpType;

//是否有广告条
@property (nonatomic, assign) NSInteger havaAdvBar;

@end
