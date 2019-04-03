//
//  YRSettingVc.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/17.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRSettingVc.h"
#import <UMSocialCore/UMSocialCore.h>
#import "YRPayHistoryVc.h"
#import "YRExchangeVc.h"
#import "YRInvitationCodeVc.h"
#import "YRAboutUsVc.h"
#import "YRShipAddressVc.h"
#import "YRLoginVc.h"
#import "UserInfoTool.h"
#import "YRLoginUserModel.h"
#import <UIImageView+WebCache.h>

@interface YRSettingVc ()

@property(nonatomic ,strong)IBOutletCollection(UILabel) NSArray *rightTitleArr;

@property(nonatomic ,strong)IBOutletCollection(UILabel) NSArray *headerArr;

@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;


//用户头像
@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;


//用户名字
@property (weak, nonatomic) IBOutlet UILabel *userName;

@end

@implementation YRSettingVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDefault];
    
    [self setupUI];
    
    //设置信息
    [self setupDefaultMsg];
}

- (void)setupDefaultMsg
{
    YRLoginUserModel *userItem = [UserInfoTool getUserInfo];
    
    [self.iconImageV sd_setImageWithURL:[NSURL URLWithString:userItem.iconurl] placeholderImage:[UIImage imageNamed:@"cat"]];
    
    self.userName.text = userItem.name;
    
}

#pragma mark-- 设置默认值
- (void)setupDefault
{
    self.title = @"个人设置";
    
}

#pragma mark-- 初始化视图
- (void)setupUI
{
    for (UILabel *label in self.rightTitleArr) {
        
        label.font = MJBlodMiddleBobyFont;
        label.textColor = MJBlackColor;
    }
    
    for (UILabel *label in self.headerArr) {
        
        label.font = MJBlodMiddleBobyFont;
        label.textColor = MJBlackColor;
    }
    
    [self.logoutBtn setCornerRadius:20.0];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return Size(30, 35, 40);
    }
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        return Size(60, 70, 80);
    }
    
    return Size(40, 44, 44);
}

//更换头像
- (void)changeIconImg
{
    
    
}

//充值记录
- (void)payHistory
{
    YRPayHistoryVc *historyVc = [[YRPayHistoryVc alloc] init];
    
    [self.navigationController pushViewController:historyVc animated:YES];
    
}

//收货地址
- (void)getGoodsAddress
{
    YRShipAddressVc *addressVc = [[YRShipAddressVc alloc] init];
    
    [self.navigationController pushViewController:addressVc animated:YES];
    
}

//清理缓存
- (void)cleanCache
{
    
    
}


//邀请码
- (void)joyinCode
{
    
    YRInvitationCodeVc *codeVc = [[YRInvitationCodeVc alloc] init];
    
    [self.navigationController pushViewController:codeVc animated:YES];
    
}

//兑换
- (void)exchangeJoy
{
    
    YRExchangeVc *exchangeVc = [[YRExchangeVc alloc] init];
    
    [self.navigationController pushViewController:exchangeVc animated:YES];
    
}

//关于我们
- (void)aboutUs
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"YRAboutUsVc" bundle:nil];
    
    YRAboutUsVc *aboutVc = [sb instantiateInitialViewController];
    
    [self.navigationController pushViewController:aboutVc animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) return;
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                    
                case 1:
                    //头像
                    [self changeIconImg];
                    break;
                    
                case 2:
                    //充值记录
                    [self payHistory];
                    break;
                    
                case 3:
                    //收货地址
                    [self getGoodsAddress];
                    break;
            }
        }
            break;
            
        case 1:
        {
            switch (indexPath.row) {
                case 1:
                    //清理缓存
                    [self cleanCache];
                    break;
            }
        }
            break;
            
        case 2:
        {
            switch (indexPath.row) {
                case 1:
                    //邀请码
                    [self joyinCode];
                    break;
                    
                case 2:
                    //兑换
                    [self exchangeJoy];
                    break;
                    
                case 3:
                    //兑换
                    [self aboutUs];
                    break;
            }
        }
            break;
    }
    
}


- (IBAction)logOutBtnDidClicked:(id)sender
{
    //退出登录
    [UserInfoTool quitUser];
    
    //跳转到登录界面
    MJKeyWindow.rootViewController = [[YRLoginVc alloc] init];
    
}



@end
