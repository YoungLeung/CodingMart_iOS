//
//  LoginViewController.m
//  CodingMart
//
//  Created by Ease on 15/10/10.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "QuickLoginViewController.h"
#import "TableViewFooterButton.h"
#import "UITTTAttributedLabel.h"
#import "Coding_NetAPIManager.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "PhoneCodeButton.h"

@interface QuickLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *mobileF;
@property (weak, nonatomic) IBOutlet UITextField *verify_codeF;
@property (weak, nonatomic) IBOutlet PhoneCodeButton *verify_codeBtn;

@property (weak, nonatomic) IBOutlet TableViewFooterButton *footerBtn;
@property (weak, nonatomic) IBOutlet UITTTAttributedLabel *footerL;

@end

@implementation QuickLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __weak typeof(self) weakSelf = self;
    [_footerL addLinkToStr:@"《码市用户协议》" whithValue:nil andBlock:^(id value) {
        [weakSelf goToServiceTerms];
    }];
    _mobileF.text = _mobile;
    RAC(self, footerBtn.enabled) = [RACSignal combineLatest:@[_mobileF.rac_textSignal, _verify_codeF.rac_textSignal] reduce:^id(NSString *mobile, NSString *verify_code){
        return @(mobile.length > 0 && verify_code.length > 0);
    }];
}

#pragma mark Btn
- (IBAction)verify_codeBtnClicked:(id)sender {
    if (_mobileF.text.length <= 0) {
        [NSObject showHudTipStr:@"请填写手机号码先"];
        return;
    }
    _verify_codeBtn.enabled = NO;
    [[Coding_NetAPIManager sharedManager] post_QuickGeneratePhoneCodeWithMobile:_mobileF.text block:^(id data, NSError *error) {
        if (data) {
            [NSObject showHudTipStr:@"验证码发送成功"];
            [self.verify_codeBtn startUpTimer];
        }else{
            self.verify_codeBtn.enabled = YES;
        }
    }];
}
- (IBAction)footerBtnClicked:(id)sender {
    [NSObject showHUDQueryStr:@"正在登录..."];
    [[Coding_NetAPIManager sharedManager] post_QuickLoginWithMobile:_mobileF.text verify_code:_verify_codeF.text block:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            [self dismissViewControllerAnimated:YES completion:self.loginSucessBlock];
        }
    }];
}

#pragma mark goTo
- (void)goToServiceTerms{
    NSString *pathForServiceterms = [[NSBundle mainBundle] pathForResource:@"service_terms" ofType:@"html"];
    [self goToWebVCWithUrlStr:pathForServiceterms title:@"用户协议"];
}

@end
