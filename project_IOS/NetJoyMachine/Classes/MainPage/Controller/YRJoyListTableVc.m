//
//  YRJoyListTableVc.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/22.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRJoyListTableVc.h"
#import "YRJoyListCell.h"
#import "YRJoyListModel.h"
#import "YRMainHeaderV.h"
#import "YRBannerModel.h"
#import "UIResponder+Router.h"
#import "YRMainConst.h"
#import "HJNetworkManager.h"
#import "ZegoSetting.h"
#import "YRZegoRoomModel.h"
#import "YRJoyGameVc.h"
#import "YRBasicVc+YROtherPackageMethod.h"
#import "YRAnimationHeader.h"
#import "YRMainListBarModel.h"
#import "YRHelpVc.h"
#import "YRJoyPlayRoomModel.h"
#import "YRJoyGameNetTool.h"

@interface YRJoyListTableVc ()


@property (nonatomic, strong) NSDictionary *bannerDict;

@property (nonatomic, strong) YRBannerModel *bannerItem;

@property (nonatomic, weak) YRMainHeaderV *headerV;

@end

@implementation YRJoyListTableVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDefault];
    
    [self setupUI];
    
    //请求广告条
    [self getAdvBarHeader];
    
    //解决iOS系统下面的上拉刷新回弹问题
    self.myTableView.estimatedRowHeight = 0;
    self.myTableView.estimatedSectionHeaderHeight = 0;
    self.myTableView.estimatedSectionFooterHeight = 0;

    //上下拉刷新
    ZMJWeakSelf(self)
    self.myTableView.mj_header = [YRAnimationHeader headerWithRefreshingBlock:^{
        NSLog(@"下拉刷新");
        
        weakself.pageNow = 0;
        
        [weakself getRequestData];
        
    }];
    
    [self addFooterRefresh:self.myTableView];
   
    
    //接收到App到了前台通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    //获取数据
    [self getRequestData];
}

//static const CGFloat MJDuration = 1.0;

#pragma mark-- 请求广告条
- (void)getAdvBarHeader
{
    if (self.havaAdvBar != 1)
    {
        self.myTableView.tableHeaderView = nil;
        return;
    }
    ZMJWeakSelf(self);
    
    [[GCDAsyncSocketCommunicationManager sharedInstance] socketWriteDataWithRequestType:GACRequestType_AdvertisingBar requestBody:@{@"type":self.jumpType ? : @""} completion:^(NSError * _Nullable error, id  _Nullable data) {
        
        [SVProgressHUD dismiss];
        NSLog(@"广告条内容: %@",data);
        YRBannerModel *barModel = [YRBannerModel new];
        barModel.advAllData = [YRAdvBarModel mj_objectArrayWithKeyValuesArray:data[@"picList"]];
        
        weakself.bannerItem = barModel;
        
        //需要处理数据
//        weakself.bannerItem.advAllData = [YRBannerModel mj_objectWithKeyValues:self.bannerDict];
        
        [weakself addTableHeaderV];
        
    }];
    
    
    
    
}

#pragma mark-- 接收到App到了前台
- (void)onApplicationActive:(NSNotification *)notification
{
    //刷新列表
    [self getRequestData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark-- 加载数据
- (void)getRequestData
{
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    
    [paraDict setValue:self.jumpType ? : @"0" forKey:@"type"];
    
    [paraDict setValue:@(self.pageNow) forKey:@"pageIndex"];
    
    [paraDict setValue:@(self.pageSize) forKey:@"pageSize"];
    
    ZMJWeakSelf(self)
    
    NSLog(@"%@",paraDict);
    
    [[GCDAsyncSocketCommunicationManager sharedInstance] socketWriteDataWithRequestType:GACRequestType_SendMainPage_JoyList requestBody:paraDict completion:^(NSError * _Nullable error, id  _Nullable data) {
        
        [weakself.myTableView.mj_footer endRefreshing];
        
        [weakself.myTableView.mj_header endRefreshing];
        
        if (weakself.pageNow == 0) {
            [weakself.basicDataArr removeAllObjects];
        }
        
        weakself.pageNow += 1;
        
        NSArray *dataArr = [YRJoyPlayRoomModel mj_objectArrayWithKeyValuesArray:data[@"machineList"]];
        
        [self.basicDataArr addObjectsFromArray:dataArr];
        
        [self.myTableView reloadData];
        NSLog(@"房间列表%@",data);
        
    }];
}

#pragma mark-- 加载数据
//- (void)getRequestData
//{
//    NSString *mainDomain = @"zego.im";
//
//    NSString *baseUrl = nil;
//
//    baseUrl = [NSString stringWithFormat:@"https://liveroom%u-api.%@", [ZegoSetting sharedInstance].appID, mainDomain];
//
//    NSString *url = [NSString stringWithFormat:@"%@/demo/roomlist?appid=%u", baseUrl, [ZegoSetting sharedInstance].appID];
//
//    ZMJWeakSelf(self)
//
//    [HJNetworkManager GET:url parameters:nil success:^(id responseObject) {
//
//        NSLog(@"%@",responseObject);
//
//        NSUInteger code = [responseObject[@"code"] integerValue];
//        if (code != 0)
//            return;
//
//        [self.basicDataArr removeAllObjects];
//
//        //字典转模型方法不要写错了
//        self.basicDataArr = [YRZegoRoomModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"room_list"]];
//
//        //过滤不要数据 (for-in 循环中不能删除数据)
//        for (NSInteger i = 0; i < self.basicDataArr.count; i++) {
//            YRZegoRoomModel *infoItem = self.basicDataArr[i];
//
//            if (!infoItem || !infoItem.room_id || infoItem.room_id.length == 0 || !infoItem.stream_info || infoItem.stream_info.count == 0) {
//
//                [self.basicDataArr removeObjectAtIndex:i];
//            }
//        }
//
////        NSLog(@"数据来了:%@",self.basicDataArr.firstObject);
//
//        //处理回来的数据
//        NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:1];
//
//        NSMutableArray *tmpRoom = [NSMutableArray arrayWithArray:self.basicDataArr];
//
//        for (YRZegoRoomModel *info in self.basicDataArr) {
//
//            if ([info.room_id hasPrefix:@"WWJ_ZEGO_12345_5432"]) {
//                [tmpRoom removeObject:info];
//                [tmp addObject:info];
//            }
//        }
//
//        if (tmp.count == 2) {
//            YRZegoRoomModel *info0 = tmp[0];
//            YRZegoRoomModel *info1 = tmp[1];
//            if (![info0.room_id hasSuffix:@"54321"] && ![info1.room_id hasSuffix:@"54322"]) {
//                [tmp exchangeObjectAtIndex:0 withObjectAtIndex:1];
//            }
//        } else if (tmp.count == 3) {
//            for (int i = 0; i < tmp.count ; i++) {
//                YRZegoRoomModel *info = tmp[i];
//                if ([info.room_id hasSuffix:@"54321"]) {
//                    [tmp exchangeObjectAtIndex:0 withObjectAtIndex:i];
//                    continue;
//                } else if ([info.room_id hasSuffix:@"54322"]) {
//                    [tmp exchangeObjectAtIndex:1 withObjectAtIndex:i];
//                    continue;
//                } else {
//                    [tmp exchangeObjectAtIndex:2 withObjectAtIndex:i];
//                    continue;
//                }
//            }
//        }
//
//        [tmp addObjectsFromArray:tmpRoom];
//
//        self.basicDataArr = tmp;
//
//        // 结束刷新
//        [weakself.myTableView.mj_footer endRefreshing];
//
//        [weakself.myTableView.mj_header endRefreshing];
//
//        [self.myTableView reloadData];
//
//
//    } failure:^(NSError *error) {
//
//
//    }];
//}

#pragma mark-- 设置默认值
- (void)setupDefault
{
    self.youColsNum = 2;
    
    self.youColsMargin = 10;
    
    
}

#pragma mark-- 初始化视图
- (void)setupUI
{
    [self.view addSubview:self.myTableView];
    
    self.myTableView.contentInset = UIEdgeInsetsZero;
    
    self.myTableView.backgroundColor = MJMainGrayColor;

    
    [self.myTableView registerClass:[YRJoyListCell class] forCellReuseIdentifier:YRJoyListCellID];

}

#pragma mark-- 添加头部
- (void)addTableHeaderV
{
    YRMainHeaderV *headV = [[YRMainHeaderV alloc] initWithFrame:CGRectMake(0, 0, MJScreenW, MainPage_BarAdvTotalH)];
    
    headV.barItem = self.bannerItem;
    
    self.myTableView.tableHeaderView = headV;
    
    self.headerV = headV;
}



- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.myTableView.frame = self.view.bounds;
}

#pragma mark-- tableVIew的数据源方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowN = self.basicDataArr.count * 0.5 + self.basicDataArr.count % 2;
    
    return MainPage_colCellWH * rowN + (MainPage_margin + 1) * rowN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhuangshi_icon"]];
    
    imgV.contentMode = UIViewContentModeScaleAspectFill;
    
    return imgV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return Size(40, 44, 44);
}

static NSString *const YRJoyListCellID = @"YRJoyListCellID";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YRJoyListCell *cell = [tableView dequeueReusableCellWithIdentifier:YRJoyListCellID];
    

    if (self.basicDataArr > 0) {
        cell.roomArr = self.basicDataArr;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

#pragma mark-- 点击事件

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (void)mainPage_infiniteViewDidClickedWithUrlStr:(NSString *)jumpUrlStr
{
    if (!jumpUrlStr || ![NSURL URLWithString:jumpUrlStr] || ![jumpUrlStr hasPrefix:@"http"]) return;
    
    YRHelpVc *helpVc = [[YRHelpVc alloc] init];
    
    helpVc.pageName = @"活动";
    
    helpVc.jumpUrlStr = jumpUrlStr;
    
    [self.navigationController pushViewController:helpVc animated:YES];
}

- (void)mainPage_sectionBtnDidClickedWithStatus:(BOOL)BtnStatus
{
    if (BtnStatus) {
        
        self.headerV.MJ_height = MainPage_BarH;
    }else{
        
        self.headerV.MJ_height = MainPage_BarAdvTotalH;
    }
    self.myTableView.tableHeaderView = self.headerV;
    
}

#pragma mark-- 进入房间点击事件
- (void)mainPage_joyColDidClickedWithStatus:(NSIndexPath *)indexPath
{
    //取出房间模型
    if (self.basicDataArr == nil || self.basicDataArr.count <= 0 ||indexPath.row > self.basicDataArr.count - 1)
    {
        UIAlertController *alertController = [YRBasicVc showAlert:NSLocalizedString(@"娃娃机正在维护中，请刷新后重试", nil) title:NSLocalizedString(@"提示", nil)];
        
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    YRJoyPlayRoomModel *roomItem = self.basicDataArr[indexPath.row];
    
    if (roomItem.roomid == nil || roomItem.roomid.length == 0 || roomItem.streamList == nil || roomItem.streamList.count == 0) {
        
        UIAlertController *alertController = [YRBasicVc showAlert:NSLocalizedString(@"娃娃机正在维护中，请刷新后重试", nil) title:NSLocalizedString(@"提示", nil)];
        
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }

    //游戏房间界面
    YRJoyGameVc *gameVc = [[YRJoyGameVc alloc] initWithNibName:NSStringFromClass([YRJoyGameVc class]) bundle:nil];

    gameVc.roomItem = roomItem;

    [self.navigationController pushViewController:gameVc animated:YES];
}


- (NSDictionary *)bannerDict
{
    if (!_bannerDict) {
        _bannerDict = @{
                        @"bannerImgArr":@[
                                @"http://mpic.tiankong.com/dcd/965/dcd96596c1e6eb05da7dc58c3a01ecf3/640.jpg",
                                @"http://mpic.tiankong.com/99c/580/99c58020a1b531f42aa9a22270cd43cf/640.jpg",
                                @"http://mpic.tiankong.com/376/8c0/3768c0106c66f44459bf9e96ad5ccdef/640.jpg",
                                @"http://mpic.tiankong.com/cff/29e/cff29e9c9e7da0a5fa9618ed2126cea0/640.jpg",
                                @"http://mpic.tiankong.com/47e/c3f/47ec3f62c1bd3d8c061726818b771121/640.jpg",
                                @"http://mpic.tiankong.com/d50/573/d505739b0f05461add749c4889538d5d/640.jpg",
                                
                                ],
                        @"advStrArr":@[
                                @"Super萌萌哒小迷鹿",
                                @"蓝色星球星际宝贝",
                                @"酷炫十足钢铁侠",
                                @"限量版海王贼手办",
                                @"一堆娃娃",
                                @"蜜汁自信小狗狗"
                                ],
                        @"isAdvClose":@0
                        
                        };
    }
    return _bannerDict;
}



    
@end
