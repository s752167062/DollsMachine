//
//  YRBannerModel.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/15.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRBannerModel.h"
#import "YRMainListBarModel.h"

@implementation YRBannerModel



- (void)setAdvAllData:(NSArray<YRAdvBarModel *> *)advAllData
{
    _advAllData = advAllData;
    
    NSMutableArray *bannerImgMArr = [NSMutableArray array];
    NSMutableArray *advStrMArr = [NSMutableArray array];
    NSMutableArray *redirectMArr = [NSMutableArray array];
    
    for (YRAdvBarModel *barItem in advAllData) {
        
        //
        [bannerImgMArr addObject:barItem.picUrl];
        
        [advStrMArr addObject:barItem.desc];
        
        [redirectMArr addObject:barItem.redirectUrl];
        
    }
    
    self.bannerImgArr = [NSArray arrayWithArray:bannerImgMArr];
    
    self.advStrArr = [NSArray arrayWithArray:advStrMArr];
    
    self.redirectArr = [NSArray arrayWithArray:redirectMArr];
    
    self.isAdvClose = NO;
    
    
}


@end
