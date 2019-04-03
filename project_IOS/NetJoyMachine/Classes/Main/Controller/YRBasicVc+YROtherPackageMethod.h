//
//  YRBasicVc+YROtherPackageMethod.h
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/21.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRBasicVc.h"

@interface YRBasicVc (YROtherPackageMethod)

+ (UIAlertController *)addReportSheetControllerWithTitleArr:(NSArray<NSString *> *)titleArr andName:(NSString *)sheetName andPush:(void(^)(UIAlertAction * _Nonnull action))completePush;


+ (UIAlertController *)showAlert:(NSString *)message title:(NSString *)title;

+ (UIAlertController *)creatAlertWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle cancelTitle:(NSString *)canceTitle andComplete:(void(^)(NSInteger index))resultBlock otherTitle:(NSString *)otherTitle,...NS_REQUIRES_NIL_TERMINATION;

@end
