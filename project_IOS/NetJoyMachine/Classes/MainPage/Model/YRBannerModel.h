//
//  YRBannerModel.h
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/15.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRBaseDataModel.h"
@class YRAdvBarModel;

@interface YRBannerModel : YRBaseDataModel

@property (nonatomic, strong) NSArray<YRAdvBarModel *> *advAllData;

@property (nonatomic, strong) NSArray *bannerImgArr;

@property (nonatomic, strong) NSArray *advStrArr;

//点击跳转
@property (nonatomic, strong) NSArray *redirectArr;

@property (nonatomic, assign) BOOL isAdvClose;

@end
