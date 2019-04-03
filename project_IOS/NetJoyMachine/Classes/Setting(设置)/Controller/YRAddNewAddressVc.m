//
//  YRAddNewAddressVc.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/19.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRAddNewAddressVc.h"
#import <SVProgressHUD.h>
#import <BRAddressPickerView.h>
#import "YRLocationModel.h"
#import "StringJudgeManager.h"
#import "UserInfoTool.h"
#import "GCDAsyncSocketCommunicationManager.h"

@interface YRAddNewAddressVc ()

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property(nonatomic ,strong)IBOutletCollection(UILabel) NSArray *rightTitleArr;

@property(nonatomic ,strong)IBOutletCollection(UITextField) NSArray *leftTextFArr;

//地区
@property (weak, nonatomic) IBOutlet UITextField *addressTextF;

//收货人
@property (weak, nonatomic) IBOutlet UITextField *getGoodsPersonTextF;

//联系电话
@property (weak, nonatomic) IBOutlet UITextField *phoneTextF;

//详细地址
@property (weak, nonatomic) IBOutlet UITextView *specificTextView;


@end

@implementation YRAddNewAddressVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDefault];
    
    [self setupUI];
    
}

//MARK:- 设置默认信息
- (void)setupDefault
{
    self.title = @"新增地址";
}

//MARK:- 设置UI
- (void)setupUI
{
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"F0F0F0"];
    
    for (UILabel *label in self.rightTitleArr) {
        
        label.font = MJBlodMiddleBobyFont;
        label.textColor = MJBlackColor;
    }
    
    for (UILabel *label in self.leftTextFArr) {
        
        label.font = MJBlodMiddleBobyFont;
        label.textColor = MJGrayColor;
    }
    
    self.saveBtn.titleLabel.font = MJMiddleBobyFont;
    
    if (self.locationItem) {
        
        self.getGoodsPersonTextF.text = _locationItem.userName;
        
        self.phoneTextF.text = _locationItem.phone;
        
        self.addressTextF.text = [NSString stringWithFormat:@"%@%@%@",_locationItem.locale1,_locationItem.locale2,_locationItem.locale3];
        
        self.specificTextView.text = _locationItem.address;
        
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.saveBtn setCornerRadius:self.saveBtn.MJ_height * 0.5];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return Size(20, 25, 30);
            break;
        case 4:
            return Size(80, 88, 88);
            break;
        default:
            return Size(40, 44, 44);
            break;
    }
}


- (IBAction)saveBtnDidClicked:(id)sender
{
    
    if (![StringJudgeManager judgePhoneNum:self.phoneTextF.text]) {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的电话号码,亲"];
        return;
    }
    
    if ([StringJudgeManager removeBlack:self.getGoodsPersonTextF.text].length <= 0 || [StringJudgeManager removeBlack:self.phoneTextF.text].length <= 0 || [StringJudgeManager removeBlack:self.addressTextF.text].length <= 0 || [StringJudgeManager removeBlack:self.specificTextView.text].length <= 0) {
        
        [SVProgressHUD showInfoWithStatus:@"请填完整信息哟,亲"];
        return;
    }
    
    if (self.locationItem) {
        //改
        [self PostRequestWith:@"4"];
    }else{
        //增
        [self PostRequestWith:@"1"];
    }
}

- (void)PostRequestWith:(NSString *)requestStyle
{
    NSString *userId = [UserInfoTool getUserDefaultKey:UserDefault_UserID];
    
    [SVProgressHUD showWithStatus:YR_Hint_Refreshing];
    
//    NSDictionary *paraDict = @{@"userid":userId,
//                               @"type":requestStyle,
//                               @"id":self.locationItem.ID ? : @"",
//                               @"name":self.locationItem.userName ? : @"",
//                               @"locale1":self.locationItem.locale1 ? : @"",
//                               @"Locale2":self.locationItem.locale2 ? : @"",
//                               @"Locale3":self.locationItem.locale3 ? : @"",
//                               @"address":self.locationItem.address ? : @"",
//                               @"phone":self.locationItem.phone ? : @"",
//
//                               };
    
    [[GCDAsyncSocketCommunicationManager sharedInstance] socketWriteDataWithRequestType:GACRequestType_GetReceivingAdv requestBody:@{@"userid":userId,@"type":requestStyle} completion:^(NSError * _Nullable error, id  _Nullable data) {
        
        NSLog(@"错误: %@,数据:%@",error,data);
        [SVProgressHUD dismiss];
        
        if (error || !data) {
            [SVProgressHUD showErrorWithStatus:@"网络繁忙"];
            return;
        }
        
        

       
    }];
}


#pragma mark-- 地址选择器
- (IBAction)chooseAdsBtn:(id)sender
{
    [self.view endEditing:YES];
    
    ZMJWeakSelf(self)
    [BRAddressPickerView showAddressPickerWithDefaultSelected:@[@0, @0, @0] isAutoSelect:YES resultBlock:^(NSArray *selectAddressArr) {
        weakself.addressTextF.text = [NSString stringWithFormat:@"%@%@%@", selectAddressArr[0], selectAddressArr[1], selectAddressArr[2]];
        
    }];
    
}

@end
