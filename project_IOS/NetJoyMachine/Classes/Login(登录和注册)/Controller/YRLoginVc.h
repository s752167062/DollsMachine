//
//  YRLoginVc.h
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/17.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRBasicVc.h"

@interface YRLoginVc : YRBasicVc

- (IBAction)weixinLoginBtnDidClicked:(id)sender;

@property (nonatomic, assign) BOOL canAutoLogin;

@end
