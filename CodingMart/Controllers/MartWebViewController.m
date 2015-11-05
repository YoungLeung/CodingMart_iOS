//
//  MartWebViewController.m
//  CodingMart
//
//  Created by Ease on 15/10/26.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "MartWebViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "LoginViewController.h"


@interface MartWebViewController ()<UIWebViewDelegate>
@property (strong, nonatomic, readwrite) UIWebView *webView;
@property (strong, nonatomic) NJKWebViewProgress *progressProxy;
@property (strong, nonatomic) NJKWebViewProgressView *progressView;
@property (strong, nonatomic) UIRefreshControl *myRefreshControl;
@end

@implementation MartWebViewController

#pragma mark URLStr

+ (NSURLRequest *)requestFromStr:(NSString *)URLStr{
    if (URLStr.length > 0) {
        NSString *proName = [NSString stringWithFormat:@"/%@.app/", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]];
        NSURL *curUrl;
        if (![URLStr hasPrefix:@"/"] || [URLStr rangeOfString:proName].location != NSNotFound) {
            curUrl = [NSURL URLWithString:URLStr];
        }else{
            curUrl = [NSURL URLWithString:URLStr relativeToURL:[NSURL URLWithString:[NSObject baseURLStr]]];
        }
        if (curUrl) {
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:curUrl];
            return request;
        }
    }
    return nil;
}

- (instancetype)initWithUrlStr:(NSString *)curUrlStr{
    self = [super init];
    if (self) {
        self.curUrlStr = curUrlStr;
    }
    return self;
}

- (void)setCurUrlStr:(NSString *)curUrlStr{
    _curUrlStr = curUrlStr;
    _request = [MartWebViewController requestFromStr:_curUrlStr];
}

#pragma mark lifeCycle

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _titleStr? _titleStr: @"加载中...";
    //UIWebView
    _webView = [UIWebView new];
    _webView.backgroundColor = [UIColor clearColor];
    _webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    //NJKWebViewProgressView
    CGFloat progressBarHeight = 2.f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _progressView.progressBarView.backgroundColor = [UIColor colorWithHexString:@"0x3abd79"];
    
    //NJKWebViewProgress
    _progressProxy = [NJKWebViewProgress new];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    __weak typeof(self) weakSelf = self;
    _progressProxy.progressBlock = ^(float progress) {
        [weakSelf.progressView setProgress:progress animated:YES];
    };
    
    //UIRefreshControl
    _myRefreshControl = [UIRefreshControl new];
    [_myRefreshControl addTarget:self action:@selector(handleRefresh) forControlEvents:UIControlEventValueChanged];
    [_webView.scrollView addSubview:_myRefreshControl];
    
    //Load
    [_webView loadRequest:_request];
}

- (void)handleRefresh{
    if (!_webView.isLoading) {
        [_webView reload];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_progressView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_progressView removeFromSuperview];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [_myRefreshControl endRefreshing];
    self.title = _titleStr.length > 0? _titleStr: [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [_myRefreshControl endRefreshing];
    [self handleError:error];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return ![self canAndGoOutWithLinkStr:request.URL.absoluteString];
}

#pragma mark VC

- (BOOL)canAndGoOutWithLinkStr:(NSString *)linkStr{
    return NO;
    
//    DebugLog(@"%@", linkStr);
//    LoginViewController *loginVC;
//    if ([linkStr rangeOfString:@"/login"].location != NSNotFound){
//        loginVC = [LoginViewController storyboardVCWithType:LoginViewControllerTypeLogin mobile:nil];
//    }else if ([linkStr rangeOfString:@"/register"].location != NSNotFound) {
//        loginVC = [LoginViewController storyboardVCWithType:LoginViewControllerTypeRegister mobile:nil];
//    }else{
//        loginVC = nil;
//    }
//    if (loginVC) {
//        loginVC.loginSucessBlock = ^(){
//            [self.webView reload];
//        };
//        [UIViewController presentVC:loginVC dismissBtnTitle:@"取消"];
//    }
//    return (loginVC != nil);
}

#pragma mark Error
- (void)handleError:(NSError *)error{
    NSString *urlString = error.userInfo[NSURLErrorFailingURLStringErrorKey];
    
    if (([error.domain isEqualToString:@"WebKitErrorDomain"] && 101 == error.code) ||
        ([error.domain isEqualToString:NSURLErrorDomain] && (NSURLErrorBadURL == error.code || NSURLErrorUnsupportedURL == error.code))) {
        kTipAlert(@"网址无效：\n%@", urlString);
    }else if ([error.domain isEqualToString:NSURLErrorDomain] && (NSURLErrorTimedOut == error.code ||
                                                                  NSURLErrorCannotFindHost == error.code ||
                                                                  NSURLErrorCannotConnectToHost == error.code ||
                                                                  NSURLErrorNetworkConnectionLost == error.code ||
                                                                  NSURLErrorDNSLookupFailed == error.code ||
                                                                  NSURLErrorNotConnectedToInternet == error.code)) {
        kTipAlert(@"网络连接异常：\n%@", urlString);
    }else if ([error.domain isEqualToString:@"WebKitErrorDomain"] && 102 == error.code){
        NSURL *url = [NSURL URLWithString:urlString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }else{
            kTipAlert(@"无法打开链接：\n%@", urlString);
        }
    }else if (error.code == -999){
        //加载中断
    }else{
        kTipAlert(@"%@\n%@", urlString, [error.userInfo objectForKey:@"NSLocalizedDescription"]? [error.userInfo objectForKey:@"NSLocalizedDescription"]: error.description);
    }
}


@end
