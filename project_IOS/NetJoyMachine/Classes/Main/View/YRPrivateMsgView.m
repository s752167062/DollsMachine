//
//  YRPrivateMsgView.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/17.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRPrivateMsgView.h"

@interface YRPrivateMsgView()

@property (weak, nonatomic) IBOutlet UILabel *nameL;

@property (weak, nonatomic) IBOutlet UIButton *numBtn;



@end


@implementation YRPrivateMsgView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.autoresizingMask = UIViewAutoresizingNone;
    
    self.MJ_width = MJScreenW;
    
    self.MJ_height = Size(40, 44, 44);
    
    self.nameL.font = MJBlodMiddleBobyFont;
    self.nameL.textColor = MJWhiteColor;
    
    self.numBtn.titleLabel.font = MJBlodMiddleBobyFont;
    
}

@end
