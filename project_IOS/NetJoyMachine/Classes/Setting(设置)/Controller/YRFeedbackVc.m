//
//  YRFeedbackVc.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/17.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRFeedbackVc.h"

@interface YRFeedbackVc ()

@property (weak, nonatomic) IBOutlet UIView *textVBackV;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UITextField *textF;

@property (weak, nonatomic) IBOutlet UIView *tfBackV;

@end

@implementation YRFeedbackVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"意见反馈";
    
    self.textView.font = MJBlodMiddleBobyFont;
    
    self.textF.font = MJBlodMiddleBobyFont;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.textVBackV setCornerRadius:12.0];
    
    [self.tfBackV setCornerRadius:12.0];
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
