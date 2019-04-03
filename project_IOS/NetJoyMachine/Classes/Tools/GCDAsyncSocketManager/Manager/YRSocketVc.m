//
//  YRSocketVc.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/29.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRSocketVc.h"
#import "GCDAsyncSocketCommunicationManager.h"

@interface YRSocketVc ()

@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UITextField *portTF;
@property (weak, nonatomic) IBOutlet UITextField *messageTF;
@property (weak, nonatomic) IBOutlet UITextView *showMessageTF;


@end

@implementation YRSocketVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


#define kDefaultChannel @"dkf"
#pragma mark-- 连接按钮
- (IBAction)conectBtnClick:(id)sender
{
    // 1. 使用默认的连接环境
    [[GCDAsyncSocketCommunicationManager sharedInstance] createSocketWithToken:@"f14c4e6f6c89335ca5909031d1a6efa9" channel:kDefaultChannel];
    
    
}

#pragma mark-- 发送按钮
- (IBAction)postBtnClick:(id)sender
{
    NSDictionary *requestBody = @{
                                  @"name":@"xiaoming",
                                  @"age":@"18"
                                  };
    
    [[GCDAsyncSocketCommunicationManager sharedInstance] socketWriteDataWithRequestType:GACRequestType_Login requestBody:requestBody completion:^(NSError * _Nullable error, id  _Nullable data) {
        // do something
        if (error) {
            
        } else {
            
        }
    }];
}

#pragma mark-- 接收信息
- (IBAction)getBtnClicked:(id)sender
{
}


@end
