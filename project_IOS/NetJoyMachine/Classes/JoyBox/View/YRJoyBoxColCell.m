//
//  YRJoyBoxColCell.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/19.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRJoyBoxColCell.h"
#import "FlowerLabel.h"

@interface YRJoyBoxColCell()

@property (weak, nonatomic) IBOutlet UIImageView *goodsImgV;

@property (weak, nonatomic) IBOutlet FlowerLabel *goodsNameL;

@property (weak, nonatomic) IBOutlet FlowerLabel *describeL;

@property (weak, nonatomic) IBOutlet UIButton *moneyBtn;

@property (weak, nonatomic) IBOutlet UILabel *timeL;

@property (weak, nonatomic) IBOutlet UIView *buttomBackView;

@end


@implementation YRJoyBoxColCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupDefault];
    
    [self setupUI];
    
}

//MARK:- 设置默认信息
- (void)setupDefault
{
    
}

//MARK:- 设置UI
- (void)setupUI
{
    [self.layer setCornerRadius:20.0];
    
    //goodsNameL describeL moneyBtn timeL
    _goodsNameL.font = MJMiddleBobyFont;
    _describeL.font = MJMiddleBobyFont;
//    _moneyBtn.font =
    _timeL.font = MJBlodSmallBobyFont;
    
    _moneyBtn.layer.cornerRadius = 10;
    _moneyBtn.layer.masksToBounds = YES;
    
    NSDictionary *attrDict = @{ NSStrokeWidthAttributeName: @(4),
                                 NSStrokeColorAttributeName: [UIColor blackColor],
                                 NSFontAttributeName: [UIFont systemFontOfSize:MJMiddleBobyFontSize] };
  
    [_moneyBtn setAttributedTitle:[[NSAttributedString alloc] initWithString:@"666" attributes: attrDict] forState:UIControlStateNormal];
    
    
}

@end
