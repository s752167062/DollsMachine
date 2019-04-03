//
//  YRPlaceTextView.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/28.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRPlaceTextView.h"

@interface YRPlaceTextView()<UITextViewDelegate>

@property (nonatomic, strong) UILabel *placeholderLabel;

@end



@implementation YRPlaceTextView

- (UILabel *)placeholderLabel
{
    if (!_placeholderLabel) {
        
        _placeholderLabel = [[UILabel alloc] init];
    }
    return _placeholderLabel;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.placeholderLabel.text = @"请您输入您的宝贵意见";
    self.placeholderLabel.font = MJMiddleBobyFont;
    self.placeholderLabel.textColor = MJGrayColor;
    self.placeholderLabel.frame = CGRectMake(4, -7, self.MJ_width, 44);
    [self addSubview:self.placeholderLabel];
    self.delegate = self;
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.placeholderLabel.hidden = self.hasText;
}


@end
