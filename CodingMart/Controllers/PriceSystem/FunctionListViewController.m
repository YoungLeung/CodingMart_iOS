//
//  FunctionListViewController.m
//  CodingMart
//
//  Created by Frank on 16/6/11.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "FunctionListViewController.h"

@interface FunctionListViewController ()

@end

@implementation FunctionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"功能清单";
    
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
    
    // 功能清单
    UILabel *functionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, topView.bottom, kScreen_Width - 30, 42)];
    [functionLabel setText:@"功能清单"];
    [functionLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [functionLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
    [scrollView addSubview:functionLabel];
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
