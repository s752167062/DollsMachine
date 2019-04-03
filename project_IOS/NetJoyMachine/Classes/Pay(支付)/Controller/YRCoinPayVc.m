//
//  YRCoinPayVc.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/20.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRCoinPayVc.h"
#import "YRPayNetManager.h"
#import "JNetManager.h"
#import "JNetResponse.h"
#import "JNetRequest.h"

@interface YRCoinPayVc ()

//金币数量
@property (weak, nonatomic) IBOutlet UILabel *coinNumL;

//钱
@property (weak, nonatomic) IBOutlet UILabel *coinMoneyL;

//商品背景视图
@property (weak, nonatomic) IBOutlet UIView *coinBackV;

//支付背景视图
@property (weak, nonatomic) IBOutlet UIView *payBackV;

//购买按钮
@property (weak, nonatomic) IBOutlet UIButton *payBtn;


@property (weak, nonatomic) IBOutlet UILabel *describeL;

@property (weak, nonatomic) IBOutlet UILabel *wxPayL;

@property (weak, nonatomic) IBOutlet UILabel *aliPayL;

//是否是微信支付
@property (nonatomic, assign) BOOL isWxPay;

@property (weak, nonatomic) IBOutlet UIButton *wxPayBtn;

@property (weak, nonatomic) IBOutlet UIButton *aliPayBtn;



@end

@implementation YRCoinPayVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"金币兑换";
    
    self.isWxPay = YES;
    
    self.wxPayBtn.selected = YES;
    
    _coinNumL.font = MJBlodTitleFont;
    _coinMoneyL.font = MJBlodTitleFont;
    _wxPayL.font = MJBlodTitleFont;
    _aliPayL.font = MJBlodTitleFont;
    _payBtn.titleLabel.font = MJBlodTitleFont;
    
    self.view.frame = MJKeyWindow.bounds;
    
    [self.view layoutIfNeeded];
    
    [self.payBackV setCornerRadius:MJcommonCornerRadius];
    
    [self.coinBackV.layer setCornerRadius:MJcommonCornerRadius];
    
    [self.payBtn setCornerRadius:self.payBtn.MJ_height * 0.5];
    
    
}

- (void)viewDidLayoutSubviews
{
    
}

- (IBAction)payBtnDidClicked:(UIButton *)sender
{
    if (self.isWxPay)
    {
        //微信支付
        [self postPayRequest:kYRWeiXinPAYStyle];
        
        
        
    }else{
        //支付宝
        [self postPayRequest:kYRAliPayStyle];
        
    }
}

- (void)postPayRequest:(YRPayStyle)payType
{
    YRPayModel *payItem = [[YRPayModel alloc] init];
    
    payItem.goodsId = @"1";
    payItem.goodsNum = @"1";
    
    [[YRPayNetManager shareInstance] sendWebRequestToSDKInitWithPayStyle:payType paymentType:payItem withCompleteBlock:^(NSDictionary *returnValue, BOOL hasError) {
        
        [SVProgressHUD dismiss];
        
        if (hasError) {
            //发生报错
            [self alertMsg:returnValue[@"error"]];
            
        }
        else {
            
            NSLog(@"结果: %@",returnValue);
            
            /***** 启动 HeepaySDK相关代码 ****/
            JNetRequest * payModel = [[JNetRequest alloc] init];
            payModel.token_id = returnValue[@"token_id"];
            payModel.agent_id = returnValue[@"agent_id"];
            payModel.agent_bill_id = returnValue[@"agent_bill_id"];
            NSInteger pay = payType;
            payModel.ptype = pay;
            payModel.schemeStr = @"NetJoyMachine";
            payModel.rootViewController = self;
            
            [JNetManager sendRequest:payModel responseBlock:^(JNetResponse *response) {
                [self alertMsg:[NSString stringWithFormat:@"错误代码:%zd,结果:%@",response.pResult,response.message]];
                
            }];
        }
    }];
        

}

- (void)alertMsg:(NSString *)msg
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}



- (IBAction)weixinPayDidClicked:(UIButton *)sender
{
    [sender setSelected:YES];
    
    self.isWxPay = YES;
    
    self.aliPayBtn.selected = NO;
}

- (IBAction)aliPayClicked:(UIButton *)sender
{
    [sender setSelected:YES];
    
    self.isWxPay = NO;
    
    self.wxPayBtn.selected = NO;
}


@end
