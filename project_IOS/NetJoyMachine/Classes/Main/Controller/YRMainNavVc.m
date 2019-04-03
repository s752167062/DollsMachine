//
//  YRMainNavVc.m
//  JoyMachine
//
//  Created by ZMJ on 2017/11/12.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRMainNavVc.h"


@interface YRMainNavVc ()

@end

@implementation YRMainNavVc

#pragma mark ----------------------
#pragma mark 全局设置导航条的背景图片和文字
+ (void)load
{
    //获取总个navigationBar
    UINavigationBar *navigaitonBar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    
    
    NSMutableDictionary *navDict = [NSMutableDictionary dictionary];
    
    //    navArray[NSFontAttributeName] = [UIFont systemFontOfSize:17.0];
    
    [navDict setObject:[UIFont fontWithName:@"Helvetica-Bold" size:18.0] forKey:NSFontAttributeName];
    
    [navDict setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    [navigaitonBar setTitleTextAttributes:navDict];
    
    // 设置导航条背景图片:一定要是UIBarMetricsDefault
    // iOS9之前:UIBarMetricsDefault,导航控制器跟控制器的view尺寸会减少64
    // iOS9没有了.
    // iOS8和iOS9适配:
    [navigaitonBar setBackgroundImage:[UIImage imageWithColor:MJMainRedColor size:CGSizeMake(1, 1)] forBarMetrics:UIBarMetricsDefault];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //边缘滑动返回手势
self.interactivePopGestureRecognizer.delegate = self;
    
//    id target = self.interactivePopGestureRecognizer.delegate;
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:target action:@selector(handleNavigationTransition:)];
//
//    [self.view addGestureRecognizer:pan];
//
//    pan.delegate = self;
//
//    self.interactivePopGestureRecognizer.enabled = NO;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //    [SVProgressHUD dismiss];
    
    //判断是不是跟控制器,只有非控制器器才行进跳转和隐藏BottomBar
    
    if(self.childViewControllers.count > 0){
        
        viewController.hidesBottomBarWhenPushed = YES;
        
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithImage:[UIImage imageNamed:@"nav_back_button"] highImage:[UIImage imageNamed:@"nav_back_button"] target:self action:@selector(back) title:@""];
        
        
    }
    
    [super pushViewController:viewController animated:YES];
    
}

- (void)back
{
    //    [SVProgressHUD dismiss];
    
    [self popViewControllerAnimated:YES];
    
}

#pragma mark ----------------------
#pragma mark 是否需要触发手势的代理方法中排除代理方法

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    
    return self.childViewControllers.count > 1;
 
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ((self.viewControllers.count - 1) == 0) {
        return NO;
    }
    
    UIViewController *vc = [self.childViewControllers lastObject];
    //去除某个界面的滑动返回
    if ([vc isKindOfClass:NSClassFromString(@"YRJoyGameVc")]||[vc isKindOfClass:NSClassFromString(@"YRJoyGameVc")]) {
        return NO;
    }
    
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
