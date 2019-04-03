//
//  YRCornerBaseModel.h
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/20.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRBaseDataModel.h"

typedef NS_ENUM(NSInteger, NeedCornerRadius) {
    NeedCornerRadiusTop,        // 头部
    NeedCornerRadiusMiddle,         //中间
    NeedCornerRadiusButtom,        // 底部
    NeedCornerRadiusAll            //只有一个的时候,需要全部的圆角
};

@interface YRCornerBaseModel : YRBaseDataModel

@property (nonatomic, assign) NeedCornerRadius needCornerRadius;


+ (void)mj_reloveCornerModeWithArr:(NSArray<YRCornerBaseModel *> *)modelArr andSize:(CGSize)cellSize;

@property (nonatomic, assign) CGSize cornerRadiusCellSize;

@property (nonatomic, assign) CGFloat cornerRadiusCellH;

@end
