//
//  YRCoinAlertView.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/17.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRCoinAlertView.h"

@interface YRCoinAlertView()

//标题

@property (weak, nonatomic) IBOutlet UILabel *titleL;

//内容
@property (weak, nonatomic) IBOutlet UILabel *contentL;


//确认按钮
@property (weak, nonatomic) IBOutlet UIButton *verifyBtn;


//取消按钮
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@end


@implementation YRCoinAlertView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.MJ_width = YRAlert_Coin_Small_Width;
    
    self.MJ_height = YRAlert_Coin_Small_Height;
    
    _titleL.font = MJBlodTitleFont;
    _titleL.textColor = MJMainRedColor;
    
    _contentL.font = MJBlodSmallBobyFont;
    _contentL.textColor = MJMainRedColor;
    
    _verifyBtn.titleLabel.font = MJBlodMiddleBobyFont;
    
    _cancelBtn.titleLabel.font = MJBlodMiddleBobyFont;
   
    [self layoutIfNeeded];
    
    [_verifyBtn setCornerRadius:_verifyBtn.MJ_height * 0.5];
    
    [_cancelBtn setCornerRadius:_cancelBtn.MJ_height * 0.5];
    
}

- (IBAction)verifyBtnDidClicked:(id)sender {
}


- (IBAction)cancelBtnDidClicked:(id)sender {
}

@end
