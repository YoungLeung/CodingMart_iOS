//
//  RegisterPhoneViewController.m
//  CodingMart
//
//  Created by Ease on 15/12/14.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "RegisterPhoneViewController.h"
#import "RegisterPasswordViewController.h"
#import "PhoneCodeButton.h"
#import "TableViewFooterButton.h"
#import "UITTTAttributedLabel.h"
#import "Coding_NetAPIManager.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface RegisterPhoneViewController ()
@property (weak, nonatomic) IBOutlet UITextField *mobileF;
@property (weak, nonatomic) IBOutlet UITextField *verify_codeF;
@property (weak, nonatomic) IBOutlet PhoneCodeButton *verify_codeBtn;

@property (weak, nonatomic) IBOutlet TableViewFooterButton *footerBtn;
@property (weak, nonatomic) IBOutlet UITTTAttributedLabel *footerL;

@end

@implementation RegisterPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __weak typeof(self) weakSelf = self;
    [_footerL addLinkToStr:@"《码市用户协议》" whithValue:nil andBlock:^(id value) {
        [weakSelf goToServiceTerms];
    }];
    _mobileF.text = _mobile;
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
    [[Coding_NetAPIManager sharedManager] post_GeneratePhoneCodeWithPhone:_mobileF.text type:PurposeToRegister block:^(id data, NSError *error) {
        if (data) {
            [NSObject showHudTipStr:@"验证码发送成功"];
            [self.verify_codeBtn startUpTimer];
        }else{
            self.verify_codeBtn.enabled = YES;
        }
    }];
}
- (IBAction)footerBtnClicked:(id)sender {
    [NSObject showHUDQueryStr:@"正在校验验证码..."];
    [[Coding_NetAPIManager sharedManager] post_CheckPhoneCodeWithPhone:_mobileF.text code:_verify_codeF.text type:PurposeToRegister block:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            [self performSegueWithIdentifier:NSStringFromClass([RegisterPasswordViewController class]) sender:self];
        }
    }];
}

#pragma mark goTo
- (void)goToServiceTerms{
    NSString *pathForServiceterms = [[NSBundle mainBundle] pathForResource:@"service_terms" ofType:@"html"];
    [self goToWebVCWithUrlStr:pathForServiceterms title:@"用户协议"];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[RegisterPasswordViewController class]]) {
        RegisterPasswordViewController *vc = (RegisterPasswordViewController *)segue.destinationViewController;
        vc.phone = _mobileF.text;
        vc.code = _verify_codeF.text;
        vc.loginSucessBlock = _loginSucessBlock;
    }
}

@end