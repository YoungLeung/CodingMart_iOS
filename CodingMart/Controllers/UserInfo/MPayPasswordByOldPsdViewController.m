//
//  MPayPasswordByOldPsdViewController.m
//  CodingMart
//
//  Created by Ease on 16/8/5.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "MPayPasswordByOldPsdViewController.h"
#import "Coding_NetAPIManager.h"

@interface MPayPasswordByOldPsdViewController ()
@property (weak, nonatomic) IBOutlet UITextField *current_passwordF;
@property (weak, nonatomic) IBOutlet UITextField *passwordF;
@property (weak, nonatomic) IBOutlet UITextField *confirm_passwordF;
@property (weak, nonatomic) IBOutlet UIButton *footerBtn;
@end

@implementation MPayPasswordByOldPsdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)footerBtnClicked:(id)sender {
    [self.view endEditing:YES];
    NSString *tipStr = nil;
    if (_current_passwordF.text.length <= 0){
        tipStr = @"请输入当前交易交易密码";
    }else if (_passwordF.text.length <= 0){
        tipStr = @"请输入新交易密码";
    }else if (_confirm_passwordF.text.length <= 0) {
        tipStr = @"请确认新交易密码";
    }else if (![_passwordF.text isEqualToString:_confirm_passwordF.text]){
        tipStr = @"两次输入的交易密码不一致";
    }else if (_passwordF.text.length < 6){
        tipStr = @"新交易密码不能少于6位";
    }else if (_passwordF.text.length > 64){
        tipStr = @"新交易密码不得长于64位";
    }
    if (tipStr) {
        [NSObject showHudTipStr:tipStr];
        return;
    }
    [MobClick event:kUmeng_Event_UserAction label:@"设置_账号设置_设置交易密码"];
    if (!_psd) {
        _psd = [MPayPassword new];
    }
    _psd.oldPassword = [_current_passwordF.text sha1Str];
    _psd.nextPassword = [_passwordF.text sha1Str];
    
    WEAKSELF;
    [NSObject showHUDQueryStr:@"正在保存..."];
    [[Coding_NetAPIManager sharedManager] post_MPayPassword:_psd isPhoneCodeUsed:NO block:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [NSObject showHudTipStr:@"修改交易密码成功"];
        }
    }];
}


@end
