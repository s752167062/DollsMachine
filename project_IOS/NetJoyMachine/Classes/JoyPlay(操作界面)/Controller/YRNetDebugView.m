//
//  YRNetDebugView.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/24.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRNetDebugView.h"



@implementation YRNetDebugView

- (void)setQuality:(ZegoApiPlayQuality)quality
{

    if (quality.quality  == 0) {
        [self.networkView setImage:[UIImage imageNamed:@"excellent"]];
        [self.networkButton setTitle:NSLocalizedString(@"网络优秀", nil) forState:UIControlStateNormal];
    } else if (quality.quality == 1) {
        [self.networkView setImage:[UIImage imageNamed:@"good"]];
        [self.networkButton setTitle:NSLocalizedString(@"网络流畅", nil) forState:UIControlStateNormal];
    } else if (quality.quality == 2) {
        [self.networkView setImage:[UIImage imageNamed:@"average"]];
        [self.networkButton setTitle:NSLocalizedString(@"网络缓慢", nil) forState:UIControlStateNormal];
    } else {
        [self.networkView setImage:[UIImage imageNamed:@"bad"]];
        [self.networkButton setTitle:NSLocalizedString(@"网络拥堵", nil) forState:UIControlStateNormal];
    }
    
    self.fpsLabel.text = [NSString stringWithFormat:@"%.2f", quality.fps];
    self.videoBitcodeLabel.text = [NSString stringWithFormat:@"%.2f kb/s", quality.kbps];
    self.audioBitcodeLabel.text = [NSString stringWithFormat:@"%.2f kb/s", quality.akbps];
    self.rttLabel.text = [NSString stringWithFormat:@"%d ms", quality.rtt];
    self.packageLossLabel.text = [NSString stringWithFormat:@"%.2f%%", quality.pktLostRate/256.0 * 100];
    
}

@end
