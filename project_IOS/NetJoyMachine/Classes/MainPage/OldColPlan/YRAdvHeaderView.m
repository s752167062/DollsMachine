//
//  YRAdvHeaderView.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/14.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRAdvHeaderView.h"
#import "UIResponder+Router.h"

@interface YRAdvHeaderView()

//广告label
@property (weak, nonatomic) IBOutlet UILabel *advLabel;

//开关按钮
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@property (assign , nonatomic) BOOL isPauseV;



@end

@implementation YRAdvHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

#pragma mark-- 开关按钮的点击

- (IBAction)closeBtnDidClicked:(UIButton *)sender
{
//    sender.selected = !sender.selected;
//
//    [self mainPage_sectionBtnDidClickedWithStatus:sender.selected];
    
}

@end
