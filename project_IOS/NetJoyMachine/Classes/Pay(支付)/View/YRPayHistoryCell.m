//
//  YRPayHistoryCell.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/17.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRPayHistoryCell.h"
#import "FlowerLabel.h"


@interface YRPayHistoryCell()

@property (weak, nonatomic) IBOutlet UIView *backV;

@property (weak, nonatomic) IBOutlet FlowerLabel *coinNumL;

@property (weak, nonatomic) IBOutlet UILabel *timeL;

@property (weak, nonatomic) IBOutlet UILabel *moneyL;

@end

@implementation YRPayHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _coinNumL.font = MJMiddleBobyFont;
    _timeL.font = MJMiddleBobyFont;
    _moneyL.font = MJBlodMiddleBobyFont;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.backV setCornerRadius:12.0];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
