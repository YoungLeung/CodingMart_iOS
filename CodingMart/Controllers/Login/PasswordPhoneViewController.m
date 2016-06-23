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
#import "CountryCodeListViewController.h"


@interface PasswordPhoneViewController ()
@property (weak, nonatomic) IBOutlet UILabel *headerL;
@property (weak, nonatomic) IBOutlet UITextField *mobileF;
@property (weak, nonatomic) IBOutlet UITextField *verify_codeF;
@property (weak, nonatomic) IBOutlet PhoneCodeButton *verify_codeBtn;

@property (weak, nonatomic) IBOutlet TableViewFooterButton *footerBtn;


@property (weak, nonatomic) IBOutlet UILabel *countryCodeL;
@property (strong, nonatomic) NSDictionary *countryCodeDict;
@end

@implementation PasswordPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"忘记密码";
    _headerL.text = @"为了重置密码，请先验证您的注册手机";
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
        [NSObject showHudTipStr:@"请填写手机号码先"];
        return;
    }
    _verify_codeBtn.enabled = NO;
    [[CodingNetAPIClient codingJsonClient] requestJsonDataWithPath:@"api/account/password/forget" withParams:@{@"account": _mobileF.text} withMethodType:Post andBlock:^(id data, NSError *error) {
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
    NSString *path = @"api/account/phone/code/check";
    NSDictionary *params = @{@"phone": _mobileF.text,
                             @"code": _verify_codeF.text,
                             @"type": @"reset"};
    [[CodingNetAPIClient codingJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
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
    }
}

@end
