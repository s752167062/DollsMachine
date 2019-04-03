//
//  YRCaptureSuccessView.h
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/20.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, choiceSuccessType) {
    CapturePlaySuccessShared = 0,
    CapturePlaySuccessOver
};

@protocol YRCaptureSuccessViewDelegate<NSObject>

- (void)captureSuccessThencustomWantToPlayAgainWithType:(choiceSuccessType)chiceType;

@end



@interface YRCaptureSuccessView : UIView

@property (nonatomic, weak) id<YRCaptureSuccessViewDelegate> captureSuccessDelegete;

@end
