//
//  YRDeliverAdsCell.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/20.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRDeliverAdsCell.h"
#import "UITableViewCell+YRDisplayViewCornerCell.h"

@interface YRDeliverAdsCell()

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;

@property (weak, nonatomic) IBOutlet UILabel *contentL;

@property (weak, nonatomic) IBOutlet UIButton *editBtn;


@end

@implementation YRDeliverAdsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.backgroundColor = MJMainRedColor;
    
    _contentL.font = MJBlodMiddleBobyFont;
    _contentL.textColor = MJBlackColor;
    
}

- (void)setDeliverItem:(YRRequestDeliverModel *)deliverItem
{
    _deliverItem = deliverItem;
    
    self.MJ_width = deliverItem.cornerRadiusCellSize.width;
    
    self.MJ_height = deliverItem.cornerRadiusCellSize.height;
    
    [self layoutIfNeeded];
    
    [self mj_setCornerRadiusWith:self.backView andStyle:deliverItem.needCornerRadius andRadius:MJcommonCornerRadius];
}

- (IBAction)selectedBtnDidClicked:(UIButton *)sender
{
    sender.selected = !sender.selected;
}


- (IBAction)editBtnDidClicked:(id)sender
{
    
    
}



@end
