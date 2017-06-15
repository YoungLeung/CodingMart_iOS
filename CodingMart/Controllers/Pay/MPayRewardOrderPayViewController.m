//
//  MPayRewardOrderPayViewController.m
//  CodingMart
//
//  Created by Ease on 16/8/10.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#define kCellIdentifier_MPayLeftMoneyCell_Lack @"MPayLeftMoneyCell_Lack"
#define kCellIdentifier_MPayLeftMoneyCell_Enough @"MPayLeftMoneyCell_Enough"

#import "MPayRewardOrderPayViewController.h"
#import "Coding_NetAPIManager.h"
#import "EATextEditView.h"
#import "MPayDepositViewController.h"
#import "MPayPasswordByPhoneViewController.h"
#import "MPayRewardOrderPayResultViewController.h"
#import "MPayAccounts.h"
#import "EATipView.h"
#import "FillUserInfoViewController.h"
#import "MPayOrderPayCell.h"
#import <UMengSocial/WXApi.h>
#import <UMengSocial/WXApiObject.h>
#import <AlipaySDK/AlipaySDK.h>


@interface MPayRewardOrderPayViewController ()
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;
@property (weak, nonatomic) IBOutlet UIButton *depositBtn;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceL;

@property (strong, nonatomic) NSString *balanceStr;
@property (strong, nonatomic) NSNumber *balanceValue;

@property (assign, nonatomic) NSInteger payMethod;//0 mart, 1 alipay, 2 wechat
@property (strong, nonatomic) NSDictionary *payDict;
@end

@implementation MPayRewardOrderPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.myTableView.backgroundColor = kColorBGDark;
    self.totalPriceL.text = [NSString stringWithFormat:@"交易总金额 %@ 元", _curMPayOrders? _curMPayOrders.orderAmount: _curMPayOrder.totalFee];
    self.payMethod = 0;
}

- (void)setBalanceStr:(NSString *)balanceStr{
    _balanceStr = balanceStr;
    [self.myTableView reloadData];
}

- (void)setBalanceValue:(NSNumber *)balanceValue{
    _balanceValue = balanceValue;
    _bottomBtn.enabled = [self p_isBalanceEnough] || self.payMethod != 0;
    _depositBtn.hidden = [self p_isBalanceEnough];
}

- (void)setPayMethod:(NSInteger)payMethod{
    _payMethod = payMethod;
    _bottomBtn.enabled = [self p_isBalanceEnough] || self.payMethod != 0;
    [self.myTableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refresh];
}

- (void)refresh{
    WEAKSELF;
    [[Coding_NetAPIManager sharedManager] get_MPayBalanceBlock:^(NSDictionary *data, NSError *error) {
        weakSelf.balanceStr = data[@"balance"];
        weakSelf.balanceValue = data[@"balanceValue"];
        [weakSelf.myTableView reloadData];
    }];
}

- (BOOL)p_isBalanceEnough{
    return (_balanceValue.floatValue >= (_curMPayOrders? _curMPayOrders.orderAmount.floatValue: _curMPayOrder.totalFee.floatValue));
}

- (IBAction)bottomBtnClicked:(id)sender {
    WEAKSELF;
    [NSObject showHUDQueryStr:@"请稍等..."];
    [[Coding_NetAPIManager sharedManager] get_MPayAccountsBlock:^(MPayAccounts *data, NSError *error) {
        [NSObject hideHUDQuery];
        [weakSelf dealWithMPayAccounts:data];
    }];
}
- (IBAction)depositBtnClicked:(id)sender {
    [self goToDepositVC];
}

- (void)dealWithMPayAccounts:(MPayAccounts *)accounts{
    BOOL passIdentity =accounts.passIdentity.boolValue, hasPassword = accounts.hasPassword.boolValue;
    if (!passIdentity || !hasPassword) {//交易密码 && 个人信息
        //提示框
        WEAKSELF;
        void (^identityBlock)() = ^(){
            [weakSelf.navigationController pushViewController:[FillUserInfoViewController vcInStoryboard:@"UserInfo"] animated:YES];
        };
        void (^passwordBlock)() = ^(){
            MPayPasswordByPhoneViewController *vc = [MPayPasswordByPhoneViewController vcInStoryboard:@"UserInfo"];
            vc.title = @"设置交易密码";
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        EATipView *tipV;
        if (!passIdentity && !hasPassword) {
            tipV = [EATipView instancetypeWithTitle:@"您还未完善个人信息和设置交易密码！" tipStr:@"为了您的资金安全，您需要完善「个人信息」并「设置交易密码」后方可支付订单。"];
            [tipV setLeftBtnTitle:@"个人信息" block:identityBlock];
            [tipV setRightBtnTitle:@"设置交易密码" block:passwordBlock];
        }else if (!passIdentity){
            tipV = [EATipView instancetypeWithTitle:@"您还未完善个人信息！" tipStr:@"为了您的资金安全，您需要完善「个人信息」后方可支付订单。"];
            [tipV setLeftBtnTitle:@"取消" block:nil];
            [tipV setRightBtnTitle:@"个人信息" block:identityBlock];
        }else{
            tipV = [EATipView instancetypeWithTitle:@"您还未设置交易密码！" tipStr:@"为了您的资金安全，您需要「设置交易密码」后方可支付订单。"];
            [tipV setLeftBtnTitle:@"取消" block:nil];
            [tipV setRightBtnTitle:@"设置交易密码" block:passwordBlock];
        }
        [tipV showInView:self.view];
    }else{
        [self goToPay];
    }
}

- (void)goToDepositVC{
    MPayDepositViewController *vc = [MPayDepositViewController vcInStoryboard:@"UserInfo"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goToPay{
    if (self.payMethod == 0) {//开发宝
        WEAKSELF;
        EATextEditView *psdView = [EATextEditView instancetypeWithTitle:@"请输入交易密码" tipStr:@"请输入交易密码" andConfirmBlock:^(NSString *text) {
            [weakSelf sendRequestWithPsd:[text sha1Str]];
        }];
        psdView.isForPassword = YES;
        psdView.forgetPasswordBlock = ^(){
            MPayPasswordByPhoneViewController *vc = [MPayPasswordByPhoneViewController vcInStoryboard:@"UserInfo"];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        [psdView showInView:self.view];
    }else{
        if (self.payMethod == 2 && ![self p_canOpenWeiXin]){
            [NSObject showHudTipStr:@"您还没有安装「微信」"];
            return;
        }
        __weak typeof(self) weakSelf = self;
        [[Coding_NetAPIManager sharedManager] post_GenerateOrderWithDepositPrice:_curMPayOrders? _curMPayOrders.orderAmount: @(_curMPayOrder.totalFee.floatValue) orderIdList:_curMPayOrders? [_curMPayOrders.order valueForKey:@"orderId"]: @[_curMPayOrder.orderId] methodType:self.payMethod block:^(id data, NSError *error) {
            if (data) {
                weakSelf.payDict = data;
                if (self.payMethod == 1) {
                    [weakSelf aliPay];
                }else if (self.payMethod == 2){
                    [weakSelf weixinPay];
                }
            }
        }];
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

- (void)sendRequestWithPsd:(NSString *)psd{
    if (_curMPayOrders) {
        WEAKSELF;
        [NSObject showHUDQueryStr:@"正在支付..."];
        [[Coding_NetAPIManager sharedManager] post_MPayOrderIdList:[_curMPayOrders.order valueForKey:@"orderId"] password:psd block:^(id data, NSError *error) {
            [NSObject hideHUDQuery];
            if (data && [(NSNumber *)data boolValue]) {
                [weakSelf paySucess];
            }
        }];
    }else{
        WEAKSELF;
        [NSObject showHUDQueryStr:@"正在支付..."];
        [[Coding_NetAPIManager sharedManager] post_MPayOrderId:_curMPayOrder.orderId password:psd block:^(id data, NSError *error) {
            [NSObject hideHUDQuery];
            if (data && [(NSNumber *)data boolValue]) {
                [weakSelf paySucess];
            }
        }];
    }
}

#pragma mark - handleSucessPay
- (void)handlePayURL:(NSURL *)url{
    if (_payMethod == 1) {
        __weak typeof(self) weakSelf = self;
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [weakSelf handleAliResult:resultDic];
        }];
    }else if (_payMethod == 2){
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
    if (self.paySuccessBlock) {
        self.paySuccessBlock(self.curMPayOrders ?: self.curMPayOrder);
    }else{
        MPayRewardOrderPayResultViewController *vc = [MPayRewardOrderPayResultViewController vcInStoryboard:@"Pay"];
        vc.curReward = self.curReward;
        vc.curMPayOrders = self.curMPayOrders;
        vc.curMPayOrder = self.curMPayOrder;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)goToSucessVC:(NSDictionary *)orderDict{
    kTipAlert(@"支付成功");
    
    if (self.navigationController.topViewController == self) {
        [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark Table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return MAX(1, _curMPayOrders.order.count) + 1;
    }else{
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MPayHeaderCell" forIndexPath:indexPath];
            [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:15];
            return cell;
        }else{
            MPayOrder *mPayOrder = _curMPayOrders? _curMPayOrders.order[indexPath.row - 1]: _curMPayOrder;
            MPayOrderPayCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MPayOrderPayCell forIndexPath:indexPath];
            cell.curOrder = mPayOrder;
            [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:15];
            return cell;
        }
    }else{
        NSString *cellIdentifier = (indexPath.row == 0? @"MPayTypeMartCell":
                                    indexPath.row == 1? @"MPayTypeAliCell":
                                    @"MPayTypeWXCell");
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        UIImageView *checkV = [cell viewWithTag:202];
        checkV.image = [UIImage imageNamed:self.payMethod == indexPath.row? @"pay_checked": @"pay_unchecked"];
        if (indexPath.row == 0) {
            UILabel *balanceL = [cell viewWithTag:200];
            balanceL.text = [NSString stringWithFormat:@"￥%@", _balanceStr];
            UILabel *tipL = [cell viewWithTag:201];
            tipL.hidden = [self p_isBalanceEnough];
        }
        [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:50];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 44.0;
        }else{
            MPayOrder *mPayOrder = _curMPayOrders? _curMPayOrders.order[indexPath.section]: _curMPayOrder;
            return [MPayOrderPayCell cellHeightWithObj:mPayOrder];
        }
    }else{
        return indexPath.row == 0? 62: 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 1) {
        self.payMethod = indexPath.row;
    }
}
@end
