//
//  PasswordPhoneViewController.m
//  CodingMart
//
//  Created by Ease on 15/12/14.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "PasswordPhoneViewController.h"
#import "PasswordPhoneSetViewController.h"

#import "PhoneCodeButton.h"
#import "TableViewFooterButton.h"
#import "Coding_NetAPIManager.h"
#import <ReactiveCocoa/ReactiveCocoa.h>


@interface PasswordPhoneViewController ()
@property (weak, nonatomic) IBOutlet UILabel *headerL;
@property (weak, nonatomic) IBOutlet UITextField *mobileF;
@property (weak, nonatomic) IBOutlet UITextField *verify_codeF;
@property (weak, nonatomic) IBOutlet PhoneCodeButton *verify_codeBtn;

@property (weak, nonatomic) IBOutlet TableViewFooterButton *footerBtn;
@end

@implementation PasswordPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = (_reasonType == CannotLoginReasonForget)? @"忘记密码": @"设置密码";
    _headerL.text = (_reasonType == CannotLoginReasonForget)? @"为了重置密码，请先验证您的注册手机": @"为了设置密码，请先验证您的注册手机";
    _mobileF.text = _phone;
    RAC(self, footerBtn.enabled) = [RACSignal combineLatest:@[self.mobileF.rac_textSignal, self.verify_codeF.rac_textSignal] reduce:^id(NSString *mobile, NSString *verify_code){
        return @(mobile.length > 0 && verify_code.length > 0);
    }];
}

#pragma mark - Button
- (IBAction)verify_codeBtnClicked:(id)sender {
    if (_mobileF.text.length <= 0) {
        [NSObject showHudTipStr:@"请填写手机号码先"];
        return;
    }
    _verify_codeBtn.enabled = NO;
    PurposeType type = (_reasonType == CannotLoginReasonForget)? PurposeToPasswordReset: PurposeToPasswordActivate;
    [[Coding_NetAPIManager sharedManager] post_GeneratePhoneCodeWithPhone:_mobileF.text type:type block:^(id data, NSError *error) {
        if (data) {
            [NSObject showHudTipStr:@"验证码发送成功"];
            [self.verify_codeBtn startUpTimer];
        }else{
            self.verify_codeBtn.enabled = YES;
        }
    }];
}
- (IBAction)footerBtnClicked:(id)sender {
    PurposeType type = (_reasonType == CannotLoginReasonForget)? PurposeToPasswordReset: PurposeToPasswordActivate;
    [NSObject showHUDQueryStr:@"正在校验验证码..."];
    [[Coding_NetAPIManager sharedManager] post_CheckPhoneCodeWithPhone:_mobileF.text code:_verify_codeF.text type:type block:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            [self performSegueWithIdentifier:NSStringFromClass([PasswordPhoneSetViewController class]) sender:self];
        }
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[PasswordPhoneSetViewController class]]) {
        PasswordPhoneSetViewController *vc = (PasswordPhoneSetViewController *)segue.destinationViewController;
        vc.phone = _mobileF.text;
        vc.code = _verify_codeF.text;
        vc.reasonType = _reasonType;
    }
}

@end
