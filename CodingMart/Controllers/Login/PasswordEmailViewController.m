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
    self.title = @"忘记密码";
    _headerL.text = @"为了重置密码，我们将发邮件到您的邮箱";
    [_footerBtn setTitle:@"发送重置密码邮件" forState:UIControlStateNormal];
    _emailF.text = _email;
    RAC(self, footerBtn.enabled) = [RACSignal combineLatest:@[self.emailF.rac_textSignal, self.captchaCell.textF.rac_textSignal] reduce:^id(NSString *email, NSString *captcha){
        return @(email.length > 0 && captcha.length > 0);
    }];
}

#pragma mark - Button

- (IBAction)footerBtnClicked:(id)sender {
    [NSObject showHUDQueryStr:@"正在发送邮件..."];
    [[CodingNetAPIClient codingJsonClient] requestJsonDataWithPath:@"api/account/password/forget" withParams:@{@"account": _emailF.text, @"j_captcha": _captchaCell.textF.text} withMethodType:Post andBlock:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            [NSObject showHudTipStr:@"邮件已发送"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

@end
