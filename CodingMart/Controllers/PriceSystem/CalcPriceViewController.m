//
//  CalcPriceViewController.m
//  CodingMart
//
//  Created by Frank on 16/6/9.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "CalcPriceViewController.h"

@interface CalcPriceViewController ()

@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIButton *saveButton;

@end

@implementation CalcPriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"计算结果";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"price_selected_menu_list" showBadge:NO target:self action:@selector(toFunctionList)];
    
    _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 64 + 15, kScreen_Width, 222)];
    [_backgroundView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_backgroundView];
    
    // tip
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, _backgroundView.width - 30, 27)];
    [tipLabel setText:@"码市提供报价参考，实际价格会有专业人员与您商定"];
    [tipLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [tipLabel setTextColor:[UIColor colorWithHexString:@"F5A623"]];
    [tipLabel setBackgroundColor:[UIColor colorWithHexString:@"FFF6DD"]];
    [tipLabel setTextAlignment:NSTextAlignmentCenter];
    [tipLabel setCornerRadius:1.5f];
    [_backgroundView addSubview:tipLabel];
    
    // 报价描述
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, tipLabel.bottom + 15, tipLabel.width, 20)];
    [descriptionLabel setText:@"码市预估报价："];
    [descriptionLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [_backgroundView addSubview:descriptionLabel];
    
    // 报价
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, descriptionLabel.bottom + 15, tipLabel.width, 32)];
    [priceLabel setText:@"¥ 4,800 - 6,600  元"];
    [priceLabel setFont:[UIFont systemFontOfSize:24.0f]];
    [priceLabel setTextColor:[UIColor colorWithHexString:@"F5A623"]];
    [_backgroundView addSubview:priceLabel];
    
    // 分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, priceLabel.bottom + 15, tipLabel.width, 1)];
    [lineView setBackgroundColor:[UIColor colorWithHexString:@"DDDDDD"]];
    [_backgroundView addSubview:lineView];
    
    // 平台模块数据
    UILabel *platformLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, lineView.bottom + 15, tipLabel.width, 18)];
    [platformLabel setText:@"共有 1 个平台，6 个功能模块"];
    [platformLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [_backgroundView addSubview:platformLabel];
    
    // 预估时间
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, platformLabel.bottom + 15, tipLabel.width, 18)];
    [timeLabel setText:@"预计开发周期：4 - 5 个工作日"];
    [timeLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [_backgroundView addSubview:timeLabel];
    
    _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_saveButton setFrame:CGRectMake(15, CGRectGetMaxY(_backgroundView.frame) + 15, kScreen_Width * 0.43, 44)];
    [_saveButton setTitle:@"保存报价" forState:UIControlStateNormal];
    [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_saveButton setBackgroundColor:[UIColor colorWithHexString:@"4289DB"]];
    [_saveButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [_saveButton setCornerRadius:3.0f];
    [self.view addSubview:_saveButton];
}

- (void)toFunctionList {
    
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
