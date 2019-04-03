//
//  YRDefaultGameView.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/30.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRDefaultGameView.h"

@implementation YRDefaultGameView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.frame = MJKeyWindow.bounds;
    self.autoresizingMask = UIViewAutoresizingNone;
}

@end
