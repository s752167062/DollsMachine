//
//  YRBasicVc.h
//  JoyMachine
//
//  Created by ZMJ on 2017/11/12.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJExtension.h>
#import "YRRefreshTool.h"
#import "YRPrivateMsgView.h"
#import <SVProgressHUD.h>
#import "GCDAsyncSocketCommunicationManager.h"

typedef enum MyTableView_Type
{
    MyTableView_StylePlain = 0,//普通tableVIew
    
    MyTableView_StyleGrouped,//组
    
}MyTableView_Type;


//单个col cell的宽度
#define MJ_cellWH ((MJScreenW - (self.youColsNum + 1) * self.youColsMargin) / self.youColsNum)

@interface YRBasicVc : UIViewController<UITableViewDataSource , UITableViewDelegate , UICollectionViewDataSource , UICollectionViewDelegate>

/// 当前页数
@property (nonatomic, assign) NSInteger pageNow;
/// 每页请求数
@property (nonatomic, assign) NSInteger pageSize;

/// 数据Arr
@property(nonatomic , strong) NSMutableArray * basicDataArr;

//添加下拉刷新
- (void)addHeaderRefresh:(UIScrollView *)scrView;

//添加上啦刷新
- (void)addFooterRefresh:(UIScrollView *)scrView;

//刷新请求数据
- (void)getRequestData;

//懒加载tableVIew
@property (nonatomic, strong) UITableView *myTableView;

//创建和获取一个tableVIew根据类型
- (UITableView *)getTableViewWithStyle:(MyTableView_Type)tableStyle;


//colView一行显示的数量
@property(nonatomic , assign) CGFloat youColsNum;

//colVIew没有Item之间的间距
@property(nonatomic , assign) CGFloat youColsMargin;

//懒加载colView
@property(nonatomic , strong) UICollectionView *youColView;


//懒加载一个公用的头部视图
@property (nonatomic, strong) YRPrivateMsgView *private_MsgHeaderV;


///返回一个头部视图
- (UIView *)headViewWithSize:(CGSize)size andTitleStr: (NSString *) titleStr;

/// footView
- (UIView *)footViewWithSize:(CGSize)size andTitleStr: (NSString *) titleStr;

@end
