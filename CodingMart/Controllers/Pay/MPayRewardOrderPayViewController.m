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

@interface MPayRewardOrderPayViewController ()
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;

@property (strong, nonatomic) NSString *balanceStr;
@property (strong, nonatomic) NSNumber *balanceValue;
@end

@implementation MPayRewardOrderPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setBalanceStr:(NSString *)balanceStr{
    _balanceStr = balanceStr;
    [self.tableView reloadData];
}

- (void)setBalanceValue:(NSNumber *)balanceValue{
    _balanceValue = balanceValue;
    [_bottomBtn setTitle:[self p_isBalanceEnough]? @"确认支付": @"充值开发宝" forState:UIControlStateNormal];
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
        [weakSelf.tableView reloadData];
    }];
}

- (BOOL)p_isBalanceEnough{
    return (_balanceValue.floatValue >= (_curMPayOrders? _curMPayOrders.orderAmount.floatValue: _curMPayOrder.totalFee.floatValue));
}

- (IBAction)bottomBtnClicked:(id)sender {
    if ([self p_isBalanceEnough]) {
        WEAKSELF;
        [NSObject showHUDQueryStr:@"请稍等..."];
        [[Coding_NetAPIManager sharedManager] get_MPayAccountsBlock:^(MPayAccounts *data, NSError *error) {
            [NSObject hideHUDQuery];
            [weakSelf dealWithMPayAccounts:data];
        }];
    }else{
        [self goToDepositVC];
    }
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
}

- (void)sendRequestWithPsd:(NSString *)psd{
    if (_curMPayOrders) {
        WEAKSELF;
        [NSObject showHUDQueryStr:@"正在支付..."];
        [[Coding_NetAPIManager sharedManager] post_MPayOrderIdList:[_curMPayOrders.order valueForKey:@"orderId"] password:psd block:^(id data, NSError *error) {
            [NSObject hideHUDQuery];
            if (data && [(NSNumber *)data boolValue]) {
                if (weakSelf.paySuccessBlock) {
                    weakSelf.paySuccessBlock(weakSelf.curMPayOrders);
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }else{
                    MPayRewardOrderPayResultViewController *vc = [MPayRewardOrderPayResultViewController vcInStoryboard:@"Pay"];
                    vc.curReward = weakSelf.curReward;
                    vc.curMPayOrders = weakSelf.curMPayOrders;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
            }
        }];
    }else{
        WEAKSELF;
        [NSObject showHUDQueryStr:@"正在支付..."];
        [[Coding_NetAPIManager sharedManager] post_MPayOrderId:_curMPayOrder.orderId password:psd block:^(id data, NSError *error) {
            [NSObject hideHUDQuery];
            if (data && [(NSNumber *)data boolValue]) {
                if (weakSelf.paySuccessBlock) {
                    weakSelf.paySuccessBlock(weakSelf.curMPayOrder);
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }else{
                    MPayRewardOrderPayResultViewController *vc = [MPayRewardOrderPayResultViewController vcInStoryboard:@"Pay"];
                    vc.curReward = weakSelf.curReward;
                    vc.curMPayOrder = weakSelf.curMPayOrder;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
            }
        }];
    }
}

#pragma mark Table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0 && _curMPayOrders? _curMPayOrders.order.count: 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        MPayOrder *mPayOrder = _curMPayOrders? _curMPayOrders.order[indexPath.row]: _curMPayOrder;
        MPayOrderPayCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MPayOrderPayCell forIndexPath:indexPath];
        cell.curOrder = mPayOrder;
        [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:15];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self p_isBalanceEnough]? kCellIdentifier_MPayLeftMoneyCell_Enough: kCellIdentifier_MPayLeftMoneyCell_Lack forIndexPath:indexPath];
        UILabel *balanceL = [cell viewWithTag:200];
        balanceL.text = [NSString stringWithFormat:@"￥ %@", _balanceStr];
        [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:15];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        MPayOrder *mPayOrder = _curMPayOrders? _curMPayOrders.order[indexPath.row]: _curMPayOrder;
        return [MPayOrderPayCell cellHeightWithObj:mPayOrder];
    }else{
        return [self p_isBalanceEnough]? 44: 60;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 && _curMPayOrders.order.count > 1) {
        return 44;
    }else{
        return section == 0? 0: 10;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerV = [UIView new];
    headerV.backgroundColor = self.tableView.backgroundColor;
    if (section == 0 && _curMPayOrders.order.count > 1) {
        UILabel *headerL = [UILabel labelWithSystemFontSize:15 textColorHexString:@"0xF5A623"];
        headerL.text = [NSString stringWithFormat:@"交易总金额 %@ 元", _curMPayOrders.orderAmount];
        [headerV addSubview:headerL];
        [headerL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(headerV);
        }];
    }
    return headerV;
}
@end
