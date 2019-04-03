//
//  YRAnimationHeader.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/12/1.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRAnimationHeader.h"
#import "YRRefreshHeaderView.h"
#import <POP.h>

@interface YRAnimationHeader()

@property (nonatomic, strong) YRRefreshHeaderView *headerV;

@property (weak, nonatomic) UILabel *label;

@property (nonatomic, weak) POPSpringAnimation *spinAnimation;

@end



@implementation YRAnimationHeader

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）

- (YRRefreshHeaderView *)headerV
{
    if (!_headerV) {
        _headerV = [YRRefreshHeaderView MJ_viewFromXib];
        _headerV.autoresizingMask = UIViewAutoresizingNone;
    }
    return _headerV;
}

- (void)prepare
{
    [super prepare];
    
//    self.backgroundColor = [UIColor orangeColor];
    // 设置控件的高度
    self.mj_h = refreshHeaderH;
    self.backgroundColor = [UIColor orangeColor];
    
    [self addSubview:self.headerV];
    
    
    
}


#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    self.headerV.frame = self.bounds;
}
//刷新头部的高度
static CGFloat const refreshHeaderH = 100.0;
//第一阶段爆发高度
static CGFloat const fristEnd = refreshHeaderH * 0.9;
//第二阶段下拉临界值
static CGFloat const secondEnd = refreshHeaderH - fristEnd;
//棍子变大的最大长度
#define strickMaxH (refreshHeaderH - RefreshHeaderMostH)

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{

    [super scrollViewContentOffsetDidChange:change];

    CGPoint myPoint = [change[@"new"] CGPointValue];
    
    CGFloat myOffset = -myPoint.y;
    
//    NSLog(@"contentOffset什么鬼: %f",myOffset);
    
    self.headerV.stickH.constant = RefreshPoleRealH;
    
    CGFloat rihgtMove = ((myOffset / fristEnd) * self.mj_w * 0.5 <= self.mj_w * 0.5) ? (myOffset / fristEnd) * self.mj_w * 0.5 : self.mj_w * 0.5;
    
    self.headerV.rightMargin.constant = rihgtMove;
    
    //第二阶段
    if ((myOffset - fristEnd) < 0) return;
    
    CGFloat secondOffset = myOffset - fristEnd;
    
    self.headerV.stickH.constant = (secondOffset / secondEnd) * strickMaxH + RefreshPoleRealH <= (strickMaxH + RefreshPoleRealH) ? (secondOffset / secondEnd) * strickMaxH + RefreshPoleRealH : (strickMaxH + RefreshPoleRealH);
    
   
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle: /** 普通闲置状态 */
        {
//           POPSpringAnimation *spin = [self.headerV.joyImgV.layer pop_animationForKey:@"likeAnimation"];
            [self.spinAnimation setPaused:YES];
            
        }
            break;
        case MJRefreshStatePulling: /** 松开就可以进行刷新的状态 */
          
            break;
        case MJRefreshStateRefreshing: /** 正在刷新中的状态 */
        {
            if (!_spinAnimation) {
                POPSpringAnimation *spin = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotationY];
                spin.fromValue = @(0);
                spin.toValue = @(M_PI * 2);
                spin.springBounciness = 10;
                spin.velocity = @(2);
                spin.repeatCount = 100;
                spin.autoreverses = YES;
                [self.headerV.joyImgV.layer pop_addAnimation:spin forKey:@"likeAnimation"];
                self.spinAnimation = spin;
            }
            [_spinAnimation setPaused:NO];
            
            
            
        }
            break;
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    
//    NSLog(@"当前拖出比例:%f",pullingPercent);
    
//    for (UIImageView *imgV in self.headerV.allImgVArr) {
//
//        imgV.transform = CGAffineTransformTranslate(nil, <#CGFloat tx#>, <#CGFloat ty#>)
//
//    }
    
}



@end
