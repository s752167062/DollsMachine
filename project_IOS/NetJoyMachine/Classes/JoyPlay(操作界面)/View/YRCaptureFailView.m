//
//  YRCaptureFailView.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/20.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRCaptureFailView.h"
#import "UIView+TYAlertView.h"
#import "FlowerLabel.h"

@interface YRCaptureFailView()

//自动关闭定时器
@property (nonatomic, strong) NSTimer *closeTimer;

@property (weak, nonatomic) IBOutlet FlowerLabel *countdownL;

@property (weak, nonatomic) IBOutlet FlowerLabel *hintText;


@end

@implementation YRCaptureFailView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.MJ_width = YRAlert_Relative_Width;
    
    self.MJ_height = YRAlert_Relative_Height;
    
    self.autoresizingMask = UIViewAutoresizingNone;
    
    self.countdownL.font = YRAlert_Relative_FontSize;
    
    self.hintText.font = YRAlert_Relative_FontSize;
    
    [self startCloseTimer];
    
}

//再玩一次按钮的点击
- (IBAction)playItAgainBtnClicked:(UIButton *)sender
{

    if ([self.captureFailDelegete respondsToSelector:@selector(captureFailThencustomWantToPlayAgainWithType:)]) {
        [self.captureFailDelegete captureFailThencustomWantToPlayAgainWithType:CapturePlayAgain];
    }
    
    [self stopCountdownTimer];
    
    [self hideView];
    
}

//不玩按钮点击
- (IBAction)refuseBtnClicked:(id)sender
{
    if ([self.captureFailDelegete respondsToSelector:@selector(captureFailThencustomWantToPlayAgainWithType:)]) {
        [self.captureFailDelegete captureFailThencustomWantToPlayAgainWithType:CapturePlayOver];
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
    self.countdownL.text = [NSString stringWithFormat:@"倒计时: %zds",closeTime];
    
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
