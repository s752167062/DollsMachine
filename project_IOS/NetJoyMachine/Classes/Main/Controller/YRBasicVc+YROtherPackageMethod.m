//
//  YRBasicVc+YROtherPackageMethod.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/21.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRBasicVc+YROtherPackageMethod.h"


@implementation YRBasicVc (YROtherPackageMethod)

+ (UIAlertController *)addReportSheetControllerWithTitleArr:(NSArray<NSString *> *)titleArr andName:(NSString *)sheetName andPush:(void(^)(UIAlertAction * _Nonnull action))completePush
{
    if (!titleArr || titleArr.count == 0) return nil;
    
//    ZMJWeakSelf(self)
    
    UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:nil message:sheetName preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    [actionSheetController addAction:cancelAction];
    
    [titleArr enumerateObjectsUsingBlock:^(NSString * _Nonnull itemName, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx == titleArr.count - 1) {
            
            UIAlertAction *Action = [UIAlertAction actionWithTitle:itemName style:UIAlertActionStyleDestructive handler:completePush];
            
            [actionSheetController addAction:Action];
            
        }else{
            
            UIAlertAction *Action = [UIAlertAction actionWithTitle:itemName style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
                [SVProgressHUD showInfoWithStatus:itemName];
            }];
            
            [actionSheetController addAction:Action];
            
            
        }
        
    }];
    
    return actionSheetController;
}


+ (UIAlertController *)showAlert:(NSString *)message title:(NSString *)title
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                                 message:message
                                                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil)
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            
                                                        }];
        
    [alertController addAction:confirm];
        
    return alertController;
    
}


+ (UIAlertController *)creatAlertWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle cancelTitle:(NSString *)canceTitle andComplete:(void(^)(NSInteger index))resultBlock otherTitle:(NSString *)otherTitle,...NS_REQUIRES_NIL_TERMINATION {
    
    UIAlertController *alertCol = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    
    NSString *actionTitle = nil;
    va_list args;//用于指向第一个参数
    
    NSMutableArray *actionTitles = [NSMutableArray array];
    
    [actionTitles addObject:canceTitle];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:message style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

        resultBlock(0);
        
        
    }];
    
    [alertCol addAction:cancelAction];
    
    
    if (otherTitle) {
        [actionTitles addObject:otherTitle];
        va_start(args, otherTitle);//对args进行初始化，让它指向可变参数表里面的第一个参数
        while ((actionTitle = va_arg(args, NSString*))) {
            
            [actionTitles addObject:actionTitle];
            
        }
        va_end(args);
    }
    
    for (int i = 0 ; i < actionTitles.count; i++) {
        if (i == 0)continue;
        NSString *actionTitle = actionTitles[i];
        UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
//            if (self.indexBlock) {
//
//                self.indexBlock(i);
//            }
            
            resultBlock(i);
            
        }];
        
        [alertCol addAction:action];
    }
   
    
    return alertCol;
}



@end
