//
//  YRMyPrizeCell.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/19.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRMyPrizeCell.h"

@interface YRMyPrizeCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;

@property (weak, nonatomic) IBOutlet UILabel *nameL;

@property (weak, nonatomic) IBOutlet UILabel *timeL;

@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation YRMyPrizeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.backView.layer setCornerRadius:MJcommonCornerRadius];
    
    _nameL.font = MJBlodMiddleBobyFont;
    _nameL.textColor = MJBlackColor;
    _timeL.font = MJBlodSmallBobyFont;
    _timeL.textColor = MJGrayColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
