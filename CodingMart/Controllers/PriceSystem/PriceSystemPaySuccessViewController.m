//
//  PriceSystemPaySuccessViewController.m
//  CodingMart
//
//  Created by Frank on 16/5/26.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "PriceSystemPaySuccessViewController.h"

@interface PriceSystemPaySuccessViewController ()

@end

@implementation PriceSystemPaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"发布成功"];
    
    // 支付成功
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(15, 15 + 64, kScreen_Width - 30, 164)];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    [contentView setCornerRadius:2.0f];
    
    // 图标
    UIImage *paySuccessImage = [UIImage imageNamed:@"price_pay_success"];
    UIImageView *paySuccess = [[UIImageView alloc] initWithFrame:CGRectMake(15, 23, paySuccessImage.size.width, paySuccessImage.size.height)];
    [paySuccess setImage:paySuccessImage];
    
    // 支付成功label
    float labelWidth = kScreen_Width - 30 - CGRectGetMaxX(paySuccess.frame) - 22 - 25;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(paySuccess.frame) + 22, 23, labelWidth, 48)];
    [label setNumberOfLines:2];
    [label setText:@"支付成功！\n感谢您使用码市自助评估系统！"];

    // 分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(paySuccess.frame) + 23, kScreen_Width - 60, 1)];
    [lineView setBackgroundColor:[UIColor colorWithHexString:@"DDDDDD"]];
    
    // 付款金额
    NSDictionary *payMoneyDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [UIFont systemFontOfSize:14.0f], NSFontAttributeName,
                                  [UIColor colorWithHexString:@"999999"], NSForegroundColorAttributeName, nil];
    NSDictionary *payMoneyDict2 = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIFont systemFontOfSize:14.0f], NSFontAttributeName,
                                   [UIColor colorWithHexString:@"F5A624"], NSForegroundColorAttributeName, nil];
    NSString *moneyString = @"付款金额：¥1";
    NSMutableAttributedString *payMoneyString = [[NSMutableAttributedString alloc] initWithString:moneyString attributes:payMoneyDict];
    UILabel *payMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(lineView.frame) + 15, kScreen_Width - 60, 17)];
    [payMoneyString setAttributes:payMoneyDict2 range:[moneyString rangeOfString:@"¥1"]];
    [payMoneyLabel setAttributedText:payMoneyString];
    
    // 付款方式
    NSDictionary *payMethodDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIFont systemFontOfSize:14.0f], NSFontAttributeName,
                                   [UIColor colorWithHexString:@"999999"], NSForegroundColorAttributeName, nil];
    NSDictionary *payMethodDict2 = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIFont systemFontOfSize:14.0f], NSFontAttributeName,
                                   [UIColor colorWithHexString:@"828282"], NSForegroundColorAttributeName, nil];
    NSString *methodString = @"付款方式：";
    NSString *methodWholeString = [NSString stringWithFormat:@"付款方式：%@", _type == 0 ? @"支付宝" : @"微信"];
    NSMutableAttributedString *payMethodString = [[NSMutableAttributedString alloc] initWithString:methodWholeString attributes:payMethodDict];
    [payMethodString setAttributes:payMethodDict2 range:NSMakeRange(methodString.length, methodWholeString.length - methodString.length)];
    UILabel *payMethodLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(payMoneyLabel.frame) + 8, kScreen_Width - 60, 17)];
    [payMethodLabel setAttributedText:payMethodString];
    
    [contentView addSubview:paySuccess];
    [contentView addSubview:label];
    [contentView addSubview:lineView];
    [contentView addSubview:payMoneyLabel];
    [contentView addSubview:payMethodLabel];
    [self.view addSubview:contentView];
    
    // 进入系统按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(15, CGRectGetMaxY(contentView.frame) + 25, kScreen_Width - 30, 44)];
    [button setTitle:@"进入码市自助评估系统" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [button setBackgroundColor:[UIColor colorWithHexString:@"4289DB"]];
    [button.layer setCornerRadius:2.0f];
    [button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
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
