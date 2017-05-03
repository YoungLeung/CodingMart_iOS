//
//  SettingPhoneViewController.m
//  CodingMart
//
//  Created by Ease on 16/6/22.
//  Copyright © 2016年 net.coding. All rights reserved.
//

//废弃的 VC

#import "SettingPhoneViewController.h"
#import "PhoneCodeButton.h"
#import "Coding_NetAPIManager.h"
#import "CountryCodeListViewController.h"

@interface SettingPhoneViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneF;
@property (weak, nonatomic) IBOutlet UITextField *codeF;
@property (weak, nonatomic) IBOutlet UITextField *two_factor_codeF;
@property (weak, nonatomic) IBOutlet PhoneCodeButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *footerBtn;
@property (assign, nonatomic) BOOL is2FAOpen;

@property (weak, nonatomic) IBOutlet UILabel *phoneCountryCodeL;
@property (strong, nonatomic) NSDictionary *countryCodeDict;


@end

@implementation SettingPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _phoneCountryCodeL.text = _curUser.countryCode.length > 0? _curUser.countryCode: @"+86";
    _phoneF.text = _curUser.phone;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refresh2FA];
}


- (void)refresh2FA{
    BOOL is2FAOpen = NO;
    self.is2FAOpen = is2FAOpen;
    self.two_factor_codeF.placeholder = is2FAOpen? @"输入两步验证码": @"输入密码";
    self.two_factor_codeF.secureTextEntry = !is2FAOpen;

//    __weak typeof(self) weakSelf = self;
//    [[Coding_NetAPIManager sharedManager] get_is2FAOpenBlock:^(BOOL is2FAOpen, NSError *error) {
//        if (!error) {
//            if (is2FAOpen != weakSelf.is2FAOpen) {
//                weakSelf.two_factor_codeF.text = nil;
//            }
//            weakSelf.is2FAOpen = is2FAOpen;
//            weakSelf.two_factor_codeF.placeholder = is2FAOpen? @"输入两步验证码": @"输入密码";
//            weakSelf.two_factor_codeF.secureTextEntry = !is2FAOpen;
//        }
//    }];
}

- (IBAction)phoneCountryCodeBtnClicked:(id)sender {
    CountryCodeListViewController *vc = [CountryCodeListViewController storyboardVC];
    WEAKSELF;
    vc.selectedBlock = ^(NSDictionary *countryCodeDict){
        weakSelf.countryCodeDict = countryCodeDict;
        weakSelf.phoneCountryCodeL.text = [NSString stringWithFormat:@"+%@", _countryCodeDict[@"country_code"]];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)codeBtnClicked:(PhoneCodeButton *)sender {
    if (![_phoneF.text isPhoneNo]) {
        [NSObject showHudTipStr:@"手机号码格式有误"];
        return;
    }
    sender.enabled = NO;
    NSString *path = @"api/account/phone/change/code";
    NSDictionary *params = @{@"phone": _phoneF.text,
                             @"phoneCountryCode": _phoneCountryCodeL.text};
    [[CodingNetAPIClient codingJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        if (data) {
            [NSObject showHudTipStr:@"验证码发送成功"];
            [sender startUpTimer];
        }else{
            [sender invalidateTimer];
        }
    }];
}

- (IBAction)footerBtnClicked:(id)sender {
    NSString *tipStr;
    if (![_phoneF.text isPhoneNo]) {
        tipStr = @"手机号码格式有误";
    }else if (_codeF.text.length <= 0){
        tipStr = @"请填写手机验证码";
    }else if (_two_factor_codeF.text.length <= 0){
        tipStr = !_is2FAOpen? @"请填写密码": @"请填写两步验证码";
    }
    if (tipStr.length > 0) {
        [NSObject showHudTipStr:tipStr];
        return;
    }
    [MobClick event:kUmeng_Event_UserAction label:@"设置_账号设置_设置手机"];
    NSMutableDictionary *params = @{@"phone": _phoneF.text,
                                    @"code": _codeF.text,
                                    @"phoneCountryCode": _phoneCountryCodeL.text,
                                    @"two_factor_code": !_is2FAOpen? [_two_factor_codeF.text sha1Str]: _two_factor_codeF.text}.mutableCopy;
    __weak typeof(self) weakSelf = self;
    [NSObject showHUDQueryStr:@"正在保存..."];
    [[CodingNetAPIClient codingJsonClient] requestJsonDataWithPath:@"api/account/phone/change" withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            [NSObject showHudTipStr:@"手机号码绑定成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0? 20: 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0/[UIScreen mainScreen].scale;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:15];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
