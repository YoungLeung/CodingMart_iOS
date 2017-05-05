//
//  RegisterPasswordViewController.m
//  CodingMart
//
//  Created by Ease on 15/12/14.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "RegisterPasswordViewController.h"
#import "TableViewFooterButton.h"
#import "UITTTAttributedLabel.h"
#import "MartCaptchaCell.h"
#import "Coding_NetAPIManager.h"
#import <ReactiveCocoa/ReactiveCocoa.h>


@interface RegisterPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *passwordF;
@property (weak, nonatomic) IBOutlet UITextField *confirm_passwordF;
@property (weak, nonatomic) IBOutlet MartCaptchaCell *captchaCell;

@property (weak, nonatomic) IBOutlet TableViewFooterButton *footerBtn;
@property (weak, nonatomic) IBOutlet UITTTAttributedLabel *footerL;

@property (assign, nonatomic) BOOL captchaNeeded;

@end

@implementation RegisterPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [_accountType isEqualToString:@"DEVELOPER"]? @"注册开发者": [_demandType isEqualToString:@"ENTERPRISE"]? @"注册企业需求方": @"注册个人需求方";

    __weak typeof(self) weakSelf = self;
    [_footerL addLinkToStr:@"《码市用户服务协议》" value:nil hasUnderline:YES clickedBlock:^(id value) {
        [weakSelf goToServiceTerms];
    }];
    RAC(self, footerBtn.enabled) = [RACSignal combineLatest:@[self.passwordF.rac_textSignal, self.confirm_passwordF.rac_textSignal, self.captchaCell.textF.rac_textSignal, RACObserve(self, captchaNeeded)] reduce:^id(NSString *password, NSString *confirm_password, NSString *captcha, NSNumber *captchaNeeded){
        return @(password.length > 0 && confirm_password.length > 0 && (captcha.length > 0 || !captchaNeeded.boolValue));
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshCaptchaNeeded];
}

- (void)refreshCaptchaNeeded{
    [[Coding_NetAPIManager sharedManager] get_RegisterCaptchaIsNeededBlock:^(id data, NSError *error) {
        if (data) {
            NSNumber *captchaNeededResult = (NSNumber *)data;
            self.captchaNeeded = captchaNeededResult.boolValue;
            if (!self.captchaNeeded) {
                self.captchaCell.textF.text = nil;
            }
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Table M
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _captchaNeeded? 3 : 2;
}

#pragma mark - Button

- (IBAction)footerBtnClicked:(id)sender {
    if (![_passwordF.text isEqualToString:_confirm_passwordF.text]) {
        [NSObject showHudTipStr:@"两次输入密码不一致"];
        return;
    }
    [NSObject showHUDQueryStr:@"正在注册..."];
    NSString *path = @"api/register";
    NSMutableDictionary *params = @{@"channel": kRegisterChannel,
                                    @"username": _global_key,
                                    @"phone": _phone,
                                    @"verificationCode": _code,
                                    @"countryCode": [NSString stringWithFormat:@"+%@", _countryCodeDict[@"country_code"]],
                                    @"isoCode": _countryCodeDict[@"iso_code"],
                                    @"password": [_passwordF.text sha1Str],
                                    @"rePassword": [_confirm_passwordF.text sha1Str],
                                    @"protocol": @"true",
                                    @"accountType": _accountType ?: @"DEVELOPER",
                                    }.mutableCopy;
    if (_captchaNeeded) {
        params[@"captcha"] = _captchaCell.textF.text;
    }
    if (_demandType.length > 0) {
        params[@"demandType"] = _demandType;
    }
    if (_name.length > 0) {
        params[@"name"] = _name;
    }
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        if (data) {
            [MobClick event:kUmeng_Event_UserAction label:@"注册成功"];
            
            [[Coding_NetAPIManager sharedManager] get_CurrentUserBlock:^(id dataU, NSError *errorU) {
                [NSObject hideHUDQuery];
                [self dismissViewControllerAnimated:YES completion:self.loginSucessBlock];
            }];
        }else{
            [NSObject hideHUDQuery];
            [self refreshCaptchaNeeded];
        }
    }];
}

#pragma mark goTo
- (void)goToServiceTerms{
    NSString *pathForServiceterms = [[NSBundle mainBundle] pathForResource:@"service_terms" ofType:@"html"];
    [self goToWebVCWithUrlStr:pathForServiceterms title:@"用户协议"];
}

@end
