//
//  YRRechargeView.h
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/16.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YRRechargeViewDelegate <NSObject>

- (void)RechargeViewCellDidClick;

@end

@interface YRRechargeView : UIView

@property (nonatomic, weak) id<YRRechargeViewDelegate> delegate;

@end
