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
//    由扁平数据整理出树状关系
    NSArray *platformItems = [_dataDict[@"items"] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"parentCode.length = 0"]];//根节点，对应平台
    NSMutableArray *platformList = @[].mutableCopy;
    for (NSDictionary *platform in platformItems) {
        NSMutableDictionary *platformDict = @{@"platform": platform[@"title"]}.mutableCopy;
        NSArray *categoryItems = [_dataDict[@"items"] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"parentCode = %@", platform[@"code"]]];//某平台下的分类
        NSMutableArray *categoryList = @[].mutableCopy;
        for (NSDictionary *category in categoryItems) {
            NSMutableDictionary *categoryDict = @{@"name": category[@"title"]}.mutableCopy;
            NSArray *moduleItems = [_dataDict[@"items"] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"parentCode = %@", category[@"code"]]];//某分类下的模块
            NSMutableArray *moduleList = @[].mutableCopy;
            for (NSDictionary *module in moduleItems) {
                NSMutableDictionary *moduleDict = @{@"name": module[@"title"]}.mutableCopy;
                NSArray *functionItems = [_dataDict[@"items"] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"parentCode = %@", module[@"code"]]];//某模块下的功能点
                NSMutableArray *functionList = [functionItems valueForKey:@"title"];
                moduleDict[@"function"] = functionList;
                [moduleList addObject:moduleDict];
            }
            categoryDict[@"module"] = moduleList;
            [categoryList addObject:categoryDict];
        }
        platformDict[@"category"] = categoryList;
        [platformList addObject:platformDict];
    }
//    将数据转成对应的 json 字符串
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:platformList options:NSJSONWritingPrettyPrinted error:nil];
    NSString *h5String = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    填充 web 视图
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
