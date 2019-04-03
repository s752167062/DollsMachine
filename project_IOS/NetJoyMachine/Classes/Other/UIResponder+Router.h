//
//  UIResponder+Router.h
//  JDH-Store
//
//  Created by ZMJ on 2017/9/13.
//  Copyright © 2017年 HuiJia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YRZegoRoomModel;

@interface UIResponder (Router)

-(void)routerEvent:(id)info;

#pragma mark-- 主页的事件

//第一个组头部的点击
- (void)mainPage_sectionBtnDidClickedWithStatus:(BOOL)BtnStatus;

//主页第一组的轮播图点击
- (void)mainPage_infiniteViewDidClickedWithUrlStr:(NSString *)jumpUrlStr;

//主页公仔列表的每一个公仔的点击
- (void)mainPage_joyColDidClickedWithStatus:(NSIndexPath *)indexPath;



#pragma mark-- 抓取记录详情界面

//申诉按钮的点击
- (void)captureDetailAppealBtnDidClick:(NSArray <NSString *>*)dataArr;


#pragma mark-- 通知消息界面

//头部sectionHeaderView的点击
- (void)notice_MsgSectionHeaderDidClicked:(NSInteger)sectionNum;

@end
