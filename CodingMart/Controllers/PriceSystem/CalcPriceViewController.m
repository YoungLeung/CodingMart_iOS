//
//  CalcPriceViewController.m
//  CodingMart
//
//  Created by Frank on 16/6/9.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "CalcPriceViewController.h"
#import "Coding_NetAPIManager.h"
#import "CalcResult.h"

@interface CalcPriceViewController ()

@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIButton *recalcButton, *saveButton;
@property (strong, nonatomic) UILabel *priceLabel, *platformLabel, *timeLabel;

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
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, descriptionLabel.bottom + 15, tipLabel.width, 32)];
    [_priceLabel setFont:[UIFont systemFontOfSize:24.0f]];
    [_priceLabel setTextColor:[UIColor colorWithHexString:@"F5A623"]];
    [_backgroundView addSubview:_priceLabel];
    
    // 分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, _priceLabel.bottom + 15, tipLabel.width, 1)];
    [lineView setBackgroundColor:[UIColor colorWithHexString:@"DDDDDD"]];
    [_backgroundView addSubview:lineView];
    
    // 平台模块数据
    _platformLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, lineView.bottom + 15, tipLabel.width, 18)];
    [_platformLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [_backgroundView addSubview:_platformLabel];
    
    // 预估时间
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _platformLabel.bottom + 15, tipLabel.width, 18)];
    [_timeLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [_backgroundView addSubview:_timeLabel];
    
    _recalcButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_recalcButton setFrame:CGRectMake(15, CGRectGetMaxY(_backgroundView.frame) + 15, kScreen_Width * 0.43, 44)];
    [_recalcButton setTitle:@"调整需求重新记算" forState:UIControlStateNormal];
    [_recalcButton setTitleColor:[UIColor colorWithHexString:@"4289DB"] forState:UIControlStateNormal];
    [_recalcButton setBackgroundColor:[UIColor whiteColor]];
    [_recalcButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [_recalcButton.layer setBorderColor:[UIColor colorWithHexString:@"DDDDDD"].CGColor];
    [_recalcButton.layer setBorderWidth:0.5f];
    [_recalcButton setCornerRadius:3.0f];
    [_recalcButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_recalcButton];
    
    _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_saveButton setFrame:CGRectMake(_recalcButton.right + 15, CGRectGetMaxY(_backgroundView.frame) + 15, kScreen_Width * 0.43, 44)];
    [_saveButton setTitle:@"保存报价" forState:UIControlStateNormal];
    [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_saveButton setBackgroundColor:[UIColor colorWithHexString:@"4289DB"]];
    [_saveButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [_saveButton setCornerRadius:3.0f];
    [_saveButton addTarget:self action:@selector(savePrice) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_saveButton];
    
    __weak typeof(self)weakSelf = self;
    [[Coding_NetAPIManager sharedManager] post_calcPrice:@{@"codes":_parameter, @"webPageCount":_webPageNumber} block:^(id data, NSError *error) {
        if (!error) {
            CalcResult *result = data;
            [weakSelf updateView:result];
        }
    }];
}

- (void)updateView:(CalcResult *)result {
    [_priceLabel setText:[NSString stringWithFormat:@"¥ %@ - %@  元", result.fromPrice, result.toPrice]];
    NSMutableDictionary *fontDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     NSFontAttributeName, [UIFont systemFontOfSize:14.0f],
                                     NSForegroundColorAttributeName, [UIColor colorWithHexString:@"999999"],
                                     nil];
    
    NSString *moduleCountString = [NSString stringWithFormat:@"%@", result.moduleCount];
    NSString *fromTermString = [NSString stringWithFormat:@"%@", result.fromTerm];
    NSString *toTermString = [NSString stringWithFormat:@"%@", result.toTerm];
    
    NSString *platformString = [NSString stringWithFormat:@"共有 %@ 个平台，%@ 个功能模块", result.platformCount, result.moduleCount];
    NSString *timeString = [NSString stringWithFormat:@"预计开发周期：%@ - %@ 个工作日", result.fromTerm, result.toTerm];
    NSMutableAttributedString *platformAttributedString = [[NSMutableAttributedString alloc] initWithString:platformString attributes:fontDict];
    NSMutableAttributedString *timeAttributedString = [[NSMutableAttributedString alloc] initWithString:timeString attributes:fontDict];
    
    [platformAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"4289DB"] range:NSMakeRange([platformString rangeOfString:@"，"].location + 1, moduleCountString.length)];
    [timeAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"4289DB"] range:NSMakeRange([timeString rangeOfString:fromTermString].location, fromTermString.length + toTermString.length + 3)];
    
    [_platformLabel setAttributedText:platformAttributedString];
    [_timeLabel setAttributedText:timeAttributedString];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)savePrice {
    
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
