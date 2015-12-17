//
//  PasswordEmailViewController.m
//  CodingMart
//
//  Created by Ease on 15/12/14.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "PasswordEmailViewController.h"
#import "MartCaptchaCell.h"
#import "TableViewFooterButton.h"
#import "Coding_NetAPIManager.h"
#import <ReactiveCocoa/ReactiveCocoa.h>


@interface PasswordEmailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *headerL;
@property (weak, nonatomic) IBOutlet UITextField *emailF;
@property (weak, nonatomic) IBOutlet MartCaptchaCell *captchaCell;

@property (weak, nonatomic) IBOutlet TableViewFooterButton *footerBtn;
@end

@implementation PasswordEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = (_reasonType == CannotLoginReasonForget)? @"忘记密码": @"设置密码";
    _headerL.text = (_reasonType == CannotLoginReasonForget)? @"为了重置密码，我们将发邮件到您的邮箱": @"为了设置密码，我们将发邮件到您的邮箱";
    [_footerBtn setTitle:(_reasonType == CannotLoginReasonForget)? @"发送重置密码邮件": @"重发激活邮件" forState:UIControlStateNormal];
    _emailF.text = _email;
    RAC(self, footerBtn.enabled) = [RACSignal combineLatest:@[self.emailF.rac_textSignal, self.captchaCell.textF.rac_textSignal] reduce:^id(NSString *email, NSString *captcha){
        return @(email.length > 0 && captcha.length > 0);
    }];
}

#pragma mark - Button

- (IBAction)footerBtnClicked:(id)sender {
    PurposeType type = (_reasonType == CannotLoginReasonForget)? PurposeToPasswordReset: PurposeToPasswordActivate;
    [NSObject showHUDQueryStr:@"正在发送邮件..."];
    [[Coding_NetAPIManager sharedManager] post_SetPasswordWithEmail:_emailF.text captcha:_captchaCell.textF.text type:type block:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            [NSObject showHudTipStr:@"邮件已发送"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

@end
