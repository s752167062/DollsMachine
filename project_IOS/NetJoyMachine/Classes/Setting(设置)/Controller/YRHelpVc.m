//
//  YRHelpVc.m
//  NetJoyMachine
//
//  Created by ZMJ on 2017/11/17.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRHelpVc.h"
#import <WebKit/WebKit.h>
#import <SVProgressHUD.h>

@interface YRHelpVc ()<WKNavigationDelegate>

@property(nonatomic , weak)  WKWebView *webView;

@end

@implementation YRHelpVc

- (WKWebView *)webView
{
    if (!_webView) {
        
        WKWebView *web = [[WKWebView alloc] initWithFrame:self.view.bounds];
        
        web.navigationDelegate = self;
        
        [self.view addSubview:web];
        
        _webView = web;
        
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.pageName ? : @"娃娃";
    
    if (self.jumpUrlStr && [NSURL URLWithString:self.jumpUrlStr]) {
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.jumpUrlStr]]];
    }
    
    
    [SVProgressHUD show];
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    [SVProgressHUD dismiss];
    
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
