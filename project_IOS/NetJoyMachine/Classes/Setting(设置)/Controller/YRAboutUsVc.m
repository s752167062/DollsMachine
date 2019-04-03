//
//  YRAboutUsVc.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/17.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRAboutUsVc.h"
#import "YRHelpVc.h"
#import "YRFeedbackVc.h"

@interface YRAboutUsVc ()

@property(nonatomic ,strong)IBOutletCollection(UILabel) NSArray *rightTArr;

//版本号
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;


@end

@implementation YRAboutUsVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDefault];
    
    [self setupUI];
    
}

//MARK:- 设置默认信息
- (void)setupDefault
{
    self.title = @"关于我们";
}

//MARK:- 设置UI
- (void)setupUI
{
    for (UILabel *label in self.rightTArr) {
        
        label.font = MJBlodMiddleBobyFont;
        label.textColor = MJBlackColor;
    }
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
}


#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Size(40, 44, 44);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2) return Size(40, 44, 44);
    
    return 25;
    
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 1:
            {
                if (indexPath.row == 0) {
                    [self resloveHelp];
                }else if (indexPath.row == 1){
                    [self feedback];
                }
                
            }
            break;
            
        default:
            break;
    }
    
}

//帮助
- (void)resloveHelp
{
    YRHelpVc *helpVc = [[YRHelpVc alloc] init];
    
    helpVc.pageName = @"帮助";
    
    helpVc.jumpUrlStr = @"https://www.baidu.com";
    
    [self.navigationController pushViewController:helpVc animated:YES];
}

//意见反馈
- (void)feedback
{
    YRFeedbackVc *feedVc = [[YRFeedbackVc alloc] init];
    
    [self.navigationController pushViewController:feedVc animated:YES];
}



@end
