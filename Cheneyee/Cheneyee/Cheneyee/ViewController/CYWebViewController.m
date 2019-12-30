//
//  CYWebViewController.m
//  Player
//
//  Created by Cheney Mars on 2019/11/18.
//  Copyright © 2019 Cheney Mars. All rights reserved.
//

#import "CYWebViewController.h"

@interface CYWebViewController () <WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) CYWebViewModel * viewModel;

@property (nonatomic, strong) WKWebView * webView;

@end

@implementation CYWebViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /// request 错误的断言
    NSParameterAssert(self.viewModel.request);
    NSString * userAgent = @"";
    [NSUserDefaults.standardUserDefaults registerDefaults:@{@"userAgent":userAgent}];
    WKWebViewConfiguration * configuration = WKWebViewConfiguration.new;
    // 注册 JS
    WKUserContentController * userContentController = WKUserContentController.new;
    
    // 自适应屏幕宽度
    NSString * jsStr = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    WKUserScript * userScript = [WKUserScript.alloc initWithSource:jsStr injectionTime:(WKUserScriptInjectionTimeAtDocumentEnd) forMainFrameOnly:YES];
    [userContentController addUserScript:userScript];
    configuration.userContentController = userContentController;
    
    self.webView = [WKWebView.alloc initWithFrame:self.view.bounds configuration:configuration];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.customUserAgent = userAgent;
    [self.view addSubview:self.webView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.webView loadRequest:self.viewModel.request];
}

- (void)dealloc {
    [self.webView stopLoading];
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
