//
//  MJOtherBtn.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/16.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "MJOtherBtn.h"

@implementation MJOtherBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


@implementation MJRLButton


- (void)layoutSubviews
{
    [super layoutSubviews];
    //
    //    //重新布局图片位置
    //
    //    //文字 重新计算文字宽度,在给titleLabel的宽度赋值
    [self.titleLabel sizeToFit];
    
    self.titleLabel.MJ_x = 0.0;
    
    self.imageView.MJ_x = CGRectGetMaxX(self.titleLabel.frame);
    
}

@end

//IB_DESIGNABLE

@interface MJTBButton()

@property (nonatomic ,strong)UILabel *subLable;

@property (nonatomic ,strong)IBInspectable NSString *subLText;

@property (nonatomic , assign) IBInspectable CGFloat cornerRadius;

@property (nonatomic , assign) IBInspectable CGFloat subLTestSize;

@property (nonatomic , strong) IBInspectable UIColor * subLTestColor;

@property (nonatomic , assign) IBInspectable CGFloat subLTestAlpha;

@end

@implementation MJTBButton

- (UILabel *)subLable
{
    if (!_subLable) {
        _subLable = [[UILabel alloc] init];
        
    }
    return _subLable;
}
-(void)setCornerRadius:(CGFloat)cornerRadius{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius > 0?true:false;
}

- (void)setSubLTestSize:(CGFloat)subLTestSize
{
    _subLTestSize = subLTestSize;
    
    self.subLable.font = [UIFont systemFontOfSize:subLTestSize];
    
}

- (void)setSubLTestColor:(UIColor *)subLTestColor
{
    _subLTestColor = subLTestColor;
    
    self.subLable.textColor = subLTestColor;
    
}

- (void)setSubLTestAlpha:(CGFloat)subLTestAlpha
{
    _subLTestAlpha = subLTestAlpha;
    
    self.subLable.alpha = subLTestAlpha;
}

- (void)setSubLText:(NSString *)subLText
{
    _subLText = subLText;
    
    self.subLable.text = subLText;
    
    _subLable.backgroundColor = [UIColor clearColor];
    
    self.titleLabel.backgroundColor = [UIColor clearColor];
    
    _subLable.textAlignment = NSTextAlignmentCenter;
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.subLable];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectZero;
    
    self.titleLabel.frame = CGRectMake(0, self.frame.size.height * 0.3, self.frame.size.width, self.frame.size.height * 0.2);
    
    self.titleLabel.numberOfLines = 1;
    
    self.subLable.frame = CGRectMake(0, self.frame.size.height * 0.5, self.frame.size.width, self.frame.size.height * 0.5);
    
}


@end

//IB_DESIGNABLE

@implementation MJITButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    //    [self setTitleEdgeInsets:UIEdgeInsetsMake(self.imageView.frame.size.height+10 ,-self.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    //
    //    [self setImageEdgeInsets:UIEdgeInsetsMake(-10, 0.0,0.0, -self.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
    
    //    self.imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * 0.5);
    
    
    
    // 图片
    self.imageView.MJ_centerX = self.MJ_width * 0.5;
    self.imageView.MJ_centerY = self.MJ_height * 0.5 - self.imageView.MJ_height * 0.5;
    self.titleLabel.font = MJMiddleTitleFont;
    
    // 文字
    // 重新计算文字宽度,在给titleLabel的宽度赋值
    [self.titleLabel sizeToFit];
    
    self.titleLabel.MJ_centerX = self.MJ_width * 0.5;
    self.titleLabel.MJ_y = self.MJ_height * 0.7;
    self.titleLabel.MJ_height = self.MJ_height * 0.3;
    
}


@end


