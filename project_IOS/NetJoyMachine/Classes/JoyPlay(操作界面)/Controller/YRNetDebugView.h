//
//  YRNetDebugView.h
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/24.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRBaseView.h"
#import "ZegoManager.h"

@interface YRNetDebugView : YRBaseView

@property (weak, nonatomic) IBOutlet UIImageView *networkView;



@property (weak, nonatomic) IBOutlet UIButton *networkButton;


@property (weak, nonatomic) IBOutlet UILabel *fpsLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoBitcodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *audioBitcodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rttLabel;
@property (weak, nonatomic) IBOutlet UILabel *packageLossLabel;

@property (nonatomic, assign) ZegoApiPlayQuality quality;


@end
