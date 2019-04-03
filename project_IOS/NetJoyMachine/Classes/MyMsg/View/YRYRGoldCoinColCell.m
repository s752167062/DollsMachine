//
//  YRYRGoldCoinColCell.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/16.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRYRGoldCoinColCell.h"
#import "FlowerLabel.h"

@interface YRYRGoldCoinColCell()

@property (weak, nonatomic) IBOutlet UIImageView *joyImgV;

@property (weak, nonatomic) IBOutlet FlowerLabel *nameL;

@property (weak, nonatomic) IBOutlet UIButton *numBtn;

@end

@implementation YRYRGoldCoinColCell

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.joyImgV setCornerRadius:12.0];
    
    _nameL.font = MJMiddleBobyFont;
    _numBtn.titleLabel.font = MJMiddleBobyFont;
}

@end
