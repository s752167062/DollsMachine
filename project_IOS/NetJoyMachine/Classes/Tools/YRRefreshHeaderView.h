//
//  YRRefreshHeaderView.h
//  NetJoyMachine
//
//  Created by ZMJ on 2017/12/1.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import <UIKit/UIKit.h>

//除棍子以为其他控件高度
#define RefreshHeaderMostH 55.0

//原来棍子高度
#define RefreshPoleRealH 11.0

@interface YRRefreshHeaderView : UIView

//底座
@property (weak, nonatomic) IBOutlet UIImageView *pedestalImgV;

//中间棍子
@property (weak, nonatomic) IBOutlet UIImageView *poleImgV;

//夹子
@property (weak, nonatomic) IBOutlet UIImageView *clampImgV;

//左侧夹子
@property (weak, nonatomic) IBOutlet UIImageView *leftClampImgV;

//右侧夹子
@property (weak, nonatomic) IBOutlet UIImageView *rightClampImgV;

//公仔
@property (weak, nonatomic) IBOutlet UIImageView *joyImgV;

@property(nonatomic ,strong)IBOutletCollection(UIImageView) NSArray *allImgVArr;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightMargin;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stickH;


@end
