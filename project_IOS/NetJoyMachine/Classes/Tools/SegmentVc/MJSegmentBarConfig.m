//
//  MJSegmentBarConfig.m
//  MJSegmentBar
//
//  Created by MJ on 2017/5/15.
//  Copyright © 2017年 MJ. All rights reserved.
//

#import "MJSegmentBarConfig.h"

@implementation MJSegmentBarConfig

//MARK:- 默认配置
+ (instancetype)defaultConfig
{
    MJSegmentBarConfig *config = [[MJSegmentBarConfig alloc] init];
    config.segmentBarBackColor = [UIColor clearColor];
    config.itemNormalFont = [UIFont systemFontOfSize:12.0];
    config.itemSelectFont = [UIFont systemFontOfSize:18.0];
    config.itemNormalColor = [UIColor lightGrayColor];
    config.itemSelectColor = [UIColor redColor];
    
    config.indicatorColor = [UIColor redColor];
    config.indicatorHeight = 2;
    config.indicatorExtraW = 10;
    
    return config;
}

- (MJSegmentBarConfig *(^)(UIColor *))itemNC
{
    return ^(UIColor * color){
        
        self.itemNormalColor = color;
    
        return self;
    };

}

- (MJSegmentBarConfig *(^)(UIColor *))itemSC
{
    return ^(UIColor * color){
    
        self.itemSelectColor = color;
        
        return self;
    
    };

}



@end
