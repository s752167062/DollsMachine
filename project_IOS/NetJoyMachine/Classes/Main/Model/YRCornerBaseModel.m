//
//  YRCornerBaseModel.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/20.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRCornerBaseModel.h"

@implementation YRCornerBaseModel

+ (void)mj_reloveCornerModeWithArr:(NSArray<YRCornerBaseModel *> *)modelArr andSize:(CGSize)cellSize
{
    if (modelArr.count == 1) {
        
        YRCornerBaseModel *model1 = modelArr.firstObject;
        
        model1.needCornerRadius = NeedCornerRadiusAll;
        
        model1.cornerRadiusCellSize = cellSize;
        
        model1.cornerRadiusCellH = cellSize.height;
        
    }else{
        
        
        [modelArr enumerateObjectsUsingBlock:^(YRCornerBaseModel *deliverModel, NSUInteger idx, BOOL * _Nonnull stop)
         {
             
             deliverModel.cornerRadiusCellSize = cellSize;
             
             deliverModel.cornerRadiusCellH = cellSize.height;
             
             if (idx == 0) {
                 deliverModel.needCornerRadius = NeedCornerRadiusTop;
             }else if (idx == modelArr.count - 1){
                 deliverModel.needCornerRadius = NeedCornerRadiusButtom;
             }else{
                 deliverModel.needCornerRadius = NeedCornerRadiusMiddle;
             }
             
         }];
        
    }
}

@end
