//
//  MainPageVc.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/13.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "MainPageVc.h"

#import "MJSegmentVc.h"
#import "YRJoyListVc.h"

#import "YRMyAlertView.h"
#import "UIView+TYAlertView.h"
#import "TYShowAlertView.h"
#import "YRRechargeView.h"
#import "NSDictionary+Encrypt.h"

#import "YRGoldCoinVc.h"
#import "YRGoldBoxVc.h"
#import "YRPayVc.h"
#import "YRCaptureHistoryVc.h"

#import "YRSettingVc.h"
#import "YRJoyBoxVc.h"
#import "YRCoinPayVc.h"
#import "YRNoticeVc.h"
#import "YRJoyListTableVc.h"
#import "YRMainListBarModel.h"
#import "UserInfoTool.h"

@interface MainPageVc ()<YRMyAlertViewDelegate , YRRechargeViewDelegate>

@property (nonatomic, weak) YRMyAlertView *myAlertView;

@end

@implementation MainPageVc



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = MJMainRedColor;
    
    [self setupDefault];
    
    [self setupUI];

    
}


#pragma mark-- 设置初始化值
- (void)setupDefault
{
    self.navigationItem.title = @"一起抓娃娃";
}

#pragma mark-- 初始化UI
- (void)setupUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //添加navItem
    [self setupNavItem];
    
    [self requestBarData];
    
    //添加segVc
//    [self setupSegmentVc];
    
    
}

- (void)requestBarData
{
    ZMJWeakSelf(self);
    
    
    
    [SVProgressHUD showWithStatus:@"请求中~"];
    
    [[GCDAsyncSocketCommunicationManager sharedInstance] socketWriteDataWithRequestType:GACRequestType_ContentBar requestBody:@{@"userId": @"666"} completion:^(NSError * _Nullable error, NSDictionary * _Nullable data) {
        
        //请求错误
        if (error) {
            //先从缓存中取
            if ([UserInfoTool getMainListBarModel] != nil)
            {
                NSArray *barItem = [UserInfoTool getMainListBarModel];
                
                [weakself setupSegmentVc:barItem];
                
                return;
            }
            [SVProgressHUD showErrorWithStatus:@"连接出错~"];
            return;
        }

        if (data == nil) return;

        NSArray *listItemArr = [YRMainListBarModel mj_objectArrayWithKeyValuesArray:data[@"barList"]];
        
        //保存数据
        [UserInfoTool setMainListBarModel:listItemArr];
        
        [weakself setupSegmentVc:listItemArr];
  
    }];
        
        
  
}

//初始化SegmentVc
- (void)setupSegmentVc:(NSArray<YRMainListBarModel *> *)listArr
{
    MJSegmentVc *segVc = [[MJSegmentVc alloc] init];
    
    [self addChildViewController:segVc];
    
    NSMutableArray *barTitleArr = [NSMutableArray array];
    
    NSMutableArray *childArr = [NSMutableArray array];
    
    for (YRMainListBarModel *barItem in listArr) {
        
        //添加名字
        [barTitleArr addObject:barItem.name];
        
        YRJoyListTableVc *JoyListVc = [[YRJoyListTableVc alloc] init];
        
        JoyListVc.jumpType = barItem.type;
        
        JoyListVc.havaAdvBar = [barItem.status integerValue];
        
        [childArr addObject:JoyListVc];
        
    }
    
    
    [self.view addSubview:segVc.view];
    
    segVc.segmentBar.selectIndex = 0;
    
    segVc.view.frame = CGRectMake(0, 0, MJScreenW, self.view.MJ_height);
    
    [segVc setUpWithItems:barTitleArr childVCs:childArr];
    
    [segVc.segmentBar updateWithConfig:^(MJSegmentBarConfig *config) {
        
        config.segmentBarBackColor = [UIColor colorWithHexString:@"ed7575"];
        
        config.itemNormalColor = MJEBGrayColor;
        
        config.indicatorExtraW = 2.0;
        
        config.itemSelectColor = [UIColor whiteColor];
        
        config.indicatorColor = [UIColor whiteColor];
        
        config.itemNormalFont = MJBlodBigBobyFont;
        
        config.itemSelectFont = config.itemNormalFont;
        
    }];
    
}

//初始化navItem
- (void)setupNavItem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithOriginalRender:@"yonghuzhongxin_button"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarBtnDidClicked)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithOriginalRender:@"wawahe_button"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarBtnDidClicked)];
    
}

- (void)rightBarBtnDidClicked
{
//    if (self.myAlertView) return;
    
    YRJoyBoxVc *boxVc = [[YRJoyBoxVc alloc] init];
    
    [self.navigationController pushViewController:boxVc animated:YES];
    
}


- (void)leftBarBtnDidClicked
{
    if (self.myAlertView) return;
    
    YRMyAlertView *myAlertV = [YRMyAlertView createViewFromNib];
    
    myAlertV.MyAlertViewDelegate = self;
    
    myAlertV.autoresizingMask = UIViewAutoresizingNone;
    
//    [myAlertV showInController:self preferredStyle:TYAlertControllerStyleAlert transitionAnimation:TYAlertTransitionAnimationDropDown backgoundTapDismissEnable:YES];
    
    
    [TYShowAlertView showAlertViewWithView:myAlertV backgoundTapDismissEnable:YES andShowInView:self.view];
    
    self.myAlertView = myAlertV;
}


- (void)myAletViewChildBtnDidClicked:(MyAlertView_Btntype)btnType
{
    switch (btnType) {
            
        case MyAlertView_gamecoinBtn://游戏币充值
            {
                YRRechargeView *chargeV = [YRRechargeView createViewFromNib];
                
                chargeV.autoresizingMask = UIViewAutoresizingNone;
                
                chargeV.delegate = self;
                
                [chargeV showInWindowWithBackgoundTapDismissEnable:YES];
                
            }
            break;
            
        case MyAlertView_moneyChangeBtn://金币兑换
        {
            YRGoldCoinVc *coinVc = [[YRGoldCoinVc alloc] init];
            
            [self.navigationController pushViewController:coinVc animated:YES];
            
        }
            break;
            
        case MyAlertView_coinOpenBtn://金币开箱
        {
            YRGoldBoxVc *goldVc = [[YRGoldBoxVc alloc] init];
            
            [self.navigationController pushViewController:goldVc animated:YES];
            
        }
            break;
            
        case MyAlertView_getItBtn://抓取记录
        {
            YRCaptureHistoryVc *captureVc = [[YRCaptureHistoryVc alloc] init];
            
            [self.navigationController pushViewController:captureVc animated:YES];
            
        }
            break;
            
        case MyAlertView_notiMsgBtn://通知消息
        {
            YRNoticeVc *noticeVc = [[YRNoticeVc alloc] init];
            
            [self.navigationController pushViewController:noticeVc animated:YES];
            
        }
            break;
            
        case MyAlertView_settingBtn://设置/充值记录界面
        {
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"YRSettingVc" bundle:nil];
            
            YRSettingVc *settingVc = [sb instantiateInitialViewController];
            
            [self.navigationController pushViewController:settingVc animated:YES];
            
        }
            break;   
            
        default:
            break;
    }
    
    
    
}


#pragma mark-- 响应代理方法
- (void)RechargeViewCellDidClick
{
    YRCoinPayVc *payVc = [[YRCoinPayVc alloc] init];
    
    [self.navigationController pushViewController:payVc animated:YES];
}





@end
