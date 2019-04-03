//
//  YRCaptureHistoryCell.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/19.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRCaptureHistoryCell.h"
#import "UITableViewCell+YRDisplayViewCornerCell.h"

@interface YRCaptureHistoryCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;

@property (weak, nonatomic) IBOutlet UILabel *nameL;

@property (weak, nonatomic) IBOutlet UILabel *timeL;

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UILabel *captureStatusL;


@end

@implementation YRCaptureHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.MJ_width = MJScreenW;
    
    _nameL.font = MJBlodBigBobyFont;
    _nameL.textColor = MJBlackColor;
    _captureStatusL.font = MJBlodMiddleBobyFont;
    _captureStatusL.textColor = MJGrayColor;
    _timeL.font = MJSmallBobyFont;
    _timeL.textColor = MJLittleGrayColor;
    
    [self layoutIfNeeded];
    
    [self.backView setCornerRadius:MJcommonCornerRadius atRectCorner:UIRectCornerTopLeft | UIRectCornerTopRight];
    
}

- (void)setHistoryItem:(YRCapHistoryModel *)historyItem
{
    _historyItem = historyItem;
    
    self.MJ_width = historyItem.cornerRadiusCellSize.width;
    
    self.MJ_height = historyItem.cornerRadiusCellSize.height;
    
    [self layoutIfNeeded];
    
    [self mj_setCornerRadiusWith:self.backView andStyle:historyItem.needCornerRadius andRadius:MJcommonCornerRadius];
    
}

@end
