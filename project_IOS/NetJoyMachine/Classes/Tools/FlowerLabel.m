//
//  FlowerLabel.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/15.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "FlowerLabel.h"

@implementation FlowerLabel

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setDefaultProperty];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
        [self setDefaultProperty];
    }
    return self;
}

- (void)setDefaultProperty
{
    self.backgroundColor = [UIColor clearColor];
    self.outlineColor = [UIColor blackColor];
    self.outlineWidth = 2;
    
}

- (void)drawTextInRect:(CGRect)rect {
    
    CGSize shadowOffset = self.shadowOffset;
    UIColor *textColor = self.textColor;
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(c, self.outlineWidth);
    CGContextSetLineJoin(c, kCGLineJoinRound);
    
    CGContextSetTextDrawingMode(c, kCGTextStroke);
    self.textColor = self.outlineColor;
    [super drawTextInRect:rect];
    
    CGContextSetTextDrawingMode(c, kCGTextFill);
    self.textColor = textColor;
    self.shadowOffset = CGSizeMake(0, 0);
    [super drawTextInRect:rect];
    
    self.shadowOffset = shadowOffset;
}

@end
