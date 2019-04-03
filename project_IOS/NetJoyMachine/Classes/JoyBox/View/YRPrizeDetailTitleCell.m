//
//  YRPrizeDetailTitleCell.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/20.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRPrizeDetailTitleCell.h"

@interface YRPrizeDetailTitleCell()

@property (weak, nonatomic) IBOutlet UILabel *nameL;


@property (weak, nonatomic) IBOutlet UILabel *contentL;


@end

@implementation YRPrizeDetailTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _nameL.font = MJBlodMiddleBobyFont;
    _nameL.textColor = MJWhiteColor;
    _contentL.font = MJBlodMiddleBobyFont;
    _contentL.textColor = MJWhiteColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
