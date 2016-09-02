//
//  MPayPasswordByPhoneViewController.m
//  CodingMart
//
//  Created by Ease on 16/8/5.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "MPayPasswordByPhoneViewController.h"
#import "PhoneCodeButton.h"
#import "Coding_NetAPIManager.h"

@interface MPayPasswordByPhoneViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneF;
@property (weak, nonatomic) IBOutlet UITextField *codeF;
@property (weak, nonatomic) IBOutlet UITextField *passwordF;
@property (weak, nonatomic) IBOutlet UITextField *confirm_passwordF;
@property (weak, nonatomic) IBOutlet PhoneCodeButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *footerBtn;
@end

@implementation MPayPasswordByPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self lazyRefresh];
}

- (void)lazyRefresh{
    if (_psd) {
        _phoneF.text= [NSString stringWithFormat:@"%@ %@", _psd.phoneCountryCode ?: @"+86", _psd.mobile];
    }else{
        WEAKSELF;
        [NSObject showHUDQueryStr:@"请稍等..."];
        [[Coding_NetAPIManager sharedManager] get_MPayPasswordBlock:^(id data, NSError *error) {
            [NSObject hideHUDQuery];
            weakSelf.psd = data;
            weakSelf.phoneF.text = [NSString stringWithFormat:@"%@ %@", weakSelf.psd.phoneCountryCode ?: @"+86", weakSelf.psd.mobile];
        }];
    }
}

- (IBAction)codeBtnClicked:(PhoneCodeButton *)sender {
    if (![_psd.mobile isPhoneNo]) {
        [NSObject showHudTipStr:@"手机号码格式有误"];
        return;
    }
    sender.enabled = NO;
    NSString *path = @"api/userinfo/send_verify_code_with_country";
    NSDictionary *params = @{@"mobile": _psd.mobile,
                             @"phoneCountryCode": _psd.phoneCountryCode};
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
    if (_passwordF.text.length <= 0){
        tipStr = @"请输入新交易密码";
    }else if (_confirm_passwordF.text.length <= 0) {
        tipStr = @"请确认新交易密码";
    }else if (![_passwordF.text isEqualToString:_confirm_passwordF.text]){
        tipStr = @"两次输入的交易密码不一致";
    }else if (_passwordF.text.length < 6){
        tipStr = @"新交易密码不能少于6位";
    }else if (_passwordF.text.length > 64){
        tipStr = @"新交易密码不得长于64位";
    }else if (_codeF.text.length <= 0){
        tipStr = @"请填写手机验证码";
    }
    if (tipStr.length > 0) {
        [NSObject showHudTipStr:tipStr];
        return;
    }
    [MobClick event:kUmeng_Event_UserAction label:@"设置_账号设置_设置交易密码"];
    _psd.verifyCode = _codeF.text;
    _psd.nextPassword = [_passwordF.text sha1Str];
    __weak typeof(self) weakSelf = self;
    [NSObject showHUDQueryStr:@"正在保存..."];
    [[Coding_NetAPIManager sharedManager] post_MPayPassword:_psd isPhoneCodeUsed:YES block:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [NSObject showHudTipStr:@"修改交易密码成功"];
        }
    }];
}

@end
