//
//  YRCaptureFailView.h
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/20.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, choiceType) {
    CapturePlayAgain = 0,
    CapturePlayOver
};

@protocol YRCaptureFailViewDelegate<NSObject>

- (void)captureFailThencustomWantToPlayAgainWithType:(choiceType)chiceType;

@end

@interface YRCaptureFailView : UIView

@property (nonatomic, weak) id<YRCaptureFailViewDelegate> captureFailDelegete;

@end
