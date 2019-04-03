//
//  YRRechargeColCell.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/16.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRRechargeColCell.h"
#import "YRChargeCardModel.h"

@interface YRRechargeColCell()

//金币数量
@property (weak, nonatomic) IBOutlet UILabel *coinL;

//中间的描述
@property (weak, nonatomic) IBOutlet UILabel *contentL;


@property (weak, nonatomic) IBOutlet UIButton *moneyBtn;


@end


@implementation YRRechargeColCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _coinL.font = MJBlodMiddleBobyFont;
    _contentL.font = MJBlodMiddleBobyFont;
    _moneyBtn.titleLabel.font = MJBlodMiddleBobyFont;
    
   
    [self setCornerRadius:16.0];
    
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.moneyBtn setCornerRadius:self.moneyBtn.MJ_height * 0.5];

}

- (void)setCardItem:(YRChargeCardModel *)cardItem
{
    _cardItem = cardItem;
    
    self.coinL.text = cardItem.gameCoin;
    
    //描述
    self.contentL.text = cardItem.name;
    
    [self.moneyBtn setTitle:[NSString stringWithFormat:@"¥ %@",cardItem.price] forState:UIControlStateNormal];
}

@end
