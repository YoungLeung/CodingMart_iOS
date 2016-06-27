//
//  FunctionListViewController.m
//  CodingMart
//
//  Created by Frank on 16/6/11.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "FunctionListViewController.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import "MartShareView.h"
#import "Coding_NetAPIManager.h"

@interface FunctionListViewController ()

@property (strong, nonatomic) NSString *shareLink;
@property (strong, nonatomic) UIWebView *webView;

@end

@implementation FunctionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"功能清单";
    if (_listID) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"price_share"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClicked)];
    }


    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    
    // 顶部
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 118)];
    [topView setBackgroundColor:[UIColor whiteColor]];
    [scrollView addSubview:topView];
    
    // 预估报价
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, kScreen_Width - 30, 20)];
    [titleLabel setText:@"码市预估报价："];
    [titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [topView addSubview:titleLabel];
    
    // 报价
    NSString *priceString = [NSString stringWithFormat:@"¥ %@ - %@  元", _list.fromPrice, _list.toPrice];
    NSMutableAttributedString *priceAttributedString = [[NSMutableAttributedString alloc] initWithString:priceString attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"F5A623"],NSFontAttributeName:[UIFont systemFontOfSize:24.0f]}];
    [priceAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(priceString.length - 1, 1)];
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, titleLabel.bottom + 12, titleLabel.width, 32)];
    [priceLabel setFont:[UIFont systemFontOfSize:24.0f]];
    [priceLabel setAttributedText:priceAttributedString];
    [topView addSubview:priceLabel];
    
    // 开发周期
    NSString *fromTermString = [NSString stringWithFormat:@"%@", _list.fromTerm];
    NSString *toTermString = [NSString stringWithFormat:@"%@", _list.toTerm];
    NSString *timeString = [NSString stringWithFormat:@"预计开发周期：%@ - %@ 个工作日", _list.fromTerm, _list.toTerm];
    NSMutableAttributedString *timeAttributedString = [[NSMutableAttributedString alloc] initWithString:timeString attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"999999"]}];
    [timeAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"4289DB"] range:NSMakeRange([timeString rangeOfString:fromTermString].location, fromTermString.length + toTermString.length + 3)];
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, priceLabel.bottom + 5, kScreen_Width - 30, 20)];
    [timeLabel setAttributedText:timeAttributedString];
    [topView addSubview:timeLabel];
    
    NSError *error = nil;
    NSString *string = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PriceH5File" ofType:@"html"] encoding:NSUTF8StringEncoding error:&error];
    string = [string stringByReplacingOccurrencesOfString:@"${webview_content}" withString:_h5String];
    
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 118+ 64, kScreen_Width, kScreen_Height - topView.bottom - 64)];
    [web loadHTMLString:string baseURL:nil];
    [self.view addSubview:web];
    
    if (_listID) {
        __weak typeof(self) weakSelf = self;
        [[Coding_NetAPIManager sharedManager] post_shareLink:@{@"listID":_listID} block:^(id data, NSError *error) {
            if (!error) {
                weakSelf.shareLink = [data objectForKey:@"shareLink"];
            }
        }];
    }
}

- (void)rightBarButtonItemClicked {
    _webView = [[UIWebView alloc] init];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_shareLink]];
    [_webView loadRequest:request];
    [MartShareView showShareViewWithObj:_webView];
    [_webView stopLoading];
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
