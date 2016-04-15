//
//  PayMethodViewController.m
//  CodingMart
//
//  Created by Ease on 16/1/25.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "PayMethodViewController.h"
#import <TPKeyboardAvoiding/TPKeyboardAvoidingTableView.h>
#import "Coding_NetAPIManager.h"
#import "PayMethodRewardCell.h"
#import "PayMethodTipCell.h"
#import "PayMethodItemCell.h"
#import "PayMethodInputCell.h"
#import "PayMethodRemarkCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "PayResultViewController.h"
#import "UIButton+Query.h"

#import <UMengSocial/WXApi.h>
#import <UMengSocial/WXApiObject.h>
#import <AlipaySDK/AlipaySDK.h>
#import "TableViewFooterButton.h"

@interface PayMethodViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *myTableView;
@property (weak, nonatomic) IBOutlet TableViewFooterButton *payBtn;

@property (strong, nonatomic) NSDictionary *payDict;
@end

@implementation PayMethodViewController

+ (instancetype)storyboardVC{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Pay" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"PayMethodViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//- (void)refresh{
//    __weak typeof(self) weakSelf = self;
//    [[Coding_NetAPIManager sharedManager] get_RewardPrivateDetailWithId:self.curReward.id.integerValue block:^(id data, NSError *error) {
//        if (data) {
//            weakSelf.curReward = data;
//            [weakSelf.myTableView reloadData];
//        }
//    }];
//}

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
#pragma mark - TableM
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height;
    if (section == 0) {
        height = 0;
    }else if (section == 1){
        height = 40;
    }else{
        height = 25;
        height += [[self p_lastHeaderTipStr] getHeightWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(kScreen_Width - 30, CGFLOAT_MAX)];
    }
    return height;
}

- (NSString *)p_lastHeaderTipStr{
    NSString *tipStr =
    _curReward.payType == PayMethodBank? @"抱歉，目前只支持线下转账方式，您在转账的时候请务必写上备注信息，谢谢配合！":
    _curReward.balance.floatValue >= 5000? @"支持多次付款，本次付款金额不能少于 ￥5,000":
    @"项目未付款项低于 ¥5,000，需一次性完成支付";
    return tipStr;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *tipStr = nil;
    if (section == 1) {
        tipStr = @"支付方式";
    }else if (section == 2){
        tipStr = [self p_lastHeaderTipStr];
    }
    UIView *headerV;
    if (tipStr.length > 0) {
        headerV = [UIView new];
        headerV.backgroundColor = self.myTableView.backgroundColor;
        UILabel *headerL = [UILabel new];
        headerL.font = [UIFont systemFontOfSize:12];
        headerL.textColor = [UIColor colorWithHexString:@"0x999999"];
        headerL.numberOfLines = 0;
        headerL.text = tipStr;
        [headerV addSubview:headerL];
        [headerL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headerV).offset(15);
            make.left.equalTo(headerV).offset(15);
            make.right.equalTo(headerV).offset(-15);
        }];
    }
    return headerV;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger numOfRows;
    if (section == 0) {
        numOfRows = [_curReward hasPaidSome]? 2: 1;
    }else if (section == 1){
        numOfRows = 3;
    }else{
        numOfRows = 1;
    }
    return numOfRows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    if (indexPath.section == 0) {
        height = indexPath.row == 0? [PayMethodRewardCell cellHeight]: [PayMethodTipCell cellHeight];
    }else if (indexPath.section == 1){
//        height = [PayMethodItemCell cellHeight];
        height = indexPath.row == 1? 0: [PayMethodItemCell cellHeight];
    }else{
        height = _curReward.payType < PayMethodBank? [PayMethodInputCell cellHeight]: [PayMethodRemarkCell cellHeight];
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            PayMethodRewardCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_PayMethodRewardCell forIndexPath:indexPath];
            cell.curReward = _curReward;
            return cell;
        }else{
            PayMethodTipCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_PayMethodTipCell forIndexPath:indexPath];
            cell.balanceStr = _curReward.format_balance;
            return cell;
        }
    }else if (indexPath.section == 1){
        PayMethodItemCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%@_%ld", kCellIdentifier_PayMethodItemCellPrefix, (long)indexPath.row] forIndexPath:indexPath];
        cell.isChoosed = (_curReward.payType == indexPath.row);
        return cell;
    }else{
        if (_curReward.payType < PayMethodBank) {
            PayMethodInputCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_PayMethodInputCell forIndexPath:indexPath];
            cell.textF.text = _curReward.payMoney;
            cell.textF.userInteractionEnabled = !(_curReward.balance && _curReward.balance.floatValue < 5000);
            __weak typeof(self) weakSelf = self;
            [cell.textF.rac_textSignal subscribeNext:^(NSString *value) {
                weakSelf.curReward.payMoney = value;
            }];
            return cell;
        }else{
            PayMethodRemarkCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_PayMethodRemarkCell forIndexPath:indexPath];
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:(indexPath.section == 0 && indexPath.row == 0? 0: 15) hasSectionLine:indexPath.section != 2];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    if (indexPath.section == 1) {
        self.curReward.payType = indexPath.row;
        [self.myTableView reloadData];
//        [self.myTableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)] withRowAnimation:UITableViewRowAnimationFade];
    }
}
#pragma mark - Btn

- (IBAction)payBtnClicked:(UIButton *)sender {
    if (_curReward.payType >= PayMethodBank) {
        [NSObject showHudTipStr:@"暂时不支持线上转账"];
        return;
    }else if (_curReward.payType == PayMethodWeiXin && [self p_canOpenWeiXin]){
        [NSObject showHudTipStr:@"您还没有安装「微信」"];
        return;
    }
    if (_curReward.payMoney.floatValue < 5000) {
        if (_curReward.payMoney.floatValue < _curReward.balance.floatValue) {
            [NSObject showHudTipStr:[NSString stringWithFormat:@"本次付款金额不可低于 ￥%.2f", MIN(_curReward.balance.floatValue, 5000.0)]];
            return;
        }
    }else if (_curReward.payMoney.floatValue > _curReward.balance.floatValue){
        [NSObject showHudTipStr:@"本次付款金额不可高于待支付金额"];
        return;
    }
    __weak typeof(self) weakSelf = self;
    [sender startQueryAnimate];
    [[Coding_NetAPIManager sharedManager] post_GenerateOrderWithReward:_curReward block:^(id data, NSError *error) {
        [sender stopQueryAnimate];
        if (data) {
            weakSelf.payDict = data;
            [weakSelf goToPay];
        }
    }];
}

- (void)goToPay{
    if (_curReward.payType == PayMethodAlipay) {
        [self aliPay];
    }else if (_curReward.payType == PayMethodWeiXin){
        [self weixinPay];
    }
}

- (void)weixinPay{
    NSDictionary *result = _payDict[@"result"];
    
    PayReq *req = [PayReq new];
    req.partnerId = result[@"partnerid"];
    req.prepayId = result[@"prepayid"];
    req.nonceStr = result[@"noncestr"];
    req.timeStamp = [result[@"timestamp"] intValue];
    req.package = result[@"package"];
    req.sign = result[@"sign"];
    [WXApi sendReq:req];
}

- (void)aliPay{
//    NSDictionary *result = _payDict[@"result"];

    __weak typeof(self) weakSelf = self;
    [[AlipaySDK defaultService] payOrder:_payDict[@"order"] fromScheme:kAppScheme callback:^(NSDictionary *resultDic) {
        [weakSelf handleAliResult:resultDic];
    }];
}

#pragma mark - handleSucessPay
- (void)handlePayURL:(NSURL *)url{
    if (_curReward.payType == PayMethodAlipay) {
        __weak typeof(self) weakSelf = self;
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [weakSelf handleAliResult:resultDic];
        }];
    }else if (_curReward.payType == PayMethodWeiXin){
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
    NSString *orderNo = _payDict[@"charge_id"];
    if (orderNo.length <= 0) {
        return;
    }
    [NSObject showHUDQueryStr:@"正在查询订单状态..."];
    [[Coding_NetAPIManager sharedManager] get_Order:orderNo block:^(id data, NSError *error) {
        if ([data[@"status"] isEqual:@(1)]) {//交易成功
            [NSObject hideHUDQuery];
            [self goToSucessVC:data];
        }else{
            [self paySucess];
        }
    }];
}

- (void)goToSucessVC:(NSDictionary *)orderDict{
    if (self.navigationController.topViewController == self) {
        UINavigationController *nav = self.navigationController;
        PayResultViewController *vc = [PayResultViewController storyboardVC];
        vc.orderDict = orderDict;
        
        [nav popViewControllerAnimated:NO];
        [nav pushViewController:vc animated:YES];
    }
}
@end
