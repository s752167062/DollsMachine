//
//  YRDeliverGoodsCell.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/20.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRDeliverGoodsCell.h"
#import "UITableViewCell+YRDisplayViewCornerCell.h"

@interface YRDeliverGoodsCell()

@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;

@property (weak, nonatomic) IBOutlet UIImageView *goodsImgV;

@property (weak, nonatomic) IBOutlet UILabel *nameL;

@property (weak, nonatomic) IBOutlet UILabel *numL;

@property (weak, nonatomic) IBOutlet UIView *backView;


@end

@implementation YRDeliverGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.backgroundColor = MJMainRedColor;
    
    _nameL.font = MJBlodMiddleBobyFont;
    _nameL.textColor = MJBlackColor;
    
    _numL.font = MJBlodSmallBobyFont;
    _numL.textColor = MJGrayColor;
    
}

- (void)setDeliverItem:(YRRequestDeliverModel *)deliverItem
{
    _deliverItem = deliverItem;
    
    self.MJ_width = deliverItem.cornerRadiusCellSize.width;
    
    self.MJ_height = deliverItem.cornerRadiusCellSize.height;
    
    [self layoutIfNeeded];
    
    [self mj_setCornerRadiusWith:self.backView andStyle:deliverItem.needCornerRadius andRadius:MJcommonCornerRadius];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
