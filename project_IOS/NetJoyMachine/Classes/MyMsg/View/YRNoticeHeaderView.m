//
//  YRNoticeHeaderView.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/21.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRNoticeHeaderView.h"
#import "UIResponder+Router.h"
#import "YRNoticeModel.h"

@interface YRNoticeHeaderView()

@property (weak, nonatomic) IBOutlet UIView *backV;

@property (weak, nonatomic) IBOutlet UILabel *noticeTitileL;


@property (weak, nonatomic) IBOutlet UILabel *timeL;

@property (weak, nonatomic) IBOutlet UIButton *touchBtn;

@property (weak, nonatomic) IBOutlet UIImageView *readIdImgV;

@end

@implementation YRNoticeHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _noticeTitileL.font = MJBlodMiddleBobyFont;
    _timeL.font = MJBlodMiddleBobyFont;
    _noticeTitileL.textColor = MJBlackColor;
    _timeL.textColor = MJBlackColor;
    
    
    [self.backV.layer setCornerRadius:4.0];
}

- (void)setNoticeItem:(YRNoticeModel *)noticeItem
{
    _noticeItem = noticeItem;
    
    _touchBtn.selected = noticeItem.isOpen;
    
}

- (IBAction)BtnDidClicked:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    self.noticeItem.isOpen = sender.selected;
    
    [self notice_MsgSectionHeaderDidClicked:self.noticeItem.secitonNum];
    
}


@end
