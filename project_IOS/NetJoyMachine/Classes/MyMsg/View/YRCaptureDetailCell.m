//
//  YRCaptureDetailCell.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/19.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRCaptureDetailCell.h"

@interface YRCaptureDetailCell()

//编码名字
@property (weak, nonatomic) IBOutlet UILabel *numTitleL;

//编码数字
@property (weak, nonatomic) IBOutlet UILabel *numL;

//商品图片
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;

//商品名称
@property (weak, nonatomic) IBOutlet UILabel *nameL;

//抓取状态
@property (weak, nonatomic) IBOutlet UILabel *captureStatusL;

//抓取时间
@property (weak, nonatomic) IBOutlet UILabel *capTimeL;

//总个背景

@property (weak, nonatomic) IBOutlet UIView *backV;

@end

@implementation YRCaptureDetailCell

- (void)awakeFromNib {

    [super awakeFromNib];
    
    _nameL.font = MJBlodBigBobyFont;
    _nameL.textColor = MJBlackColor;
    _captureStatusL.font = MJBlodMiddleBobyFont;
    _captureStatusL.textColor = MJGrayColor;
    _capTimeL.font = MJSmallBobyFont;
    _capTimeL.textColor = MJLittleGrayColor;
    _numTitleL.font = MJMiddleTitleFont;
    _numTitleL.textColor = MJGrayColor;
    _numTitleL.font = MJMiddleTitleFont;
    _numTitleL.textColor = MJBlackColor;

    [self.backV setCornerRadius:MJcommonCornerRadius];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
