//
//  YRJoyColCell.m
//  JoyMachine
//
//  Created by ZMJ on 2017/11/12.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRJoyColCell.h"
#import "FlowerLabel.h"
#import "YRJoyPlayRoomModel.h"
#import <UIImageView+WebCache.h>
#import "YRMainConst.h"

@interface YRJoyColCell()

@property (weak, nonatomic) IBOutlet FlowerLabel *titleL;

@property (weak, nonatomic) IBOutlet FlowerLabel *moneyL;


@property (weak, nonatomic) IBOutlet UIImageView *backImgV;



@end


@implementation YRJoyColCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.MJ_height = MainPage_colCellWH;
    
    self.MJ_width = MainPage_colCellWH;
    
    [self layoutIfNeeded];

//    self.layer.shadowPath =[UIBezierPath bezierPathWithRect:self.useStatusLabel.layer.bounds].CGPath;
//    self.layer.shadowColor = [[UIColor redColor] CGColor];//阴影的颜色
//    self.layer.shadowOpacity =1.0;   // 阴影透明度
////    self.useStatusLabel.layer.shadowOffset =CGSizeMake(1.0,1.0f); // 阴影的范围
//    self.layer.shadowRadius =10.0;  // 阴影扩散的范围控制
    
    
}

- (void)setRoomItem:(YRJoyPlayRoomModel *)roomItem
{
    _roomItem = roomItem;
    
    NSLog(@"%@",roomItem.name);
    
    self.titleL.text = roomItem.name ? : @"公仔";
    
    self.moneyL.text = [NSString stringWithFormat:@"%@%@/次",roomItem.price,roomItem.currency];
//    [self layoutIfNeeded];
    
    if ([roomItem.icon hasPrefix:@"http"]) {
        
        [self.backImgV sd_setImageWithURL:[NSURL URLWithString:roomItem.icon] placeholderImage:[UIImage imageNamed:@"xiaoxin"]];
    }else{
        self.backImgV.image = [UIImage imageNamed:@"xiaoxin"];
    }
    
    self.backImgV.aliCornerRadius = 16.0;
    
//    self.backImgV.image = [UIImage imageNamed:@"xiaoxin"];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

@end
