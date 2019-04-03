//
//  YRCaptureSuccessView.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/20.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRCaptureSuccessView.h"
#import "UIView+TYAlertView.h"
#import "FlowerLabel.h"

@interface YRCaptureSuccessView()

@property (weak, nonatomic) IBOutlet FlowerLabel *countdownLabel;

//自动关闭定时器
@property (nonatomic, strong) NSTimer *closeTimer;

@property (weak, nonatomic) IBOutlet FlowerLabel *successL;

@end


@implementation YRCaptureSuccessView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.MJ_width = YRAlert_Relative_Width;
    
    self.MJ_height = YRAlert_Relative_Height;
    
    self.autoresizingMask = UIViewAutoresizingNone;
    
    self.countdownLabel.font = YRAlert_Relative_FontSize;
    
    self.successL.font = YRAlert_Relative_FontSize;
    
    
    [self startCloseTimer];
    
}

//关闭按钮点击
- (IBAction)clostBtnDidClicked:(id)sender
{
    if ([self.captureSuccessDelegete respondsToSelector:@selector(captureSuccessThencustomWantToPlayAgainWithType:)]) {
        [self.captureSuccessDelegete captureSuccessThencustomWantToPlayAgainWithType:CapturePlaySuccessOver];
    }
    
    [self stopCountdownTimer];
    
    [self hideView];
    
   
    
}

//分享按钮点击
- (IBAction)sharedBtnDidClicked:(id)sender
{
    if ([self.captureSuccessDelegete respondsToSelector:@selector(captureSuccessThencustomWantToPlayAgainWithType:)]) {
        [self.captureSuccessDelegete captureSuccessThencustomWantToPlayAgainWithType:CapturePlaySuccessShared];
    }
    
    
    
    [self stopCountdownTimer];
    
    [self hideView];
    
}

//开始定时器
- (void)startCloseTimer
{
    [self.closeTimer invalidate];
    
    //创建排队定时器
    if (!self.closeTimer) {
        self.closeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(closeTimerAction:) userInfo:nil repeats:YES];
    }
    
}

static NSInteger closeTime = 30;

- (void)closeTimerAction:(NSTimer *)timer
{
    self.countdownLabel.text = [NSString stringWithFormat:@"倒计时: %zds",closeTime];
    
    closeTime --;
    
    if (closeTime == 0) {
        
        [self stopCountdownTimer];
        
        [self hideView];
    }
}

- (void)stopCountdownTimer
{
    [self.closeTimer invalidate];
    self.closeTimer = nil;
    closeTime = 30;
}


@end
