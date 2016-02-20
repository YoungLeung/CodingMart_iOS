//
//  PasswordPhoneSetViewController.m
//  CodingMart
//
//  Created by Ease on 15/12/14.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "PasswordPhoneSetViewController.h"
#import "TableViewFooterButton.h"
#import "MartCaptchaCell.h"
#import "Coding_NetAPIManager.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface PasswordPhoneSetViewController ()
@property (weak, nonatomic) IBOutlet UITextField *passwordF;
@property (weak, nonatomic) IBOutlet UITextField *confirm_passwordF;
@property (weak, nonatomic) IBOutlet MartCaptchaCell *captchaCell;

@property (weak, nonatomic) IBOutlet TableViewFooterButton *footerBtn;

@property (strong, nonatomic) NSString *password, *confirm_password;
@end

@implementation PasswordPhoneSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"重置密码";
    [_footerBtn setTitle:@"重置密码" forState:UIControlStateNormal];

    RAC(self, footerBtn.enabled) = [RACSignal combineLatest:@[self.passwordF.rac_textSignal, self.confirm_passwordF.rac_textSignal, self.captchaCell.textF.rac_textSignal] reduce:^id(NSString *password, NSString *confirm_password, NSString *captcha){
        return @(password.length > 0 && confirm_password.length > 0 && captcha.length > 0);
    }];
}

#pragma mark - Button

- (IBAction)footerBtnClicked:(id)sender {
    if (![_passwordF.text isEqualToString:_confirm_passwordF.text]) {
        [NSObject showHudTipStr:@"两次输入密码不一致"];
        return;
    }
    NSMutableDictionary *params = @{@"account": _phone,
                                    @"password": [_passwordF.text sha1Str],
                                    @"confirm": [_confirm_passwordF.text sha1Str],
                                    @"code": _code}.mutableCopy;
    params[@"j_captcha"] = _captchaCell.textF.text;
    [NSObject showHUDQueryStr:@"正在设置密码..."];
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/account/password/reset" withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            [NSObject showHudTipStr:@"密码设置成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

@end
