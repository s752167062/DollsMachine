//
//  YRNoticeCell.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/20.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRNoticeCell.h"
#import "YRNoticeModel.h"

@interface YRNoticeCell()

//背景视图
@property (weak, nonatomic) IBOutlet UIView *backV;




//消息内容
@property (weak, nonatomic) IBOutlet UILabel *msgContentL;


@end

@implementation YRNoticeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    self.MJ_width = MJScreenW;
//
//    [self layoutIfNeeded];
    
    self.contentView.backgroundColor = MJMainRedColor;
    
    self.msgContentL.font = MJMiddleTitleFont;
    
    [self.backV.layer setCornerRadius:4.0];
    
}

- (void)setNoticeItem:(YRNoticeModel *)noticeItem
{
    _noticeItem = noticeItem;
    
    
    
}

@end
