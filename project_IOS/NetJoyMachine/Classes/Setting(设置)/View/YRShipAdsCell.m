//
//  YRShipAdsCell.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/17.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRShipAdsCell.h"
#import "YRLocationModel.h"

@interface YRShipAdsCell()

@property (weak, nonatomic) IBOutlet UIView *backV;

@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *phoneL;

@property (weak, nonatomic) IBOutlet UILabel *addressL;


@end

@implementation YRShipAdsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.backV.layer setCornerRadius:16.0];
    
    _nameL.font = MJBlodMiddleBobyFont;
    _nameL.textColor = MJBlackColor;
    _phoneL.font = MJBlodMiddleBobyFont;
    _phoneL.textColor = MJBlackColor;
    _addressL.font = MJBlodMiddleBobyFont;
    _addressL.textColor = MJBlackColor;
    
    
}

- (void)setLocationItem:(YRLocationModel *)locationItem
{
    _locationItem = locationItem;
    
    self.phoneL.text = locationItem.phone ? : @"";
    
    self.addressL.text = [NSString stringWithFormat:@"%@",locationItem.address];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
