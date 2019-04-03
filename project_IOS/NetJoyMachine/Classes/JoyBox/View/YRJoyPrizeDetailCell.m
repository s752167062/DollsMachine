//
//  YRJoyPrizeDetailCell.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/20.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRJoyPrizeDetailCell.h"

@interface YRJoyPrizeDetailCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;

@property (weak, nonatomic) IBOutlet UILabel *nameL;

@property (weak, nonatomic) IBOutlet UILabel *timeL;

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UILabel *describeL;


@property (weak, nonatomic) IBOutlet UILabel *captureStatusL;


@end

@implementation YRJoyPrizeDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    
    [self.backView.layer setCornerRadius:MJcommonCornerRadius];
    
    _nameL.font = MJBlodBigBobyFont;
    _nameL.textColor = MJBlackColor;
    _describeL.font = MJBlodMiddleBobyFont;
    _describeL.textColor = MJGrayColor;
    _timeL.font = MJSmallBobyFont;
    _timeL.textColor = MJLittleGrayColor;
    _captureStatusL.font = MJBlodTitleFont;
    _captureStatusL.textColor = MJBlackColor;
   
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
