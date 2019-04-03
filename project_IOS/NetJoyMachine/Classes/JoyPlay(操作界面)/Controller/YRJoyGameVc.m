//
//  YRJoyGameVc.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/14.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRJoyGameVc.h"
#import "YRGameJoyDetailVc.h"
#import "YRCaptureSuccessView.h"
#import "YRCaptureFailView.h"
#import "UIView+TYAlertView.h"
#import "YROtherThingsVc.h"
#import "YRBasicVc+YROtherPackageMethod.h"
#import "YRZegoRoomModel.h"
#import "FlowerLabel.h"
#import "YRBasicVc+YROtherPackageMethod.h"
#import "YRNetDebugView.h"
#import "YRDefaultGameView.h"
#import "UIViewController+YRUMShared.h"

#import "ZegoManager.h"
#import "ZegoSetting.h"
#import "ZegoCommand.h"
#import "YRJoyGameNetTool.h"
#import "ZegoReadyView.h"
#import "ZegoResultView.h"
#import "YRJoyPlayRoomModel.h"

#define kHeadSetStateChangeNotification     @"headSetStateChange"

typedef NS_ENUM(NSInteger, ZegoClientState)
{
    ZegoClientStateInitial = 0,         //  初始状态
    ZegoClientStateApplying,            //  预约中
    ZegoClientStateGameWaiting,         //  预约成功，等待上机（可取消预约）
    ZegoClientStateApplyCancelling,     //  取消预约中
    ZegoClientStateGameConfirming,      //  上机选择，等待确认
    ZegoClientStateGamePlaying,         //  游戏中
    ZegoClientStateResultWaiting        //  游戏结束，等待结果
};

typedef NS_ENUM(NSInteger, ZegoStreamStatus)
{
    ZegoStreamStatusStartPlaying = 0,   // 开始播放
    ZegoStreamStatusPlaySucceed,        // 播放成功，有流数据
    ZegoStreamStatusPlaySucceedEmpty,   // 播放成功，没有流数据
    ZegoStreamStatusPlayFail,           // 播放失败
};

//申请回答
static const NSString *applyKey =       @"receivedApplyReply";
//取消申请回答
static const NSString *cancelApplyKey = @"receivedCacelApplyReply";
//确认开始游戏
static const NSString *confirmKey =     @"receivedConfirmReply";
//结果
static const NSString *resultKey =      @"receivedResultReply";

@interface YRJoyGameVc ()<UIActionSheetDelegate,ZegoRoomDelegate, ZegoLivePlayerDelegate , YRCaptureFailViewDelegate , ZegoReadyViewDelegate , YRCaptureSuccessViewDelegate , UIAlertViewDelegate>

//需要处理的视图合集
@property(nonatomic ,strong)IBOutletCollection(UIView) NSArray *allBackViewArr;

//所以的按钮合集
@property(nonatomic ,strong)IBOutletCollection(UIView) NSArray *allBackBtnArr;

//刚进入界面默认样式背景视图
@property (nonatomic, strong) YRDefaultGameView *defaultBackV;

@property (nonatomic, strong) YRDefaultGameView *flowOneRemindV;

@property (nonatomic, strong) YRDefaultGameView *flowTwoRemindV;


@property (weak, nonatomic) IBOutlet UIButton *iconBtn;

@property (weak, nonatomic) IBOutlet UIView *moneyButtomView;

@property (weak, nonatomic) IBOutlet UIView *gameButtomView;

//当前房间总人数
@property (weak, nonatomic) IBOutlet FlowerLabel *totalLabel;

//当前预约人数按钮
@property (weak, nonatomic) IBOutlet UILabel *currentNumLabel;

//第一个播放视图
@property (weak, nonatomic) IBOutlet UIView *fristPlayView;

//第二个播放视图
@property (weak, nonatomic) IBOutlet UIView *secondPlayView;

//视频播放容器
@property (weak, nonatomic) IBOutlet UIView *playViewContainer;

//网络状况视图
@property (weak, nonatomic) IBOutlet YRNetDebugView *hintView;

//网络参数视图
@property (weak, nonatomic) IBOutlet YRNetDebugView *networkQualityView;

//游戏结束倒计时
@property (weak, nonatomic) IBOutlet FlowerLabel *gameoverTimeLabel;

//向前按钮
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;

//向后按钮
@property (weak, nonatomic) IBOutlet UIButton *backwardButton;


//向左按钮
@property (weak, nonatomic) IBOutlet UIButton *leftwardButton;


//向右
@property (weak, nonatomic) IBOutlet UIButton *rightwardButton;


//开始预约游戏按钮
@property (weak, nonatomic) IBOutlet UIButton *payPlayBtn;


//报修
@property (weak, nonatomic) IBOutlet UIButton *reportFixBtn;


//转换方向
@property (weak, nonatomic) IBOutlet UIButton *transDirectionBtn;

//是否开始游戏提示视图
@property (nonatomic, strong) ZegoReadyView *readyView;

//即构SDK相关
@property (nonatomic, strong) NSMutableArray *logArray;             // 操作日志

@property (nonatomic, assign) BOOL loginRoomSucceed;                // 登录成功

@property (nonatomic, strong) ZegoUser *serverUser;                 // 用户模型

@property (nonatomic, strong) YRZegoQueueModel *queueItem;
    //房间中队列模型

@property (nonatomic, assign) ZegoClientState machineState;                // 预约游戏状态

@property (nonatomic, copy) NSString *firstStreamID;                // 房间内第一条流 ID，默认显示
@property (nonatomic, copy) NSString *secondStreamID;               // 房间内第二条流 ID，默认不显示，可切换显示
@property (nonatomic, assign) NSInteger currentVisibleStreamIndex;  // 当前可见流，1 表示第一条流可见，2 表示第二条流可见，以此类推

@property (nonatomic, assign) ZegoStreamStatus firstStreamStatus;   // 第一条流状态
@property (nonatomic, assign) ZegoStreamStatus secondStreamStatus;  // 第二条流状态

@property (nonatomic, assign) BOOL isOperating;                     // 正在上机

//操作模型
@property (nonatomic, strong) ZegoCommand *command;

//请求玩游戏的人数
@property (nonatomic, strong) NSMutableDictionary *receivedReplyCounts;        // 用于去重同一个 seq reply

@property (nonatomic, strong) NSMutableDictionary *replyTimeout;        // 用于去重同一个 reply

@property (nonatomic, assign) int confirm;  // 1 确认上机，0 确认不上机

// 正在上机
@property (nonatomic, copy) NSString *currentPlayer;

@property (nonatomic, assign) NSInteger queueCount;                 // 前面排队人数
@property (nonatomic, assign) NSInteger totalCount;                 // 房间总人数

//-------------------------定时器-----------------
//排队定时器
@property (nonatomic, strong) NSTimer *applyTimer;
//取消排队定时器
@property (nonatomic, strong) NSTimer *cancelApplyTimer;
//开始定时器
@property (nonatomic, strong) NSTimer *readyTimer;
//游戏定时器
@property (nonatomic, strong) NSTimer *playTimer;
//确认定时器
@property (nonatomic, strong) NSTimer *confirmTimer;
//结果定时器
@property (nonatomic, strong) NSTimer *resultTimer;

@property (nonatomic, assign) NSInteger applyTimestamp;
@property (nonatomic, assign) NSInteger cancelApplyTimestamp;
@property (nonatomic, assign) NSInteger readyTimestamp;
@property (nonatomic, assign) NSInteger playTimestamp;
@property (nonatomic, assign) NSInteger confirmTimestamp;
@property (nonatomic, assign) NSInteger resultTimestamp;

@property (nonatomic, assign) int applySeq;
@property (nonatomic, assign) int cancelApplySeq;
@property (nonatomic, assign) int confirmSeq;
@property (nonatomic, assign) int gameReadySeq;
@property (nonatomic, assign) int gameResultSeq;




@end

@implementation YRJoyGameVc

#pragma mark-- 懒加载
- (YRDefaultGameView *)defaultBackV
{
    if (!_defaultBackV) {
        _defaultBackV = [YRDefaultGameView MJ_viewFromXib];
    }
    return _defaultBackV;
}

- (YRDefaultGameView *)flowOneRemindV
{
    if (!_flowOneRemindV) {
        _flowOneRemindV = [YRDefaultGameView MJ_viewFromXib];
    }
    return _flowOneRemindV;
}

- (YRDefaultGameView *)flowTwoRemindV
{
    if (!_flowTwoRemindV) {
        _flowTwoRemindV = [YRDefaultGameView MJ_viewFromXib];
    }
    return _flowTwoRemindV;
}

#pragma mark-- 设置房间模型数据
-(void)setRoomItem:(YRJoyPlayRoomModel *)roomItem
{
    _roomItem = roomItem;
    
    //保存流信息
    self.playStreamList = roomItem.streamList;
}



#pragma mark-- 处理流模型
- (void)setupModel
{
    NSLog(@"%@",self.playStreamList);
    
    if (self.playStreamList.count == 0) {
        [[YRJoyGameNetTool shareManger] addLog:NSLocalizedString(@"获取到的第一路流，第二路流 ID 均为空", nil)];
    } else if (self.playStreamList.count == 1) {
        YRJoyRoomStreamModel *streamItem = self.playStreamList[0];
        if ([streamItem.streamUrl hasSuffix:@"_2"]) {
            self.firstStreamID = nil;
            self.secondStreamID = streamItem.streamId;
            [[YRJoyGameNetTool shareManger] addLog:NSLocalizedString(@"获取到的第一路流 ID 为空", nil)];
        } else {
            self.firstStreamID = streamItem.streamId;
            self.secondStreamID = nil;
            [[YRJoyGameNetTool shareManger] addLog:NSLocalizedString(@"获取到的第二路流 ID 为空", nil)];
        }
    } else if (self.playStreamList.count == 2) {

        YRJoyRoomStreamModel *streamItem1 = self.playStreamList.firstObject;
    
        self.firstStreamID = streamItem1.streamId;
    
        YRJoyRoomStreamModel *streamItem2 = self.playStreamList.lastObject;
      
        self.secondStreamID = streamItem2.streamId;

    }
    
    //设置当前播放流
    self.currentVisibleStreamIndex = 1;
    self.isOperating = NO;
    self.queueCount = 0;
    
    self.logArray = [NSMutableArray array];
    
    self.command = [[ZegoCommand alloc] init];
    
    self.receivedReplyCounts = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    self.replyTimeout = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    [[YRJoyGameNetTool shareManger] addLog:[NSString stringWithFormat:NSLocalizedString(@"用户ID: %@，用户名: %@", nil), [ZegoSetting sharedInstance].userID, [ZegoSetting sharedInstance].userName]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置默认值
    [self setupDefault];
    
    //处理UI相关
    [self setupUI];
    
    // 初始化直播SDK
    [self setupLiveKit];
    
    //开始登陆房间
    [self loginRoom];
    
    //处理流模型 初始化数据
    [self setupModel];

    //监听事件
    [self monitorSomeThings];
    
}

- (void)monitorSomeThings
{
    NSLog(@"%@",[NSThread currentThread]);
    
    // 监听电话事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioSessionWasInterrupted:) name:AVAudioSessionInterruptionNotification object:nil];
    
    // 监听耳机插拔
    [[ZegoSetting sharedInstance] checkHeadSet];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAudioRouteChanged:) name:AVAudioSessionRouteChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackgournd:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
}

// 响应系统音频路径变更通知
- (void)handleAudioRouteChanged:(NSNotification *)notification
{
    NSInteger reason = [[notification.userInfo objectForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    
    if (reason == AVAudioSessionRouteChangeReasonNewDeviceAvailable ||
        reason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable ||
        reason == AVAudioSessionRouteChangeReasonOverride)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ZegoSetting sharedInstance] checkHeadSet];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kHeadSetStateChangeNotification object:self];
        });
    }
}

- (void)audioSessionWasInterrupted:(NSNotification *)notification
{
    NSLog(@"%s: %@", __func__, notification);
    if (AVAudioSessionInterruptionTypeBegan == [notification.userInfo[AVAudioSessionInterruptionTypeKey] intValue])
    {
        // 暂停音频设备
        [[ZegoManager api] pauseModule:ZEGOAPI_MODULE_AUDIO];
    }
    else if(AVAudioSessionInterruptionTypeEnded == [notification.userInfo[AVAudioSessionInterruptionTypeKey] intValue])
    {
        // 恢复音频设备
        [[ZegoManager api] resumeModule:ZEGOAPI_MODULE_AUDIO];
    }
}



#pragma mark-- 初始化房间SDK
- (void)setupLiveKit {
    [[ZegoManager api] setRoomDelegate:self];
    [[ZegoManager api] setPlayerDelegate:self];
}

#pragma mark-- 登陆房间  获取房间中的所有流信息,找到服务器推流的 user和获取房间人数信息(总人数+当前排队人数),房间视频流地址是从房间列表中获取的,视频播放跟操作分开的
- (void)loginRoom
{
    
    [[YRJoyGameNetTool shareManger] joyGame_login_RoomWithRoomId:self.roomItem.roomid andComplete:^(BOOL isSucceed, ZegoUser *playUser, YRZegoQueueModel *queueModel) {
        
        if (isSucceed) { //登录房间成功
            
            self.loginRoomSucceed = YES;
            
            self.payPlayBtn.enabled = YES;
            
            if (playUser) {
                self.serverUser = playUser;
            }
            
            if (queueModel) {
                //房间总人数
                self.totalLabel.text = [NSString stringWithFormat: NSLocalizedString(@"%d人在房间", nil), queueModel.total];
                
                self.queueItem = queueModel;
                //纪录房间总人数
                self.totalCount = queueModel.total;
                
                //房间排队人数
                self.queueCount = queueModel.queue_number;
                
                //当前正在操作的人
                self.currentPlayer = queueModel.player.userId;
            }
            
            // 秒播
            [self playingStreamOnEnteringRoom];
            
            //设置当前游戏状态
            self.machineState = ZegoClientStateInitial;
            
            // FIXME: 暂时在此时高亮开始游戏 button
            self.payPlayBtn.enabled = YES;
            
        }else{
            
            //房间登陆失败
            self.loginRoomSucceed = NO;
            
            //提示链接超时,让用户点击重连
            [self alertMsg:@"当前房间维护中,请稍后再试"];
            
        }
        
    }];
    
}

- (void)alertMsg:(NSString *)msg
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:msg message:@"么么哒" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //开启重连
    [self backBtnDidClicked:nil];
}



#pragma mark-- 设置默认值
- (void)setupDefault
{
    self.title = self.roomItem.name ? : @"Joy机房";
    
    //因为只有房间登录成功才能跳转进来
    self.loginRoomSucceed = YES;
    
    
    
}

#pragma mark-- 初始化视图
- (void)setupUI
{
    self.view.bounds = [UIScreen mainScreen].bounds;

    [self.view layoutIfNeeded];
    
    [self.view insertSubview:self.defaultBackV aboveSubview:self.playViewContainer];
    
    self.defaultBackV.hidden = NO;
    
    self.moneyButtomView.hidden = NO;
    
    self.gameButtomView.hidden = !self.moneyButtomView.hidden;
    
    //圆角
    for (UIView *backV in self.allBackViewArr) {
        [backV.layer setCornerRadius:8.0];
    }
    for (UIButton *backBtn in self.allBackBtnArr) {
        [backBtn setCornerRadius:8.0];
    }
    
    [self.reportFixBtn setCornerRadius:self.reportFixBtn.MJ_height * 0.5 atRectCorner:UIRectCornerTopLeft | UIRectCornerBottomLeft];
    
    [self.transDirectionBtn setCornerRadius:self.transDirectionBtn.MJ_height * 0.5 atRectCorner:UIRectCornerTopLeft | UIRectCornerBottomLeft];
    
    self.payPlayBtn.enabled = NO;
    self.payPlayBtn.titleLabel.numberOfLines = 2;
    self.payPlayBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
}



#pragma mark-- 进入房间后开始播放流
- (void)playingStreamOnEnteringRoom
{
    NSString *logString = [NSString stringWithFormat:NSLocalizedString(@"秒播。房间 ID：%@，\n第一路流 ID：%@，\n第二路流 ID：%@", nil), self.roomItem.roomid, self.firstStreamID, self.secondStreamID];
    
    [[YRJoyGameNetTool shareManger] addLogString:logString];
    
//    [[ZegoManager api] setPreviewViewMode:ZegoVideoViewModeScaleToFill];
    
    if (self.firstStreamID.length) {
        self.currentVisibleStreamIndex = 1;
        [self playVisibleStream:self.firstStreamID inView:self.fristPlayView];
    }
    
    if (self.secondStreamID.length)
    {
        [self playInvisibleStream:self.secondStreamID inView:self.secondPlayView];
    }
}

//处理App进入前台和后台
- (void)willEnterForeground:(NSNotification *)notification {
    if (self.firstStreamID.length) {
        [[ZegoManager api] startPlayingStream:self.firstStreamID inView:self.fristPlayView];
    }
    
    if (self.secondStreamID.length) {
        [[ZegoManager api] startPlayingStream:self.secondStreamID inView:self.secondPlayView];
    }
    
}

- (void)didEnterBackgournd:(NSNotification *)notification {
    NSLog(@"App did enter backgournd，停止拉流");
    [[ZegoManager api] stopPlayingStream:self.firstStreamID];
    [[ZegoManager api] stopPlayingStream:self.secondStreamID];
}


#pragma mark-- 开始播放

//开始播放流在哪一个视图中

//第一条
- (void)playVisibleStream:(NSString *)streamID inView:(UIView *)view {
    if (streamID.length) {
//        [SVProgressHUD show];
        BOOL isSuccess = [[ZegoManager api] startPlayingStream:streamID inView:view];
        
        [[ZegoManager api] setViewMode:ZegoVideoViewModeScaleAspectFill ofStream:streamID];
        [[ZegoManager api] setPlayVolume:100 ofStream:streamID];
        
    }
}

//第二条
- (void)playInvisibleStream:(NSString *)streamID inView:(UIView *)view {
    if (streamID.length) {
       BOOL isSuccess = [[ZegoManager api] startPlayingStream:streamID inView:view];

        [[ZegoManager api] setViewMode:ZegoVideoViewModeScaleAspectFill ofStream:streamID];
        [[ZegoManager api] setPlayVolume:0 ofStream:streamID];
    }
}

//刷新流播放  因为两条流是一起播放的 需要切换和调整声音来实现流的隐藏和显示
- (void)updateStreamToVisible:(NSString *)streamID inView:(UIView *)view {
    if (streamID.length) {
        [[ZegoManager api] setPlayVolume:100 ofStream:streamID];
    }
    
}

- (void)updateStreamToInvisible:(NSString *)streamID inView:(UIView *)view {
    if (streamID.length) {
        [[ZegoManager api] setPlayVolume:0 ofStream:streamID];
    }
    [self.playViewContainer sendSubviewToBack:view];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    self.navigationController.navigationBar.hidden = YES;
    
    [self setIdelTimerDisable:NO];
    
}

// FIXME: 用 loginroomsuccess 不合理，暂时没有更好的办法，待改


// 保持屏幕常亮
- (void)setIdelTimerDisable:(BOOL)disable
{
    [[UIApplication sharedApplication] setIdleTimerDisabled:disable];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    self.navigationController.navigationBar.hidden = NO;
    
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.iconBtn setCornerRadius:self.iconBtn.MJ_height * 0.5];
    
//    if (!self.loginRoomSucceed) {
//        if (self.currentVisibleStreamIndex == 1 && self.firstStreamStatus != ZegoStreamStatusPlaySucceed) {
//            if (self.firstStreamID.length) {
//                [self addPlayStatusImage:[UIImage imageNamed:@"Loading-1"] inView:self.fristPlayView];
//            } else {
//                [self addPlayStatusImage:[UIImage imageNamed:@"DeviceOff-1"] inView:self.fristPlayView];
//            }
//        } else if (self.currentVisibleStreamIndex == 2 && self.secondStreamStatus != ZegoStreamStatusPlaySucceed) {
//            if (self.secondStreamID.length) {
//                [self addPlayStatusImage:[UIImage imageNamed:@"Loading-2"] inView:self.secondPlayView];
//            } else {
//                [self addPlayStatusImage:[UIImage imageNamed:@"DeviceOff-2"] inView:self.fristPlayView];
//            }
//        }
//    }
    
}



#pragma mark-- 开始游戏前的事件

//开始游戏按钮的点击
- (IBAction)startGameBtnDidClicked:(UIButton *)sender
{
    //FIXME: 待修复取消状态判断的方法
    if ([self.currentNumLabel.text hasPrefix:NSLocalizedString(@"取消预约", nil)]) {
        
      UIAlertController *alrtV = [YRBasicVc creatAlertWithTitle:@"亲,真的要取消排队吗~(>_<)~" message:@"再想想" preferredStyle:UIAlertControllerStyleAlert cancelTitle:@"残忍取消" andComplete:^(NSInteger index) {
            
          if (index == 1) {
              
              self.payPlayBtn.enabled = NO;
              
              self.machineState = ZegoClientStateApplyCancelling;
              self.receivedReplyCounts[cancelApplyKey] = @0;
              self.replyTimeout[cancelApplyKey] = @0;
              
              clientSeq ++;
              
              if (self.serverUser) {
                  [SVProgressHUD showInfoWithStatus:@"取消预约"];
                  [self startCancelApplyTimer];
              }
              
             
          }
            
        } otherTitle:@"取消吧", nil];
        
        [self presentViewController:alrtV animated:YES completion:nil];
        
        
    }else{//当前是申请排队
        
        //向服务器申请排队
        [self requestToSeviceReplyJoinQueue];
        
    }
}

#pragma mark-- 向服务器申请排队(嘿哈)
- (void)requestToSeviceReplyJoinQueue
{
    //向服务器请求是否可以排队
    [SVProgressHUD showWithStatus:@"排队请求中~"];
    [[GCDAsyncSocketCommunicationManager sharedInstance] noRetrySocketSendWriteDataWithRequestType:GACRequestType_GetRequest_OrderQueue requestBody:@{@"roomId":self.roomItem.roomid ? : @""} completion:^(NSError * _Nullable error, id  _Nullable data) {
        
        [SVProgressHUD dismiss];
        
        if (error || !data) {
            [SVProgressHUD showErrorWithStatus:@"网络繁忙,请稍后再试"];
            return;
        }
        //FIXME:需要验证结果
        [self requestJoyMachineBeginJoinInQueue];
        
    }];
}

//请求娃娃机开始排队
- (void)requestJoyMachineBeginJoinInQueue
{
    //排队超时时间
    self.replyTimeout[applyKey] = @0;
    
    //排队申请状态保存
    self.receivedReplyCounts[applyKey] = @0;
    
    //点一次后,禁止用户再次点击
    self.payPlayBtn.enabled = NO;
    
    if (self.serverUser) {
        //开启排队定时器
        [self startApplyTimer];
        //修改机器状态
        self.machineState = ZegoClientStateApplying;
    }
}

//娃娃详情按钮点击
- (IBAction)joyDetailBtnDidClicked:(id)sender
{
    YRGameJoyDetailVc *detailVc = [[YRGameJoyDetailVc alloc] init];
    
    [self.navigationController pushViewController:detailVc animated:YES];
}

//充值按钮的点击
- (IBAction)rechargeBtnDidClicked:(id)sender
{
    
    
}



#pragma mark-- 开始游戏操作

//开始抓娃娃按钮点击
- (IBAction)beginCaptureBtnDidClicked:(id)sender
{
    self.receivedReplyCounts[resultKey] = @0;
    
    clientSeq ++;
    
    //拼接抓娃娃指令
    NSString *startGrabCommand = [self.command moveDown:clientSeq];
    
    //假如正在上机,而且存在服务用户
    if (self.isOperating && self.serverUser) {
        
        [[YRJoyGameNetTool shareManger] addLog: NSLocalizedString(@"用户发送移动命令：抓娃娃", nil)];
        
        //销毁游戏计时器
        [self.playTimer invalidate];
        self.playTimer = nil;
        
        //发送抓娃娃指令
        BOOL invokeSuccess = [[ZegoManager api] sendCustomCommand:@[self.serverUser] content:startGrabCommand completion:^(int errorCode, NSString *roomID) {
            [[YRJoyGameNetTool shareManger] addLog: [NSString stringWithFormat: NSLocalizedString(@"[COMMAND] MOVE_DOWN 发送结果：%d（0成功）", nil), errorCode]];
        }];
        
        [[YRJoyGameNetTool shareManger] addLog: [NSString stringWithFormat: NSLocalizedString(@"[COMMAND] MOVE_DOWN 调用结果：%d（1成功）", nil), invokeSuccess]];
        
        //        [self setButtonStatus:self.grabButton enable:NO];
        //游戏结束修改视图显示
        self.forwardButton.enabled = NO;
        self.backwardButton.enabled = NO;
        self.leftwardButton.enabled = NO;
        self.rightwardButton.enabled = NO;
        self.gameoverTimeLabel.text = @"";
        
        if (![self.receivedReplyCounts[resultKey] integerValue]) {
            //开启结果定时器
            [self startResultTimer];
        }
        //修改机器状态
        self.machineState = ZegoClientStateResultWaiting;
    }
    
    
}



//向上
- (IBAction)upBtnDidClicked:(id)sender
{
    if (self.isOperating && self.serverUser) {
        [[YRJoyGameNetTool shareManger] addLog: NSLocalizedString(@"用户发送移动命令：向前", nil)];
        
        NSString *goForwardCommand  = nil;
        if (self.currentVisibleStreamIndex == 1) {
            clientSeq ++;
            goForwardCommand = [self.command moveLeft:clientSeq];
        } else {
            clientSeq ++;
            goForwardCommand = [self.command moveBackward:clientSeq];
        }
        
        BOOL invokeSuccess = [[ZegoManager api] sendCustomCommand:@[self.serverUser] content:goForwardCommand completion:^(int errorCode, NSString *roomID) {
            [[YRJoyGameNetTool shareManger] addLog: [NSString stringWithFormat: NSLocalizedString(@"[COMMAND] MOVE_FORWARD 发送结果：%d（0成功）", nil), errorCode]];
        }];
        
        [[YRJoyGameNetTool shareManger] addLog: [NSString stringWithFormat: NSLocalizedString(@"[COMMAND] MOVE_FORWARD 调用结果：%d（1成功）", nil), invokeSuccess]];
    }
}


//向左
- (IBAction)leftBtnDidClicked:(id)sender
{
    if (self.isOperating && self.serverUser) {
        [[YRJoyGameNetTool shareManger] addLog: NSLocalizedString(@"用户发送移动命令：向左", nil)];
        
        NSString *goLeftCommand  = nil;
        if (self.currentVisibleStreamIndex == 1) {
            clientSeq ++;
            goLeftCommand = [self.command moveForward:clientSeq];
        } else {
            clientSeq ++;
            goLeftCommand = [self.command moveLeft:clientSeq];
        }
        BOOL invokeSuccess = [[ZegoManager api] sendCustomCommand:@[self.serverUser] content:goLeftCommand completion:^(int errorCode, NSString *roomID) {
            [[YRJoyGameNetTool shareManger] addLog: [NSString stringWithFormat: NSLocalizedString(@"[COMMAND] MOVE_LEFT 发送结果：%d（0成功）", nil), errorCode]];
        }];
        
        [[YRJoyGameNetTool shareManger] addLog: [NSString stringWithFormat: NSLocalizedString(@"[COMMAND] MOVE_LEFT 调用结果：%d（1成功）", nil), invokeSuccess]];
    }
}


//向下
- (IBAction)buttomBtnDidClicked:(id)sender
{
    if (self.isOperating && self.serverUser) {
        [[YRJoyGameNetTool shareManger] addLog: NSLocalizedString(@"用户发送移动命令：向后", nil)];
        
        NSString *goBackwardCommand  = nil;
        if (self.currentVisibleStreamIndex == 1) {
            clientSeq ++;
            goBackwardCommand = [self.command moveRight:clientSeq];
        } else {
            clientSeq ++;
            goBackwardCommand = [self.command moveForward:clientSeq];
        }
        BOOL invokeSuccess = [[ZegoManager api] sendCustomCommand:@[self.serverUser] content:goBackwardCommand completion:^(int errorCode, NSString *roomID) {
            [[YRJoyGameNetTool shareManger] addLog: [NSString stringWithFormat: NSLocalizedString(@"[COMMAND] MOVE_BACKWARD 发送结果：%d（0成功）", nil), errorCode]];
        }];
        
        [[YRJoyGameNetTool shareManger] addLog: [NSString stringWithFormat: NSLocalizedString(@"[COMMAND] MOVE_BACKWARD 调用结果：%d（1成功）", nil), invokeSuccess]];
    }
}


//向右
- (IBAction)rightBtnDidClicked:(id)sender
{
    if (self.isOperating && self.serverUser) {
        [[YRJoyGameNetTool shareManger] addLog: NSLocalizedString(@"用户发送移动命令：向右", nil)];
        
        NSString *goRightCommand  = nil;
        if (self.currentVisibleStreamIndex == 1) {
            clientSeq ++;
            goRightCommand = [self.command moveBackward:clientSeq];
        } else {
            clientSeq ++;
            goRightCommand = [self.command moveRight:clientSeq];
        }
        BOOL invokeSuccess = [[ZegoManager api] sendCustomCommand:@[self.serverUser] content:goRightCommand completion:^(int errorCode, NSString *roomID) {
            [[YRJoyGameNetTool shareManger] addLog: [NSString stringWithFormat: NSLocalizedString(@"[COMMAND] MOVE_RIGHT 发送结果：%d（0成功）", nil), errorCode]];
        }];
        
        [[YRJoyGameNetTool shareManger] addLog: [NSString stringWithFormat: NSLocalizedString(@"[COMMAND] MOVE_RIGHT 调用结果：%d（1成功）", nil), invokeSuccess]];
    }
}

#pragma mark-- 中间按钮点击

//报修按钮的点击
- (IBAction)fixBtnDidClicked:(id)sender
{
    
    ZMJWeakSelf(self)
    
    UIAlertController *actionSheetController = [YRBasicVc addReportSheetControllerWithTitleArr:@[@"画面黑屏或定格",@"操作按钮失灵",@"爪子卡主动不了",@"其他影响操作的问题"] andName:@"报修" andPush:^(UIAlertAction * _Nonnull action) {
        
        YROtherThingsVc *thingVc = [[YROtherThingsVc alloc]init];
        
        [weakself.navigationController pushViewController:thingVc animated:YES];
        
    }];
    
    [self presentViewController:actionSheetController animated:YES completion:nil];
}

//转换方向按钮点击
- (IBAction)transDirectionBtnDidClicked:(UIButton *)sender
{
    if (self.loginRoomSucceed) {
        if (self.currentVisibleStreamIndex == 1) {    // 切换到第二条流画面
            [[YRJoyGameNetTool shareManger] addLog: NSLocalizedString(@"用户切换到第二条流画面", nil)];
            
            self.currentVisibleStreamIndex = 2;
            
            if (!self.secondStreamID.length) {
                [self addPlayStatusImage:[UIImage imageNamed:@"DeviceOff-2"] inView:self.secondPlayView];
                [SVProgressHUD showInfoWithStatus:@"摄像头正在维修中,请稍后再试~"];
            } else {
                [self updateStreamToInvisible:self.firstStreamID inView:self.fristPlayView];
                
                switch (self.secondStreamStatus) {
                    case ZegoStreamStatusStartPlaying:
                    {
                        [self addPlayStatusImage:[UIImage imageNamed:@"Loading-2"] inView:self.secondPlayView];
                        break;
                    }
                    case ZegoStreamStatusPlaySucceed:
                    {
                        [self removePlayStatusImage:self.secondPlayView];
                        [self updateStreamToVisible:self.secondStreamID inView:self.secondPlayView];
                        break;
                    }
                    case ZegoStreamStatusPlaySucceedEmpty:
                    {
                        [self addPlayStatusImage:[UIImage imageNamed:@"DeviceOff-2"] inView:self.secondPlayView];
                        break;
                    }
                    case ZegoStreamStatusPlayFail:
                    {
                        [self addPlayStatusImage:[UIImage imageNamed:@"PlayFailed-2"] inView:self.secondPlayView];
                        break;
                    }
                    default:
                        break;
                }
            }
        } else if (self.currentVisibleStreamIndex == 2) {    // 切换到第一条流画面
            [[YRJoyGameNetTool shareManger] addLog: NSLocalizedString(@"用户切换到第一条流画面", nil)];
            
            self.currentVisibleStreamIndex = 1;
            
            if (!self.firstStreamID.length) {
                [self addPlayStatusImage:[UIImage imageNamed:@"DeviceOff-1"] inView:self.fristPlayView];
            } else {
                [self updateStreamToInvisible:self.secondStreamID inView:self.secondPlayView];
                
                switch (self.firstStreamStatus) {
                    case ZegoStreamStatusStartPlaying:
                    {
                        [self addPlayStatusImage:[UIImage imageNamed:@"Loading-1"] inView:self.fristPlayView];
                        break;
                    }
                    case ZegoStreamStatusPlaySucceed:
                    {
                        [self removePlayStatusImage:self.fristPlayView];
                        [self updateStreamToVisible:self.firstStreamID inView:self.fristPlayView];
                        break;
                    }
                    case ZegoStreamStatusPlaySucceedEmpty:
                    {
                        [self addPlayStatusImage:[UIImage imageNamed:@"DeviceOff-1"] inView:self.fristPlayView];
                        break;
                    }
                    case ZegoStreamStatusPlayFail:
                    {
                        [self addPlayStatusImage:[UIImage imageNamed:@"PlayFailed-1"] inView:self.fristPlayView];
                        break;
                    }
                    default:
                        break;
                }
            }
        }
    }
    
}


#pragma mark-- 头部视图

//返回按钮点击
- (IBAction)backBtnDidClicked:(id)sender
{
    if (self.machineState == ZegoClientStateGamePlaying) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil)
                                                                                 message:NSLocalizedString(@"正在游戏中，确定退出房间？", nil)
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil)
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           
                                                       }];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil)
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            [self stopPlayGame];
                                                        }];
        
        [alertController addAction:cancel];
        [alertController addAction:confirm];
        
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        [self stopPlayGame];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)stopPlayGame {
    // 切换拉流源
    [self offBoard];
    
    [[ZegoManager api] stopPlayingStream:self.firstStreamID];
    [[ZegoManager api] stopPlayingStream:self.secondStreamID];
    
    if (self.loginRoomSucceed) {
        [[ZegoManager api] logoutRoom];
    }
    
    [self setIdelTimerDisable:YES];
    
    [[YRJoyGameNetTool shareManger] addLog:@"停止 apply 定时器"];
    [self.applyTimer invalidate];
    self.applyTimer = nil;
    
    [self.cancelApplyTimer invalidate];
    self.cancelApplyTimer = nil;
    
    [self.readyTimer invalidate];
    self.readyTimer = nil;
    
    [self.playTimer invalidate];
    self.playTimer = nil;
    
    [self.resultTimer invalidate];
    self.resultTimer = nil;
    
    
    
}


//头像的点击
- (IBAction)iconBtnDidClicked:(id)sender
{
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self stopPlayGame];
    
//    //控制器销毁 断开流
//    [[ZegoManager api] stopPlayingStream:self.firstStreamID];
//    [[ZegoManager api] stopPlayingStream:self.secondStreamID];
    NSLog(@"%s",__func__);
}

#pragma mark-- setter方法

- (void)setMachineState:(ZegoClientState)machineState
{
    NSLog(@"状态扭转为：%ld", (long)machineState);
    
    _machineState = machineState;
    
    //出事状态
    if (machineState == ZegoClientStateInitial) {
        
        //判断当前队列人数和当前正在游戏用户
        if (self.queueItem.queue_number || (self.queueItem.queue_number == 0 && self.queueItem.player.userId.length && ![self.queueItem.player.userId isEqualToString:[ZegoSetting sharedInstance].userID]))
        {
            //前面有人,此时需要排队
            [self updatePrepareButtonToApplyStatus:[NSString stringWithFormat:NSLocalizedString(@"预约抓娃娃\n当前排队 %d 人", nil), self.queueItem.queue_number + 1] isCancel:NO];
        } else {
            //无人排队直接开始游戏
            [self updatePrepareButtonToStartStatus:NSLocalizedString(@"开始游戏", nil)];
            
            [self.payPlayBtn setImage:[UIImage imageNamed:@"dianjikaixiang_button"] forState:UIControlStateNormal];
        }
        self.payPlayBtn.enabled = YES;
        
    }
    
    
}

#pragma mark-- 准备预约按钮
- (void)updatePrepareButtonToApplyStatus:(NSString *)text isCancel:(BOOL)cancel
{
    //赋值当前排队人数
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [self.currentNumLabel setAttributedText:attributedString];
    
    
    //假如取消
    if (cancel) {
        
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(0, 4)];              // 取消预约
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11.0] range:NSMakeRange(5, text.length - 5)];    // 前面 x 人
        
        [self.payPlayBtn setImage:[UIImage imageNamed:@"guanzhan_quxiaoyuyue_button"] forState:UIControlStateNormal];
        
    }else{
        
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(0, 5)];              // 预约抓娃娃
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11.0] range:NSMakeRange(6, text.length - 6)];    // 当前排队 x 人
        
        [self.payPlayBtn setImage:[UIImage imageNamed:@"dianjikaixiang_button"] forState:UIControlStateNormal];
        
    }
    
    
}

//无人排队下开始游戏按钮状态
- (void)updatePrepareButtonToStartStatus:(NSString *)text {
    //    [self.currentNumLabel setAttributedTitle:nil forState:UIControlStateNormal];
    //    [self.currentNumLabel setTitle:text forState:UIControlStateNormal];
    //    [self.currentNumLabel setBackgroundImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
    self.currentNumLabel.text = text;
}

#pragma mark-- 监听网络状态
- (void)updateQuality:(ZegoApiPlayQuality)quality
{
    self.networkQualityView.quality = quality;
    self.hintView.quality = quality;
    
}

#pragma mark-- 定时器相关

//获取当前事件
- (NSInteger)timestamp {
    NSDate *date = [NSDate date];
    NSTimeInterval interval = floor([date timeIntervalSince1970]);
    if (!interval) {
        return 0;
    }
    return interval;
}

//预约游戏(申请排队)定时器
- (void)startApplyTimer {
    [self.applyTimer invalidate];
    
    //记录申请排队的开始时间
    self.applyTimestamp = [self timestamp];
    
    //创建排队定时器
    if (!self.applyTimer) {
        self.applyTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(onApplyTimerAction:) userInfo:nil repeats:YES];
    }
    //超时比对计时
    clientSeq ++;
    
    //开启定时器
    [self.applyTimer fire];
    
    [[YRJoyGameNetTool shareManger] addLog: NSLocalizedString(@"启动 apply 定时器", nil)];
}
//定时申请排队调用这个方法
- (void)onApplyTimerAction:(NSTimer *)timer {
    
    //获取当前时间戳
    NSInteger current = [self timestamp];
    
    //拼接参数
    NSString *applyCommand = [self.command apply:clientSeq];
    
    //记录当前排队时间
    self.applySeq = clientSeq;
    
    
    if (![self.receivedReplyCounts[applyKey] integerValue]) {
        //表示前面没有人预约排队 就是你来想上面申请排队了
        if (current - self.applyTimestamp >= RETRY_DURATION) {
            
            //当当前时间比最开始申请排队时超过10s 计为排队超时,停止当前排队
            [[YRJoyGameNetTool shareManger] addLog:@"停止 apply 定时器"];
            //销毁定时器
            [self.applyTimer invalidate];
            self.applyTimer = nil;
            
            //时间二中申请排队延时为1
            self.replyTimeout[applyKey] = @1;
            //设置当前机器状态,同时重置按钮状态文字
            self.machineState = ZegoClientStateInitial;
            
            NSLog(@"current state-apply：%ld", (long)self.machineState);
            
            // 发送预约指令超过重试次数，弹框提示，恢复预约按钮可操作状态
            UIAlertController *alertVc = [YRBasicVc showAlert:NSLocalizedString(@"预约超时，请稍后重试", nil) title:NSLocalizedString(@"提示", nil)];
            
            [self presentViewController:alertVc animated:YES completion:nil];
            
        } else {
            //当当前时间比最开始申请排队时超过10s 计为排队超时,停止当前排队
            
            //APi发送排队指令
            BOOL invokeSuccess = [[ZegoManager api] sendCustomCommand:@[self.serverUser] content:applyCommand completion:^(int errorCode, NSString *roomID) {
                NSLog(@"%@", [NSString stringWithFormat:@"[COMMAND] CMD_APPLY 发送结果：%d(0成功)，第 %ld 次发送", errorCode, (current - self.applyTimestamp) / 2 + 1]);
                [SVProgressHUD showInfoWithStatus:@"恭喜!预约成功"];
            }];
            
            //FiXME:这里添加了停止和销毁定时器代码
            [[YRJoyGameNetTool shareManger] addLog:@"停止 apply 定时器"];
            //销毁定时器
            [self.applyTimer invalidate];
            self.applyTimer = nil;
            
            NSLog(@"%@", [NSString stringWithFormat:@"[COMMAND] CMD_APPLY 调用结果：%d(1成功)，第 %ld 次发送", invokeSuccess, (current - self.applyTimestamp) / 2 + 1]);
        }
    } else {
        
        //你前面还有人在预约排队
        [[YRJoyGameNetTool shareManger] addLog: NSLocalizedString(@"预约后收到预约确认 reply，停止发送预约命令，等待上机", nil)];
        [[YRJoyGameNetTool shareManger] addLog:@"停止 apply 定时器"];
        [self.applyTimer invalidate];
        self.applyTimer = nil;
    }
}

//开始取消排队申请定时器
- (void)startCancelApplyTimer {
    
    [self.cancelApplyTimer invalidate];
    
    //记录开始取消时的事件
    self.cancelApplyTimestamp = [self timestamp];
    
    if (!self.cancelApplyTimer) {
        self.cancelApplyTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(onCancelApplyTimerAction:) userInfo:nil repeats:YES];
    }
    
    [self.cancelApplyTimer fire];
    
    [[YRJoyGameNetTool shareManger] addLog: NSLocalizedString(@"启动 cancel apply 定时器", nil)];
}

- (void)onCancelApplyTimerAction:(NSTimer *)timer {
    
    //获取当前事件
    NSInteger current = [self timestamp];
    
    //拼接请求取消排队的消息体
    NSString *cancelApplyCommand = [self.command cancelApply:clientSeq];
    
    self.cancelApplySeq = clientSeq;
    
    if (![self.receivedReplyCounts[cancelApplyKey] integerValue]) {
        
        //设置取消排队超时时间
        if (current - self.cancelApplyTimestamp >= RETRY_DURATION) {
            
            [self.cancelApplyTimer invalidate];
            self.cancelApplyTimer = nil;
            
            self.replyTimeout[cancelApplyKey] = @1;
            
            NSLog(@"current state-cancel apply: %ld", (long)self.machineState);
            
            //更改当前状态
            if (self.machineState == ZegoClientStateApplyCancelling) {
                UIAlertController *alerVc = [YRBasicVc showAlert:NSLocalizedString(@"取消预约超时，请稍后重试", nil) title:NSLocalizedString(@"提示", nil)];
                
                [self presentViewController:alerVc animated:YES completion:nil];
            }
            
            
            self.payPlayBtn.enabled = YES;
            
            [[YRJoyGameNetTool shareManger] addLog: NSLocalizedString(@"取消预约后等待确认超时", nil)];
        } else {
            //发送请求取消命令
            BOOL invokeSuccess = [[ZegoManager api] sendCustomCommand:@[self.serverUser] content:cancelApplyCommand completion:^(int errorCode, NSString *roomID) {
                NSLog(@"%@", [NSString stringWithFormat:@"[COMMAND] CMD_CANCEL_APPLY 发送结果：%d(0成功)，第 %ld 次发送", errorCode, (current - self.cancelApplyTimestamp) / 2 + 1]);
            }];
            
            NSLog(@"%@", [NSString stringWithFormat:@"[COMMAND] CMD_CANCEL_APPLY 调用结果：%d(1成功)，第 %ld 次发送", invokeSuccess, (current - self.cancelApplyTimestamp) / 2 + 1]);
        }
    } else {
        [[YRJoyGameNetTool shareManger] addLog: NSLocalizedString(@"取消预约后收到确认 reply，停止发送取消预约命令，恢复初始状态", nil)];
        
        self.machineState = ZegoClientStateInitial;
        [self.cancelApplyTimer invalidate];
        self.cancelApplyTimer = nil;
    }
}

//准备开始游戏
- (void)startReadyTimer {
    [self.readyTimer invalidate];
    
    self.readyTimestamp = [self timestamp];
    
    if (!self.readyTimer) {
        self.readyTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onReadyTimerAction:) userInfo:nil repeats:YES];
    }
    
    [self.readyTimer fire];
    
    [[YRJoyGameNetTool shareManger] addLog: NSLocalizedString(@"启动 ready 定时器", nil)];
}

- (void)onReadyTimerAction:(NSTimer *)timer {
    
    NSInteger current = [self timestamp];
    
    //设置超时时间
    if (current - self.readyTimestamp >= RETRY_DURATION) {
        // 停止并释放定时器
        [self.readyTimer invalidate];
        self.readyTimer = nil;
        
        // 倒计时结束，没有点击任何按钮，默认为不上机
        self.confirm = 0;
        //        self.receivedReplyCounts[resultKey] = 0;
        [self.readyView removeFromSuperview];
        
        NSLog(@"current timer: %@", self.readyTimer);
        NSLog(@"current state-ready: %ld", (long)self.machineState);
        [[YRJoyGameNetTool shareManger] addLog: NSLocalizedString(@"等待用户确认上机计时结束，用户未做任何操作", nil)];
        
        self.machineState = ZegoClientStateInitial;
    } else {
        self.readyView.startButtonTitle = [NSString stringWithFormat:NSLocalizedString(@"开始游戏(%ds)", nil), RETRY_DURATION - (current - self.readyTimestamp)];
    }
}

//开始玩游戏
- (void)startPlayTimer {
    [self.playTimer invalidate];
    
    self.playTimestamp = [self timestamp];
    if (!self.playTimer) {
        self.playTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onPlayTimerAction:) userInfo:nil repeats:YES];
    }
    [self.playTimer fire];
    
    [[YRJoyGameNetTool shareManger] addLog: NSLocalizedString(@"启动 play 定时器，开始游戏", nil)];
}

- (void)onPlayTimerAction:(NSTimer *)timer {
    NSInteger current = [self timestamp];
    if (current - self.playTimestamp > PLAY_DURATION) {
        // 停止并释放定时器
        [self.playTimer invalidate];
        self.playTimer = nil;
        //        [self stopTimer:self.playTimer];
        
        NSLog(@"current state-play: %ld", (long)self.machineState);
        [[YRJoyGameNetTool shareManger] addLog: NSLocalizedString(@"游戏倒计时结束，自动抓娃娃", nil)];
        
        // 倒计时结束，自动发送抓娃娃指令
        [self beginCaptureBtnDidClicked:nil];
    } else {
        //设置游戏倒计时时间
        self.gameoverTimeLabel.text = [NSString stringWithFormat:@"%lds", PLAY_DURATION - (current - self.playTimestamp)];
    }
}

#pragma mark-- 用户排队完成,并且轮动用户上机,而且用户点击了确认上机的按钮下(:发送上机请求)
- (void)startConfirmTimer {
    [self.confirmTimer invalidate];
    
    self.confirmTimestamp = [self timestamp];
    
    if (!self.confirmTimer) {
        self.confirmTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(onConfirmTimerAction:) userInfo:nil repeats:YES];
    }
    [self.confirmTimer fire];
    
    [[YRJoyGameNetTool shareManger] addLog: NSLocalizedString(@"启动 confirm 定时器，发送用户确认游戏与否信息", nil)];
}


- (void)onConfirmTimerAction:(NSTimer *)timer {
    NSInteger current = [self timestamp];
    NSString *confirm = [self.command gameConfirm:self.confirm clientSeq:clientSeq];
    self.confirmSeq = clientSeq;
    
    //验证用户是否确认开始游戏
    if ([self.receivedReplyCounts[confirmKey] integerValue]) {
        if (self.confirm) {
            // 收到回复且上机成功，才能进行操作
            if (self.isOperating) {
                [self.confirmTimer invalidate];
                self.confirmTimer = nil;
                
                // 开始上机，更新界面
                [[YRJoyGameNetTool shareManger] addLog: NSLocalizedString(@"用户开始上机，更新界面为可操作", nil)];
                //判断房间是否登录成功
                if (self.loginRoomSucceed) {
                    self.machineState = ZegoClientStateGamePlaying;
                    
                    //显示操作界面
                    [self setControlViewVisible:YES];
                    
                    // 确认上机，启动游戏计时器
                    if (self.serverUser) {
                        [self startPlayTimer];
                    }
                }
            }
        } else {
            [self.confirmTimer invalidate];
            self.confirmTimer = nil;
            
            self.machineState = ZegoClientStateInitial;
            [[YRJoyGameNetTool shareManger] addLog: NSLocalizedString(@"用户取消上机，恢复预约状态", nil)];
        }
    }
    
    if (current - self.confirmTimestamp >= RETRY_DURATION) {
        // 超时，停止并释放定时器
        [self.confirmTimer invalidate];
        self.confirmTimer = nil;
        
        self.machineState = ZegoClientStateInitial;
        self.replyTimeout[confirmKey] = @1;
        
        // 倒计时结束，弹框提示
        NSLog(@"current state-confirm: %ld", (long)self.machineState);
        if (self.confirm) {
            UIAlertController *alertV = [YRBasicVc showAlert:NSLocalizedString(@"上机超时，请重新开始游戏", nil) title:NSLocalizedString(@"提示", nil)];
            
            [self presentViewController:alertV animated:YES completion:nil];
        } else {
            UIAlertController *alertV = [YRBasicVc showAlert:NSLocalizedString(@"放弃上机超时，请重新开始游戏", nil) title:NSLocalizedString(@"提示", nil)];
            
            [self presentViewController:alertV animated:YES completion:nil];
        }
    } else {
        if (![self.receivedReplyCounts[confirmKey] integerValue]) {
            BOOL invokeSuccess = [[ZegoManager api] sendCustomCommand:@[self.serverUser] content:confirm completion:^(int errorCode, NSString *roomID) {
                NSLog(@"%@", [NSString stringWithFormat:@"[COMMAND] CMD_GAME_CONFIRM 发送结果：%d(0成功)，第 %ld 次发送", errorCode, (current - self.confirmTimestamp) / 2 + 1]);
            }];
            
            NSLog(@"%@", [NSString stringWithFormat:@"[COMMAND] CMD_GAME_CONFIRM 调用结果：%d(1成功)，第 %ld 次发送", invokeSuccess, (current - self.confirmTimestamp) / 2 + 1]);
        } else {
            [[YRJoyGameNetTool shareManger] addLog: NSLocalizedString(@"客户端收到用户上机与否 reply，停止发送用户上机与否信息", nil)];
        }
    }
}

//游戏完成,显示结果,等待用户操作
- (void)startResultTimer {
    [self.resultTimer invalidate];
    
    self.resultTimestamp = [self timestamp];
    if (!self.resultTimer) {
        self.resultTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(onResultTimerAction:) userInfo:nil repeats:YES];
    }
    
    [self.resultTimer fire];
    
    [[YRJoyGameNetTool shareManger] addLog: NSLocalizedString(@"启动 result 定时器，等待游戏结果", nil)];
}

- (void)onResultTimerAction:(NSTimer *)timer {
    NSInteger current = [self timestamp];
    if (![self.receivedReplyCounts[resultKey] integerValue]) {
        if (current - self.resultTimestamp > RESULT_DURATION) {
            // 停止并释放定时器
            [self.resultTimer invalidate];
            self.resultTimer = nil;
            
            //            if (self.isOperating) {
            //                [self offBoard];
            //                self.isOperating = NO;
            //            }
            
            [[YRJoyGameNetTool shareManger] addLog: NSLocalizedString(@"用户获取结果超时，自动下机", nil)];
            
            // 倒计时结束，没有收到结果
            NSLog(@"current state-result: %ld", (long)self.machineState);
            
            
            
            UIAlertController *alertV = [YRBasicVc showAlert:NSLocalizedString(@"获取游戏结果超时", nil) title:NSLocalizedString(@"提示", nil)];
            
            [self presentViewController:alertV animated:YES completion:nil];
            
            [self setPrepareButtonVisible:YES];
            self.machineState = ZegoClientStateInitial;
        }
    }
}

#pragma mark-- 流操作 (开始游戏,切换低延迟流)

- (void)onBoard {
    [ZegoLiveRoomApi setConfig:@"prefer_play_ultra_source=1"];
    [self switchStream];
}

- (void)offBoard {
    [ZegoLiveRoomApi setConfig:@"prefer_play_ultra_source=0"];
}

- (void)switchStream {
    // 停止播放所有的流
    if (self.firstStreamID.length) {
        [[ZegoManager api] stopPlayingStream:self.firstStreamID];
        [self.fristPlayView setBackgroundColor:[UIColor whiteColor]];
    }
    
    if (self.secondStreamID.length) {
        [[ZegoManager api] stopPlayingStream:self.secondStreamID];
        [self.secondPlayView setBackgroundColor:[UIColor whiteColor]];
    }
    
    if (self.currentVisibleStreamIndex == 1) {
        [self playVisibleStream:self.firstStreamID inView:self.fristPlayView];
        [self playInvisibleStream:self.secondStreamID inView:self.secondPlayView];
    } else {
        [self playVisibleStream:self.secondStreamID inView:self.secondPlayView];
        [self playInvisibleStream:self.firstStreamID inView:self.fristPlayView];
    }
}

#pragma mark-- 操作界面显示还是支付界面显示 Yes为操作界面隐藏
- (void)setControlViewVisible:(BOOL)visible
{
    self.gameButtomView.hidden = !visible;
    
    self.forwardButton.enabled = visible;
    self.backwardButton.enabled = visible;
    self.leftwardButton.enabled = visible;
    self.rightwardButton.enabled = visible;
    
    self.moneyButtomView.hidden = !self.gameButtomView.hidden;
    
}
//隐藏游戏界面 显示开始预约界面
- (void)setPrepareButtonVisible:(BOOL)visible
{
    self.moneyButtomView.hidden = !visible;
    
    self.payPlayBtn.enabled = visible;
    
    self.gameButtomView.hidden = !self.moneyButtomView.hidden;
}

#pragma mark - ZegoLivePlayerDelegate 房间拉流代理 这里有当前流的状态信息
- (void)onPlayStateUpdate:(int)stateCode streamID:(NSString *)streamID {
    //添加提示  stateCode == 0表示直播正常
    
    if (stateCode == 0) {
        if (_defaultBackV) {
            [_defaultBackV removeFromSuperview];
        }
        //打印信息
        [[YRJoyGameNetTool shareManger] addLog: [NSString stringWithFormat:NSLocalizedString(@"拉流成功，流 ID：%@", nil), streamID]];
        
        //判断是那一条流
        if ([streamID isEqualToString:self.firstStreamID]) {//第一条
            [self.flowOneRemindV removeFromSuperview];
            self.firstStreamStatus = ZegoStreamStatusPlaySucceed;
        } else {
            [self.flowTwoRemindV removeFromSuperview];
            self.secondStreamStatus = ZegoStreamStatusPlaySucceed;
        }
    } else {
        [[YRJoyGameNetTool shareManger] addLog: [NSString stringWithFormat:NSLocalizedString(@"拉流失败，流 ID：%@，错误码：%d", nil), streamID, stateCode]];
        
        if ([streamID isEqualToString:self.firstStreamID]) {
            self.firstStreamStatus = ZegoStreamStatusPlayFail;
            [self.fristPlayView addSubview:self.flowOneRemindV];
        } else {
            self.secondStreamStatus = ZegoStreamStatusPlayFail;
            [self.secondPlayView addSubview:self.flowTwoRemindV];
        }
    }
}



- (void)onPlayQualityUpate:(NSString *)streamID quality:(ZegoApiPlayQuality)quality {
//        NSLog(@"current video kbps: %f, streamID: %@, quality: %d", quality.kbps, streamID, quality.quality);
    
    if (self.currentVisibleStreamIndex == 1 && [streamID isEqualToString:self.firstStreamID]) {
        [self updateQuality:quality];
    }
    
    if (self.currentVisibleStreamIndex == 2 && [streamID isEqualToString:self.secondStreamID]) {
        [self updateQuality:quality];
    }
    
    /** 不处理空流情况
     if (quality.kbps < 0.00001) {
     // 播放成功，但流数据为空（CDN 支持拉空流）
     [self addLog: [NSString stringWithFormat:NSLocalizedString(@"没有流数据，请确认已成功推流，流 ID：%@", nil), streamID]];
     
     if ([streamID isEqualToString:self.firstStreamID]) {
     self.firstStreamStatus = ZegoStreamStatusPlaySucceedEmpty;
     
     if (self.currentVisibleStreamIndex == 1) {
     [[ZegoManager api] updatePlayView:nil ofStream:self.firstStreamID];
     [self addPlayStatusImage:[UIImage imageNamed:@"DeviceOff-1"] inView:self.firstPlayView];
     }
     } else {
     self.secondStreamStatus = ZegoStreamStatusPlaySucceedEmpty;
     
     if (self.currentVisibleStreamIndex == 2) {
     [[ZegoManager api] updatePlayView:nil ofStream:self.secondStreamID];
     [self addPlayStatusImage:[UIImage imageNamed:@"DeviceOff-2"] inView:self.secondPlayView];
     }
     }
     } else {
     // 播放成功，流数据更新为非空
     //        [self addLog: [NSString stringWithFormat:NSLocalizedString(@"获取到流数据，流 ID：%@", nil), streamID]];
     
     if ([streamID isEqualToString:self.firstStreamID]) {
     if (self.firstStreamStatus == ZegoStreamStatusPlaySucceedEmpty) {   // 状态由 succeedEmpty 转换到 succeed
     [[ZegoManager api] updatePlayView:self.firstPlayView ofStream:self.firstStreamID];
     
     if (self.currentVisibleStreamIndex == 1) {
     [self removePlayStatusImage:self.firstPlayView];
     [self updateStreamToVisible:self.firstStreamID inView:self.firstPlayView];
     }
     
     self.firstStreamStatus = ZegoStreamStatusPlaySucceed;
     }
     } else {
     if (self.secondStreamStatus == ZegoStreamStatusPlaySucceedEmpty) {
     [[ZegoManager api] updatePlayView:self.secondPlayView ofStream:self.secondStreamID];
     
     if (self.currentVisibleStreamIndex == 2) {
     [self removePlayStatusImage:self.secondPlayView];
     [self updateStreamToVisible:self.secondStreamID inView:self.secondPlayView];
     }
     
     self.secondStreamStatus = ZegoStreamStatusPlaySucceed;
     }
     }
     }
     **/
}


#pragma mark-- 添加play状态视图
- (void)removePlayStatusImage:(UIView *)view {
    
//    FIXME: 待修改
        for (UIView *sub in view.subviews) {
            if ([sub isKindOfClass:[UIImageView class]]) {
                [sub removeFromSuperview];
            }
        }
}



//
- (void)addPlayStatusImage:(UIImage *)image inView:(UIView *)view {
    [self removePlayStatusImage:view];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = image;
    [view addSubview:imageView];
    [view bringSubviewToFront:imageView];
    [imageView setTranslatesAutoresizingMaskIntoConstraints: NO];
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1.0 constant:145];
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:184];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:209];
    
    NSArray *array = [NSArray arrayWithObjects:top, centerX, width, height, nil];
    [view addConstraints: array];
    
}

#pragma mark - ZegoRoomDelegate

//断开通知
- (void)onDisconnect:(int)errorCode roomID:(NSString *)roomID {
    if ([roomID isEqualToString:self.roomItem.roomid]) {
        
        UIAlertController *alertController = [YRBasicVc showAlert:[NSString stringWithFormat:@"连接失败，错误码：%d", errorCode] title:NSLocalizedString(@"提示", nil)];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
//房间连接中断
- (void)onTempBroken:(int)errorCode roomID:(NSString *)roomID {
    // TODO
}
//重连成功通知
- (void)onReconnect:(int)errorCode roomID:(NSString *)roomID {
    if ([roomID isEqualToString:self.roomItem.roomid] && errorCode == 0) {
        // TODO
    }
}

//房间内增加流、删除流，均会触发此更新。建议对流增加和流删除分别采取不同的处理
- (void)onStreamUpdated:(int)type streams:(NSArray<ZegoStream *> *)streamList roomID:(NSString *)roomID {
    for (ZegoStream *stream in streamList) {
        if ([stream.streamID hasPrefix:@"WWJ"]) {
            if ([stream.streamID hasSuffix:@"_2"]) {
                self.secondStreamID = stream.streamID;
                if (self.currentVisibleStreamIndex == 2) {
                    [self playVisibleStream:self.secondStreamID inView:self.secondPlayView];
                } else {
                    [self playInvisibleStream:self.secondStreamID inView:self.secondPlayView];
                }
            } else {
                self.firstStreamID = stream.streamID;
                if (self.currentVisibleStreamIndex == 1) {
                    [self playVisibleStream:self.firstStreamID inView:self.secondPlayView];
                } else {
                    [self playInvisibleStream:self.firstStreamID inView:self.secondPlayView];
                }
            }
        }
    }
}

- (void)onStreamExtraInfoUpdated:(NSArray<ZegoStream *> *)streamList roomID:(NSString *)roomID {
    
}

/**
 收到自定义消息
 
 @param fromUserID 消息来源 UserID
 @param fromUserName 消息来源 UserName
 @param content 消息内容
 @param roomID 房间 ID
 @discussion 调用 [ZegoLiveRoomApi -sendCustomCommand:content:completion:] 发送自定义消息后，消息列表中的用户会收到此通知
 */
- (void)onReceiveCustomCommand:(NSString *)fromUserID userName:(NSString *)fromUserName content:(NSString *)content roomID:(NSString *)roomID {
    // 校验 serverUser
    if (self.serverUser && [fromUserID isEqualToString:self.serverUser.userId]) {
        // 校验房间
        if (roomID && self.roomItem.roomid && [roomID isEqualToString:self.roomItem.roomid]) {
            NSDictionary *dict = [[YRJoyGameNetTool shareManger] decodeJSONToDictionary:content];
            NSInteger command = [dict[@"cmd"] integerValue];
            NSDictionary *data = dict[@"data"];
            
            // server 回复收到预约申请，并告知预约结果（Server-->Client）
            if (command == CMD_APPLY_REPLY) {
                [[YRJoyGameNetTool shareManger] addLog: [NSString stringWithFormat:@"[RECEIVED] CMD_APPLY_REPLY, %@", content]];
                
                if (self.machineState == ZegoClientStateApplying && ![self.replyTimeout[applyKey] intValue]) {
                    NSInteger result = [data[@"result"] integerValue];
                    NSDictionary *player = data[@"player"];
                    NSString *userId = player[@"id"];
                    NSInteger seq = [data[@"seq"] integerValue];
                    NSInteger index = [data[@"index"] integerValue];
                    
                    // 去重后台回复的多条同一 seq 的 apply reply
                    NSInteger repeat = [self.receivedReplyCounts[applyKey] integerValue];
                    
                    if (seq == self.applySeq && !repeat) {
                        if ([userId isEqualToString:[ZegoSetting sharedInstance].userID]) {
                            
                            //表示接收到排队结果,结束排队请求发送
                            self.receivedReplyCounts[applyKey] = @1;
                            
                            if (result == 0) {
                                [[YRJoyGameNetTool shareManger] addLog: @"客户端收到预约申请 reply，预约成功"];
                                
                                self.machineState = ZegoClientStateGameWaiting;
                                
                                // 当前正在游戏的人，也在排队之列
                                [self updatePrepareButtonToApplyStatus:[NSString stringWithFormat:NSLocalizedString(@"取消预约\n前面 %d 人", nil), index] isCancel:YES];
                                self.payPlayBtn.enabled = YES;
                            } else {
                                [[YRJoyGameNetTool shareManger] addLog: @"客户端收到预约申请 reply，预约失败"];
                                
                                if (self.machineState == ZegoClientStateApplying) {
                                    
                                    UIAlertController *alertController =  [YRBasicVc showAlert:NSLocalizedString(@"预约失败，请稍后重试", nil) title:NSLocalizedString(@"提示", nil)];
                                    
                                    [self presentViewController:alertController animated:YES completion:nil];
                                }
                                
                                self.machineState = ZegoClientStateInitial;
                            }
                        }
                    }
                }
            }
            
            if (command == CMD_CANCEL_APPLY_REPLY) {
                [[YRJoyGameNetTool shareManger] addLog: [NSString stringWithFormat:@"[RECEIVED] CMD_CANCEL_APPLY_REPLY, %@", content]];
                
                if (self.machineState == ZegoClientStateApplyCancelling && ![self.replyTimeout[cancelApplyKey] intValue]) {
                    NSInteger seq = [data[@"seq"] integerValue];;
                    
                    // 去重后台回复的多条同一 seq 的 apply reply
                    NSInteger repeat = [self.receivedReplyCounts[cancelApplyKey] integerValue];
                    
                    if (seq == self.cancelApplySeq && !repeat) {
                        self.receivedReplyCounts[cancelApplyKey] = @1;
                    }
                }
            }
            
            // 通知某人准备上机, 此时用户可使用 CMD_ABANDON_PLAY 放弃游戏（Server-->Client）
            if (command == CMD_GAME_READY) {
                [[YRJoyGameNetTool shareManger] addLog: [NSString stringWithFormat:@"[RECEIVED] CMD_GAME_READY, %@", content]];
                
                // ready 先于 apply reply 收到
                if (self.machineState == ZegoClientStateApplying) {
                    self.machineState = ZegoClientStateGameWaiting;
                    
                    // 不再发送 apply
                    [[YRJoyGameNetTool shareManger] addLog:@"停止 apply 定时器"];
                    [self.applyTimer invalidate];
                    self.applyTimer = nil;
                }
                
                if (![self.replyTimeout[applyKey] intValue] && (self.machineState == ZegoClientStateGameWaiting || self.machineState == ZegoClientStateApplyCancelling)) {
                    [[YRJoyGameNetTool shareManger] addLog: @"客户端收到允许上机，状态吻合"];
                    
                    NSInteger seq = [dict[@"seq"] intValue];
                    NSDictionary *player = data[@"player"];
                    NSString *userId = player[@"id"];
                    
                    // 过滤同一个 seq 的通知
                    if (self.gameReadySeq != seq) {
                        self.gameReadySeq = (int)seq;
                        
                        if ([userId isEqualToString:[ZegoSetting sharedInstance].userID]) {
                            
                            // 向服务回复收到 CMD_GAME_READY_REPLY 命令，否则服务器会一直重试发送
                            clientSeq ++;
                            NSString *gameReadyReplyCommand = [self.command gameReadyReply:clientSeq serverSeq:self.gameReadySeq];
                            if (self.serverUser) {
                                BOOL invokeSuccess = [[ZegoManager api] sendCustomCommand:@[self.serverUser] content:gameReadyReplyCommand completion:^(int errorCode, NSString *roomID) {
                                    [[YRJoyGameNetTool shareManger] addLog: [NSString stringWithFormat:NSLocalizedString(@"[COMMAND] CMD_READY_REPLY 发送结果: %d（0成功）", nil), errorCode]];
                                }];
                                
                                [[YRJoyGameNetTool shareManger] addLog: [NSString stringWithFormat:NSLocalizedString(@"[COMMAND] CMD_READY_REPLY 调用结果: %d（1成功）", nil), invokeSuccess]];
                            }
                            
                            // 弹出是否继续游戏 view
                            self.readyView = [[[NSBundle mainBundle] loadNibNamed:@"ZegoReadyView" owner:nil options:nil] firstObject];
                            self.readyView.delegate = self;
                            self.readyView.frame = self.view.frame;
                            [self.view addSubview:self.readyView];
                            
                            // 上机弹框出现，启动上机确认计时器
                            if (self.serverUser) {
                                [self startReadyTimer];
                            }
                        }
                    }
                }
            }
            
            // 回复收到确认上机或者放弃玩游戏指令（Server-->Client）
            if (command == CMD_CONFIRM_REPLY) {
                [[YRJoyGameNetTool shareManger] addLog: [NSString stringWithFormat:@"[RECEIVED] CMD_CONFIRM_REPLY, %@", content]];
                
                NSInteger seq = [data[@"seq"] intValue];
                
                if (self.machineState == ZegoClientStateGameConfirming && ![self.replyTimeout[confirmKey] intValue]) {
                    // 去重后台回复的多条同一 seq 的 apply reply
                    NSInteger repeat = [self.receivedReplyCounts[confirmKey] integerValue];
                    
                    if (seq == self.confirmSeq && !repeat) {
                        [[YRJoyGameNetTool shareManger] addLog: NSLocalizedString(@"客户端收到确认上机与否 reply，状态吻合", nil)];
                        self.receivedReplyCounts[confirmKey] = @1;
                    }
                }
            }
            
            // 全员广播房间信息（总人数，排队列表、当前游戏者）更新（Server-->Client）
            if (command == CMD_USER_UPDATE) {
                [[YRJoyGameNetTool shareManger] addLog: [NSString stringWithFormat:@"[RECEIVED] CMD_USER_UPDATE, %@", content]];
                
                // 当前正在玩游戏的人
                NSDictionary *player = data[@"player"];
                if (player.count) {
                    NSString *playerId = player[@"id"];
                    self.currentPlayer = playerId;
                } else {
                    self.currentPlayer = nil;
                }
                
                // 房间排队列表
                NSArray *queueList = data[@"queue"];
                self.queueCount = queueList.count;
                
                self.totalCount = [data[@"total"] integerValue];
                self.totalLabel.text = [NSString stringWithFormat: NSLocalizedString(@"%d人在房间", nil), self.totalCount];
                
                // 如果用户在取消预约状态，收到用户更新中，含有本人，说明取消预约失败
                int exist = 0;
                int currentIndex = 0;
                
                if (queueList.count) {
                    for (int i = 0; i < queueList.count; i++) {
                        NSString *userId = [queueList[i] objectForKey:@"id"];
                        if (userId && [userId isEqualToString:[ZegoSetting sharedInstance].userID]) {
                            currentIndex = i;
                            exist ++;
                        }
                    }
                }
                
                // 取消预约已超时
                if (self.machineState == ZegoClientStateApplyCancelling && [self.replyTimeout[cancelApplyKey] intValue]) {
                    if (exist) {
                        [[YRJoyGameNetTool shareManger] addLog: NSLocalizedString(@"取消预约超时后，排队列表中仍有当前用户，取消预约失败", nil)];
                        self.machineState = ZegoClientStateGameWaiting;
                    } else {
                        [[YRJoyGameNetTool shareManger] addLog: NSLocalizedString(@"取消预约超时后，排队列表中没有当前用户，取消预约成功", nil)];
                        self.machineState = ZegoClientStateInitial;
                    }
                }
                
                if (self.machineState == ZegoClientStateGameWaiting) {
                    // 当前正在游戏的人，也算在排队人数之列
                    [self updatePrepareButtonToApplyStatus:[NSString stringWithFormat:NSLocalizedString(@"取消预约\n前面 %d 人", nil), currentIndex + 1] isCancel:YES];
                }
                
                if (self.machineState == ZegoClientStateInitial) {
                    if (self.queueCount || (self.queueCount == 0 && self.currentPlayer.length && ![self.currentPlayer isEqualToString:[ZegoSetting sharedInstance].userID])) {
                        // 当前正在游戏的人，也算在排队人数之列
                        [self updatePrepareButtonToApplyStatus:[NSString stringWithFormat:NSLocalizedString(@"预约抓娃娃\n当前排队 %d 人", nil), self.queueCount + 1] isCancel:NO];
                    } else {
                        [self updatePrepareButtonToStartStatus:NSLocalizedString(@"开始游戏", nil)];
                    }
                    self.payPlayBtn.enabled = YES;
                    
                }
            }
            
            // 收到游戏结果
            if (command == CMD_GAME_RESULT) {
                [[YRJoyGameNetTool shareManger] addLog: [NSString stringWithFormat:@"[RECEIVED] CMD_GAME_RESULT, %@", content]];
                
                if (self.machineState == ZegoClientStateResultWaiting) {
                    [[YRJoyGameNetTool shareManger] addLog: NSLocalizedString(@"客户端收到游戏结果，状态吻合", nil)];
                    
                    int seq = [dict[@"seq"] intValue];
                    NSDictionary *player = data[@"player"];
                    NSString *userId = player[@"id"];
                    NSInteger result = [data[@"result"] integerValue];
                    
                    if (self.gameResultSeq!= seq) {
                        self.gameResultSeq = seq;
                        
                        [[YRJoyGameNetTool shareManger] addLog:[NSString stringWithFormat:@"gameResult-player-id: %@", userId]];
                        
                        if ([userId isEqualToString:[ZegoSetting sharedInstance].userID]) {
                            self.receivedReplyCounts[resultKey] = @1;
                            
                            [self.resultTimer invalidate];
                            self.resultTimer = nil;
                            
                            // 向服务器回复收到 CMD_GAME_RESULT 命令
                            clientSeq ++;
                            NSString *gameResultReplyCommand = [self.command resultReply:clientSeq serverSeq:self.gameResultSeq];
                            if (self.serverUser) {
                                BOOL invokeSuccess =  [[ZegoManager api] sendCustomCommand:@[self.serverUser] content:gameResultReplyCommand completion:^(int errorCode, NSString *roomID) {
                                    [[YRJoyGameNetTool shareManger] addLog: [NSString stringWithFormat: NSLocalizedString(@"[COMMAND] GAME_RESULT_REPLY 发送结果：%d（0成功）", nil), errorCode]];
                                }];
                                
                                [[YRJoyGameNetTool shareManger] addLog: [NSString stringWithFormat: NSLocalizedString(@"[COMMAND] GAME_RESULT_REPLY 调用结果：%d（1成功）", nil), invokeSuccess]];
                            }
                            
//                            ZegoResultView *resultView = [[[NSBundle mainBundle] loadNibNamed:@"ZegoResultView" owner:nil options:nil] firstObject];
//                            resultView.delegate = self;
//                            resultView.frame = self.view.frame;
                           
                            
                            if (result == 1) {
//                                resultView.imageName = @"success";
                                
                                YRCaptureSuccessView *successV = [YRCaptureSuccessView createViewFromNib];
                                
                                successV.captureSuccessDelegete = self;
                                
                                [successV showInController:self preferredStyle:TYAlertControllerStyleAlert transitionAnimation:TYAlertTransitionAnimationFade backgoundTapDismissEnable:YES];
                                
                            } else {
//                                resultView.imageName = @"failure";
                                
                                YRCaptureFailView *failV = [YRCaptureFailView createViewFromNib];
                                
                                failV.captureFailDelegete = self;
                                
                                
                                [failV showInController:self preferredStyle:TYAlertControllerStyleAlert transitionAnimation:TYAlertTransitionAnimationFade backgoundTapDismissEnable:YES];
                            }
                            
//                            [self.view addSubview:resultView];
                            //                        [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:25 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            //                            resultView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                            //                        } completion:nil];
                            
                            //                        if (self.isOperating) {
                            //                            [self offBoard];
                            //                            self.isOperating = NO;
                            //                        }
                            
                            [[YRJoyGameNetTool shareManger] addLog: NSLocalizedString(@"用户获取到结果，自动下机", nil)];
                        }
                    }
                }
            }
        }
    }
    
}

#pragma mark - ZegoResultViewDelegate

- (void)resultButtonClicked:(UIButton *)button {
    [self setPrepareButtonVisible:YES];
    self.machineState = ZegoClientStateInitial;
}

#pragma mark-- 抓取失败视图点击
- (void)captureFailThencustomWantToPlayAgainWithType:(choiceType)chiceType
{
    [self setPrepareButtonVisible:YES];
    
    self.machineState = ZegoClientStateInitial;
    
    if (chiceType == CapturePlayAgain) {
        
        //继续排队
        [self startGameBtnDidClicked:nil];
        
    }
    
}

- (void)captureSuccessThencustomWantToPlayAgainWithType:(choiceSuccessType)chiceType
{
    [self setPrepareButtonVisible:YES];
    
    self.machineState = ZegoClientStateInitial;
    
    if (chiceType == CapturePlaySuccessShared) {
        
        [self shareImageToPlatformType:UMSocialPlatformType_WechatSession andThumbImg:[UIImage imageNamed:@"xiaoxin"] andShareImg:[UIImage imageNamed:@"xiaoxin"]];
        
        
//        [SVProgressHUD showInfoWithStatus:@"分享"];
        
    }
}

#pragma mark - ZegoReadyViewDelegate

- (void)onClickCancelButton:(id)sender {
    self.confirm = 0;
    
    self.payPlayBtn.enabled = NO;
    
    self.receivedReplyCounts[confirmKey] = @0;
    self.replyTimeout[confirmKey] = @0;
    [[YRJoyGameNetTool shareManger] addLog: NSLocalizedString(@"用户选择了取消上机", nil)];
    self.machineState = ZegoClientStateGameConfirming;
    
    [self.readyTimer invalidate];
    self.readyTimer = nil;
    
    clientSeq ++;
    [self startConfirmTimer];
}

#pragma mark-- 用户点了开始上机 它要上机了
- (void)onClickStartButton:(id)sender {
    
    if (self.loginRoomSucceed) {
        
        //请求服务器扣分,拿到扣费的结果,来处理
        [self requestDeductionDFee];
        
        
    }
}

#pragma mark-- 请求服务器扣分(嘿哈)

- (void)requestDeductionDFee
{
    //向服务器请求是否可以排队
    [SVProgressHUD showWithStatus:@"开始游戏请求中~"];
    [[GCDAsyncSocketCommunicationManager sharedInstance] noRetrySocketSendWriteDataWithRequestType:GACRequestType_GetRequest_DeductionDFee requestBody:@{@"roomId":self.roomItem.roomid ? : @""} completion:^(NSError * _Nullable error, id  _Nullable data) {
        
        [SVProgressHUD dismiss];
        
        if (error || !data) {
            [SVProgressHUD showErrorWithStatus:@"网络繁忙,请稍后再试"];
            //出现错误取消上机
            [self onClickCancelButton:nil];
            return;
        }
        //FIXME:需要验证结果(这里需要验证结果来判断是否开始和取消上机)
        [self requestJoyMachineBeginGame];
        
    }];
}

//真正的开始游戏
- (void)requestJoyMachineBeginGame
{
    self.confirm = 1;
    
    self.payPlayBtn.enabled = NO;
    
    //用户确定开始游戏
    self.receivedReplyCounts[confirmKey] = @0;
    //开始游戏时间设置为0
    self.replyTimeout[confirmKey] = @0;
    [[YRJoyGameNetTool shareManger] addLog: NSLocalizedString(@"用户选择了上机", nil)];
    //修改用户上机状态
    self.machineState = ZegoClientStateGameConfirming;
    
    // 点击确认就开始切换拉流，而不是等到收到 confirm reply，否则太慢
    if (self.loginRoomSucceed) {
        if (!self.isOperating) {
            [self onBoard];
            self.isOperating = YES;
        }
    }
    //销毁是否开始游戏的倒计时时间
    [self.readyTimer invalidate];
    self.readyTimer = nil;
    
    clientSeq ++;
    [self startConfirmTimer];
}

@end

