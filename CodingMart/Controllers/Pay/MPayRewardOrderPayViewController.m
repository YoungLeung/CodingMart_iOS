//
//  MPayRewardOrderPayViewController.m
//  CodingMart
//
//  Created by Ease on 16/8/10.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "MPayRewardOrderPayViewController.h"
#import "Coding_NetAPIManager.h"
#import "EATextEditView.h"
#import "MPayDepositViewController.h"
#import "MPayPasswordByPhoneViewController.h"
#import "MPayRewardOrderPayResultViewController.h"
#import "MPayAccounts.h"
#import "EATipView.h"
#import "FillUserInfoViewController.h"

@interface MPayRewardOrderPayViewController ()
@property (weak, nonatomic) IBOutlet UILabel *orderIdL;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *totalFeeL;
@property (weak, nonatomic) IBOutlet UILabel *balanceEnoughL;
@property (weak, nonatomic) IBOutlet UILabel *balanceLackL;

@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;

@property (strong, nonatomic) NSString *balanceStr;
@property (strong, nonatomic) NSNumber *balanceValue;
@end

@implementation MPayRewardOrderPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _orderIdL.text = _curMPayOrder.orderId;
    _titleL.text = _curMPayOrder.name;
    _totalFeeL.text = [NSString stringWithFormat:@"￥ %@", _curMPayOrder.totalFee];
}

- (void)setBalanceStr:(NSString *)balanceStr{
    _balanceStr = balanceStr;
    _balanceLackL.text = _balanceEnoughL.text = [NSString stringWithFormat:@"￥ %@", _balanceStr];
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
    return (_balanceValue.floatValue >= _curMPayOrder.totalFee.floatValue);
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
    WEAKSELF;
    [NSObject showHUDQueryStr:@"正在支付..."];
    [[Coding_NetAPIManager sharedManager] post_MPayOrderId:_curMPayOrder.orderId password:psd block:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data && [(NSNumber *)data boolValue]) {
            MPayRewardOrderPayResultViewController *vc = [MPayRewardOrderPayResultViewController vcInStoryboard:@"Pay"];
            vc.curReward = weakSelf.curReward;
            vc.curMPayOrder = weakSelf.curMPayOrder;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    }];
}

#pragma mark Table
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            CGFloat contentW = kScreen_Width - 15* 2 - 70 - 10;
            CGFloat contentH = [_curMPayOrder.name getHeightWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(contentW, CGFLOAT_MAX)];
            return MAX(44.0, contentH + 25);
        }else{
            return 44.0;
        }
    }else{
        BOOL isEnough = [self p_isBalanceEnough];
        if (indexPath.row == 0) {
            return isEnough? 44.0: 0;
        }else{
            return isEnough? 0: 60;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0? 0: 20;
}
@end
