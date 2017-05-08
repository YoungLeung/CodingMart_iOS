//
//  QuickLoginViewController.m
//  CodingMart
//
//  Created by Ease on 16/8/23.
//  Copyright © 2016年 net.coding. All rights reserved.
//

//废弃的 VC

#import "QuickLoginViewController.h"
#import "PhoneCodeButton.h"
#import "TableViewFooterButton.h"
#import "UITTTAttributedLabel.h"
#import "Coding_NetAPIManager.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "CountryCodeListViewController.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import "QuickAccountInfoViewController.h"
#import "Login.h"

@interface QuickLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *mobileF;
@property (weak, nonatomic) IBOutlet UITextField *verify_codeF;
@property (weak, nonatomic) IBOutlet PhoneCodeButton *verify_codeBtn;

@property (weak, nonatomic) IBOutlet TableViewFooterButton *footerBtn;

@property (weak, nonatomic) IBOutlet UILabel *countryCodeL;
@property (strong, nonatomic) NSDictionary *countryCodeDict;

@property (strong, nonatomic) NSString *phone;
@end

@implementation QuickLoginViewController

+ (instancetype)storyboardVCWithPhone:(NSString *)phone{
    QuickLoginViewController *vc = [QuickLoginViewController vcInStoryboard:@"Login"];
    vc.phone = phone;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.countryCodeDict = @{@"country": @"China",
                             @"country_code": @"86",
                             @"iso_code": @"cn"};
    _mobileF.text = _phone;
    RAC(self, footerBtn.enabled) = [RACSignal combineLatest:@[self.mobileF.rac_textSignal, self.verify_codeF.rac_textSignal] reduce:^id(NSString *mobile, NSString *verify_code){
        return @(mobile.length > 0 && verify_code.length > 0);
    }];
}

- (void)setCountryCodeDict:(NSDictionary *)countryCodeDict{
    _countryCodeDict = countryCodeDict;
    _countryCodeL.text = [NSString stringWithFormat:@"+%@", _countryCodeDict[@"country_code"]];
}

#pragma mark - Button

- (void)checkIsPhoneNotRegister:(void (^)(NSNumber *isPhoneNotRegister))block{
//    NSString *path = @"api/account/check/phone";
//    NSDictionary *params = @{@"phone": _mobileF.text,
//                             @"isoCode": _countryCodeDict[@"iso_code"]};
//    [[CodingNetAPIClient codingJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Get andBlock:^(id data, NSError *error) {
//        block([data isKindOfClass:[NSDictionary class]]? data[@"data"]: nil);
//    }];
}

- (IBAction)countryCodeBtnClicked:(id)sender {
    CountryCodeListViewController *vc = [CountryCodeListViewController storyboardVC];
    WEAKSELF;
    vc.selectedBlock = ^(NSDictionary *countryCodeDict){
        weakSelf.countryCodeDict = countryCodeDict;
    };
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)verify_codeBtnClicked:(id)sender {
    if (_mobileF.text.length <= 0) {
        [NSObject showHudTipStr:@"请填写手机号码"];
        return;
    }
    WEAKSELF;
    _verify_codeBtn.enabled = NO;
    [self checkIsPhoneNotRegister:^(NSNumber *isPhoneNotRegister) {
        if (isPhoneNotRegister) {
            [weakSelf getVerfyCodeWithRegister:isPhoneNotRegister];
        }else{
            weakSelf.verify_codeBtn.enabled = YES;
        }
    }];
}

- (void)getVerfyCodeWithRegister:(NSNumber *)isPhoneNotRegister{
    NSString *path = isPhoneNotRegister.boolValue? @"api/account/register/generate_phone_code": @"api/account/login/verify-code";
    NSDictionary *params = @{isPhoneNotRegister.boolValue? @"phone": @"mobile": _mobileF.text,
                             @"phoneCountryCode": [NSString stringWithFormat:@"+%@", _countryCodeDict[@"country_code"]],
                             @"from": @"mart"};
    _verify_codeBtn.enabled = NO;
    WEAKSELF;
//    [[CodingNetAPIClient codingJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
//        if (data) {
//            [NSObject showHudTipStr:@"验证码发送成功"];
//            [weakSelf.verify_codeBtn startUpTimer];
//        }else{
//            weakSelf.verify_codeBtn.enabled = YES;
//        }
//    }];
}

- (IBAction)footerBtnClicked:(id)sender {
    WEAKSELF;
    [NSObject showHUDQueryStr:@"请稍等..."];
    [self checkIsPhoneNotRegister:^(NSNumber *isPhoneNotRegister) {
        if (isPhoneNotRegister) {
            if (isPhoneNotRegister.boolValue) {
                [weakSelf doCheckVerfyCode];
            }else{
                [weakSelf doLogin];
            }
        }else{
            [NSObject hideHUDQuery];
        }
    }];
}

- (void)doCheckVerfyCode{
//    NSString *path = @"api/account/register/check-verify-code";
//    NSDictionary *params = @{@"phone": _mobileF.text,
//                             @"verifyCode": _verify_codeF.text,
//                             @"phoneCountryCode": [NSString stringWithFormat:@"+%@", _countryCodeDict[@"country_code"]],
//                             @"from": @"mart"};
//    [NSObject showHUDQueryStr:@"请稍等..."];
//    WEAKSELF;
//    [[CodingNetAPIClient codingJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
//        [NSObject hideHUDQuery];
//        if (data) {
//            [weakSelf goToAccountInfoVC];
//        }
//    }];
}

- (void)doLogin{
//    NSString *path = @"api/account/mobile/login";
//    NSDictionary *params = @{@"mobile": _mobileF.text,
//                             @"verifyCode": _verify_codeF.text,
//                             @"phoneCountryCode": [NSString stringWithFormat:@"+%@", _countryCodeDict[@"country_code"]],
//                             @"rememberMe": @"true"};
//    [NSObject showHUDQueryStr:@"请稍等..."];
//    WEAKSELF;
//    [[CodingNetAPIClient codingJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
//        if (data) {
//            [[Coding_NetAPIManager sharedManager] get_CurrentUserBlock:^(id dataU, NSError *errorU) {
//                [NSObject hideHUDQuery];
//                [weakSelf dismissViewControllerAnimated:YES completion:self.loginSucessBlock];
//            }];
//        }else{
//            [NSObject hideHUDQuery];
//        }
//    }];
}

#pragma mark goTo
- (void)goToAccountInfoVC{
    QuickAccountInfoViewController *vc = [QuickAccountInfoViewController vcInStoryboard:@"Login"];
    vc.phone = _mobileF.text;
    vc.verify_code = _verify_codeF.text;
    vc.countryCodeDict = _countryCodeDict;
    vc.loginSucessBlock = _loginSucessBlock;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
