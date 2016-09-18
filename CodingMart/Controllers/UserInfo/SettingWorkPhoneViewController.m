//
//  SettingWorkPhoneViewController.m
//  CodingMart
//
//  Created by Ease on 16/7/7.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "SettingWorkPhoneViewController.h"
#import "PhoneCodeButton.h"
#import "Coding_NetAPIManager.h"
#import "CountryCodeListViewController.h"

@interface SettingWorkPhoneViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneF;
@property (weak, nonatomic) IBOutlet UITextField *codeF;
@property (weak, nonatomic) IBOutlet PhoneCodeButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *footerBtn;
@property (weak, nonatomic) IBOutlet UILabel *phoneCountryCodeL;
@property (strong, nonatomic) NSDictionary *countryCodeDict;
@end

@implementation SettingWorkPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _phoneCountryCodeL.text = _userInfo.phoneCountryCode;
    _phoneF.text = _userInfo.mobile;
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
    NSString *path = @"api/userinfo/send_verify_code_with_country";
    NSDictionary *params = @{@"mobile": _phoneF.text,
                             @"phoneCountryCode": _phoneCountryCodeL.text};
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
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
    }
    if (tipStr.length > 0) {
        [NSObject showHudTipStr:tipStr];
        return;
    }
    [MobClick event:kUmeng_Event_UserAction label:@"个人信息_设置手机"];
    NSMutableDictionary *params = @{@"mobile": _phoneF.text,
                                    @"code": _codeF.text,
                                    @"phoneCountryCode": _phoneCountryCodeL.text,
                                    @"country": _countryCodeDict? _countryCodeDict[@"iso_code"]: _userInfo.country}.mutableCopy;
    __weak typeof(self) weakSelf = self;
    [NSObject showHUDQueryStr:@"正在保存..."];
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/userinfo/mobile" withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            [NSObject showHudTipStr:@"号码设置成功"];
            if (weakSelf.complateBlock) {
                weakSelf.complateBlock(params[@"country"], params[@"phoneCountryCode"], params[@"mobile"]);
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

@end









