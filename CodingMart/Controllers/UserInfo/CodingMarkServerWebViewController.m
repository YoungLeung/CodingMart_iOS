//
//  CodingMarkServerWebViewController.m
//  CodingMart
//
//  Created by HuiYang on 15/11/10.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "CodingMarkServerWebViewController.h"
#import "ZZBWebView.h"

#define kServerUrl @"https://dn-coding-net-production-static.qbox.me/Developer_Service_Guide_v1.pdf"

@interface CodingMarkServerWebViewController ()

@end

@implementation CodingMarkServerWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"Coding码市开发者服务指南";
    [self buildUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)buildUI
{
    
    ZZBWebView *notesWebView =[[ZZBWebView alloc]init];
    [self.view addSubview:notesWebView];
    [notesWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:kServerUrl]]];
    
    [notesWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
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
