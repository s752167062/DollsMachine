//
//  YRMainConst.h
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/22.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#pragma mark-- 首页全局变量
//一行col的个数
UIKIT_EXTERN CGFloat const MainPage_cols;

//col中cell的行列间距
UIKIT_EXTERN CGFloat const MainPage_margin;

//广告bar的高度
UIKIT_EXTERN CGFloat const MainPage_BarH;

//广告轮播图的高度
#define MainPage_BarAdvScrVH (MJScreenH * 0.22)

#define MainPage_BarAdvTotalH (MainPage_BarAdvScrVH + MainPage_BarH)

//单个col cell的宽度
#define MainPage_colCellWH ((MJScreenW - (MainPage_cols + 1) * MainPage_margin) / MainPage_cols)
