//
//  YRCapDetailTextCell.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/21.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRCapDetailTextCell.h"
#import "UIResponder+Router.h"

@interface YRCapDetailTextCell()

//按钮
@property (weak, nonatomic) IBOutlet UIButton *touchBtn;


//内容
@property (weak, nonatomic) IBOutlet UILabel *cotentL;

@end

@implementation YRCapDetailTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.backgroundColor = MJMainRedColor;
    
    self.cotentL.font = MJBlodSmallBobyFont;
    self.cotentL.backgroundColor = MJMainRedColor;
    
    self.touchBtn.titleLabel.font = MJBlodMiddleBobyFont;
    [self.touchBtn setCornerRadius:MJcommonCornerRadius];
   
    
}

- (void)setDetailItem:(YRCaptureDetailModel *)detailItem
{
    _detailItem = detailItem;
    
    [self.touchBtn setTitle:detailItem.titleName forState:UIControlStateNormal];
    
    self.cotentL.text = detailItem.contentDetail ? : @"";
}

- (IBAction)appealBtnDidClicked:(id)sender
{
    [self captureDetailAppealBtnDidClick:self.detailItem.fixContentArr];
    
}

@end
