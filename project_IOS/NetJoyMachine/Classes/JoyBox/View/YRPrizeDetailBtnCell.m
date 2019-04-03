//
//  YRPrizeDetailBtnCell.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/20.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRPrizeDetailBtnCell.h"

@interface YRPrizeDetailBtnCell()

@property (weak, nonatomic) IBOutlet UILabel *titleL;


@property (weak, nonatomic) IBOutlet UIButton *touchBtn;

@end

@implementation YRPrizeDetailBtnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    [self.touchBtn setCornerRadius:self.touchBtn.MJ_height * 0.5];
    
    _touchBtn.titleLabel.font = MJBlodTitleFont;
    _titleL.font = MJBlodTitleFont;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)touchBtnDidlicked:(id)sender
{
    
    
}

@end
