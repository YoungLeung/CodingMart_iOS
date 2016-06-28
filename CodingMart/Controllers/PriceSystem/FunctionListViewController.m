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
#import "FunctionMenu.h"

@interface FunctionListViewController ()

@property (strong, nonatomic) NSString *shareLink;
@property (strong, nonatomic) NSDictionary *dataDict;
@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) NSURL *shareURL;

@end

@implementation FunctionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"功能清单";
    if (_listID) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"price_share"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClicked)];
    }

    _dataDict = [NSDictionary dictionary];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    
    // 顶部
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 118)];
    [_topView setBackgroundColor:[UIColor whiteColor]];
    [scrollView addSubview:_topView];
    
    // 预估报价
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, kScreen_Width - 30, 20)];
    [titleLabel setText:@"码市预估报价："];
    [titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [_topView addSubview:titleLabel];
    
    // 报价
    NSString *priceString = [NSString stringWithFormat:@"¥ %@ - %@  元", _list.fromPrice, _list.toPrice];
    NSMutableAttributedString *priceAttributedString = [[NSMutableAttributedString alloc] initWithString:priceString attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"F5A623"],NSFontAttributeName:[UIFont systemFontOfSize:24.0f]}];
    [priceAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(priceString.length - 1, 1)];
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, titleLabel.bottom + 12, titleLabel.width, 32)];
    [priceLabel setFont:[UIFont systemFontOfSize:24.0f]];
    [priceLabel setAttributedText:priceAttributedString];
    [_topView addSubview:priceLabel];
    
    // 开发周期
    NSString *fromTermString = [NSString stringWithFormat:@"%@", _list.fromTerm];
    NSString *toTermString = [NSString stringWithFormat:@"%@", _list.toTerm];
    NSString *timeString = [NSString stringWithFormat:@"预计开发周期：%@ - %@ 个工作日", _list.fromTerm, _list.toTerm];
    NSMutableAttributedString *timeAttributedString = [[NSMutableAttributedString alloc] initWithString:timeString attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"999999"]}];
    [timeAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"4289DB"] range:NSMakeRange([timeString rangeOfString:fromTermString].location, fromTermString.length + toTermString.length + 3)];
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, priceLabel.bottom + 5, kScreen_Width - 30, 20)];
    [timeLabel setAttributedText:timeAttributedString];
    [_topView addSubview:timeLabel];
    
    NSError *error = nil;
    NSString *string = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PriceH5File" ofType:@"html"] encoding:NSUTF8StringEncoding error:&error];
    if (_h5String) {
        string = [string stringByReplacingOccurrencesOfString:@"${webview_content}" withString:_h5String];
        UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 118+ 64, kScreen_Width, kScreen_Height - _topView.bottom - 64)];
        [web loadHTMLString:string baseURL:nil];
        [self.view addSubview:web];
    }
    
    if (_listID) {
        __weak typeof(self) weakSelf = self;
        [[Coding_NetAPIManager sharedManager] post_shareLink:@{@"listID":_listID} block:^(id data, NSError *error) {
            if (!error) {
                weakSelf.shareLink = [data objectForKey:@"shareLink"];
            }
        }];
        
        // 请求h5数据
        [[Coding_NetAPIManager sharedManager] get_priceH5Data:@{@"listID":_listID} block:^(id data, NSError *error) {
            if (!error) {
                weakSelf.dataDict = data;
                [weakSelf generateAndLoadH5Data];
            }
        }];
    }
}

- (void)rightBarButtonItemClicked {
    _shareURL = [NSURL URLWithString:_shareLink];
    [MartShareView showShareViewWithObj:_shareURL];
}

- (void)generateAndLoadH5Data {
    NSArray *itemsArray = [NSObject arrayFromJSON:_dataDict[@"items"] ofObjects:@"FunctionMenu"];
    NSMutableArray *menuArray = [NSMutableArray array];
    for (FunctionMenu *m in itemsArray) {
        if ([m.type isEqual:@1]) {
            [menuArray addObject:m];
        }
    }
    
    // 生成HTML数据
    NSMutableString *h5String = [NSMutableString stringWithFormat:@"["];
    for (int i = 0; i < menuArray.count; i++) {
        // 平台
        FunctionMenu *menu = [menuArray objectAtIndex:i];
        NSString *platform = menu.title;
        [h5String appendFormat:@"{\"platform\":\"%@\", \"category\":[{", platform];
        
        // 循环分类、模块、具体商品
        // 分类数据
        NSMutableArray *categoryArray = [NSMutableArray array];
        for (FunctionMenu *m in itemsArray) {
            if ([m.parentCode isEqual:menu.code]) {
                [categoryArray addObject:m];
            }
        }
        for (int j = 0; j < categoryArray.count; j++) {
            //  分类
            FunctionMenu *categoryMenu = [categoryArray objectAtIndex:j];
            NSString *name = categoryMenu.title;
            [h5String appendFormat:@"\"name\":\"%@\", \"module\":[{\"function\":[", name];
            // 模块数据
            NSMutableArray *modelArray = [NSMutableArray array];
            for (FunctionMenu *m in itemsArray) {
                if ([m.parentCode isEqual:categoryMenu.code]) {
                    [modelArray addObject:m];
                }
            }
            // 具体商品数据
            for (int k = 0; k < modelArray.count; k++) {
                FunctionMenu *modelMenu = [modelArray objectAtIndex:i];
                for (FunctionMenu *m in itemsArray) {
                    if ([m.parentCode isEqual:modelMenu.code]) {
                        [h5String appendFormat:@"\"%@\",", m.title];
                    }
                }
                [h5String appendFormat:@"], \"name\":\"%@\"}]", modelMenu.title];
            }
            
            if (j+1 == categoryArray.count) {
                [h5String appendString:@"}],"];
            }
        }
        [h5String appendString:@"},"];
    }
    [h5String appendString:@"]"];
    
    NSError *error = nil;
    NSString *string = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PriceH5File" ofType:@"html"] encoding:NSUTF8StringEncoding error:&error];
    string = [string stringByReplacingOccurrencesOfString:@"${webview_content}" withString:h5String];
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 118+ 64, kScreen_Width, kScreen_Height - _topView.bottom - 64)];
    [web loadHTMLString:string baseURL:nil];
    [self.view addSubview:web];
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
