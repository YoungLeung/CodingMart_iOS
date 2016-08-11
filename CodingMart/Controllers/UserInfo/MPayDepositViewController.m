//
//  MPayDepositViewController.m
//  CodingMart
//
//  Created by Ease on 16/8/5.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "MPayDepositViewController.h"
#import "Login.h"
#import <UMengSocial/WXApi.h>
#import <UMengSocial/WXApiObject.h>
#import <AlipaySDK/AlipaySDK.h>
#import "UIButton+Query.h"
#import "Coding_NetAPIManager.h"
#import "Reward.h"

@interface MPayDepositViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *alipayCheckV;
@property (weak, nonatomic) IBOutlet UIImageView *wechatCheckV;
@property (weak, nonatomic) IBOutlet UIImageView *bankCheckV;
@property (weak, nonatomic) IBOutlet UITextField *priceF;
@property (assign, nonatomic) NSInteger platformIndex;

@property (weak, nonatomic) IBOutlet UILabel *tipL;
@property (weak, nonatomic) IBOutlet UILabel *remarkL;
@property (weak, nonatomic) IBOutlet UILabel *contactL;

@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;

@property (strong, nonatomic) NSDictionary *payDict;

//@property (strong, nonatomic) NSString *platform;//Weixin、
@end

@implementation MPayDepositViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.platformIndex = 0;
    _remarkL.text = [NSString stringWithFormat:@"码市开发宝账户充值，充值账户：%@", [Login curLoginUser].global_key];
}

- (void)setPlatformIndex:(NSInteger)platformIndex{
    _platformIndex = platformIndex;
    _alipayCheckV.image = [UIImage imageNamed:_platformIndex == 0? @"pay_checked": @"pay_unchecked"];
    _wechatCheckV.image = [UIImage imageNamed:_platformIndex == 1? @"pay_checked": @"pay_unchecked"];
    _bankCheckV.image = [UIImage imageNamed:_platformIndex == 2? @"pay_checked": @"pay_unchecked"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.bottomBtn.hidden = self.platformIndex == 2;
        [self.tableView reloadData];
    });
}

#pragma mark Table
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 1? 15: 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    if (indexPath.section == 0) {
        height = 60;
    }else{
        if (indexPath.row == 0) {
            height = _platformIndex == 2? 0: 44;
        }else{
            if (_platformIndex == 2) {
                CGFloat tipLWidth = kScreen_Width - 2* (15 + 15 + 10);
                CGFloat textWidth = kScreen_Width - 2* (15 + 15);
                height = (15 + 10 +
                          [_tipL.text getHeightWithFont:_tipL.font constrainedToSize:CGSizeMake(tipLWidth, CGFLOAT_MAX)] +
                          10 + 15 +
                          50* 3 +
                          30 +
                          [_remarkL.text getHeightWithFont:_remarkL.font constrainedToSize:CGSizeMake(textWidth, CGFLOAT_MAX)] +
                          20 +
                          [_contactL.text getHeightWithFont:_contactL.font constrainedToSize:CGSizeMake(textWidth, CGFLOAT_MAX)] +
                          15);
            }else{
                height = 0;
            }
        }
    }
    return height;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:15];
    }else{
        if (_platformIndex != 2) {
            [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:0];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        self.platformIndex = indexPath.row;
    }
}

#pragma mark - app url
- (BOOL)p_canOpenWeiXin{
    return [self p_canOpen:@"weixin://"];
}

- (BOOL)p_canOpenAlipay{
    return [self p_canOpen:@"alipay://"];
}

- (BOOL)p_canOpen:(NSString*)url{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]];
}

#pragma mark Btn

- (IBAction)bottomBtnClicked:(UIButton *)sender {
    if (_platformIndex == PayMethodWeiXin && ![self p_canOpenWeiXin]){
        [NSObject showHudTipStr:@"您还没有安装「微信」"];
        return;
    }
    if (_priceF.text.floatValue < 0 || _priceF.text.floatValue > 100000) {
        [NSObject showHudTipStr:@"充值金额必须在「1 ~ 100,000」元之间, 最多保留两位小数!"];
        return;
    }
    __weak typeof(self) weakSelf = self;
    [sender startQueryAnimate];
    [[Coding_NetAPIManager sharedManager] post_GenerateOrderWithDepositPrice:@(_priceF.text.floatValue) methodType:_platformIndex block:^(id data, NSError *error) {
        [sender stopQueryAnimate];
        if (data) {
            weakSelf.payDict = data;
            [weakSelf goToPay];
        }
    }];
}


- (void)goToPay{
    if (_platformIndex == PayMethodAlipay) {
        [self aliPay];
    }else if (_platformIndex == PayMethodWeiXin){
        [self weixinPay];
    }
}

- (void)weixinPay{
    PayReq *req = [PayReq new];
    NSDictionary *resultDict = _payDict[@"weixinAppResult"];
    
    req.partnerId = resultDict[@"partnerId"];
    req.prepayId = resultDict[@"prepayId"];
    req.nonceStr = resultDict[@"nonceStr"];
    req.timeStamp = [resultDict[@"timestamp"] intValue];
    req.package = resultDict[@"package"];
    req.sign = resultDict[@"sign"];
    [WXApi sendReq:req];
}

- (void)aliPay{
    __weak typeof(self) weakSelf = self;
    [[AlipaySDK defaultService] payOrder:_payDict[@"alipayAppResult"][@"order"] fromScheme:kAppScheme callback:^(NSDictionary *resultDic) {
        [weakSelf handleAliResult:resultDic];
    }];
}

#pragma mark - handleSucessPay
- (void)handlePayURL:(NSURL *)url{
    if (_platformIndex == PayMethodAlipay) {
        __weak typeof(self) weakSelf = self;
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [weakSelf handleAliResult:resultDic];
        }];
    }else if (_platformIndex == PayMethodWeiXin){
        NSInteger resultCode = [[url queryParams][@"ret"] intValue];
        if (resultCode == 0) {
            [self paySucess];
        }else if (resultCode == -1){
            [NSObject showHudTipStr:@"支付失败"];
        }
    }
}

- (void)handleAliResult:(NSDictionary *)resultDic{
    if ([resultDic[@"resultStatus"] integerValue] == 9000) {
        [self paySucess];
    }else{
        NSString *tipStr = resultDic[@"memo"];
        [NSObject showHudTipStr:tipStr.length > 0? tipStr: @"支付失败"];
    }
}

- (void)paySucess{
    NSString *orderId = _payDict[@"orderId"];
    if (orderId.length <= 0) {
        return;
    }
    [NSObject showHUDQueryStr:@"正在查询订单状态..."];
    [[Coding_NetAPIManager sharedManager] get_MPayOrderStatus:orderId block:^(id data, NSError *error) {
        if ([data[@"status"] isEqual:@(1)]) {//交易成功
            [NSObject hideHUDQuery];
            [self goToSucessVC:data];
        }else{
            [self paySucess];
        }
    }];
}

- (void)goToSucessVC:(NSDictionary *)orderDict{
    kTipAlert(@"支付成功");
    
    if (self.navigationController.topViewController == self) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
