//
//  MJSegmentVc.h
//  MJSegmentBar
//
//  Created by MJ on 2017/5/15.
//  Copyright © 2017年 MJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJSegmentBar.h"


@interface MJSegmentVc : UIViewController

@property (nonatomic, weak) MJSegmentBar *segmentBar;

//主要方法,给一个itemsbar名字和子控制器,帮你创建对应的选项卡
- (void)setUpWithItems: (NSArray <NSString *>*)items childVCs: (NSArray <UIViewController *>*)childVCs;



@end
