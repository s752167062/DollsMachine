//
//  YRGameJoyDetailCell.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/20.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRGameJoyDetailCell.h"

@interface YRGameJoyDetailCell()

@property (weak, nonatomic) IBOutlet UIImageView *goodsImgV;

@end


@implementation YRGameJoyDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.goodsImgV setAliCornerRadius:MJcommonCornerRadius];
    
    self.backgroundColor = MJMainRedColor;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
