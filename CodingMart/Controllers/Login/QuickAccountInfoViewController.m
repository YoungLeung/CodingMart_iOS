//
//  QuickAccountInfoViewController.m
//  CodingMart
//
//  Created by Ease on 16/8/23.
//  Copyright © 2016年 net.coding. All rights reserved.
//

//废弃的 VC

#import "QuickAccountInfoViewController.h"
#import "TableViewFooterButton.h"
#import "UITTTAttributedLabel.h"
#import "Coding_NetAPIManager.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MartCaptchaCell.h"

@interface QuickAccountInfoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *global_keyF;
@property (weak, nonatomic) IBOutlet UITextField *passwordF;
@property (weak, nonatomic) IBOutlet UITextField *confirm_passwordF;
@property (weak, nonatomic) IBOutlet MartCaptchaCell *captchaCell;

@property (weak, nonatomic) IBOutlet TableViewFooterButton *footerBtn;
@property (weak, nonatomic) IBOutlet UITTTAttributedLabel *footerL;

@property (assign, nonatomic) BOOL captchaNeeded;

@end

@implementation QuickAccountInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __weak typeof(self) weakSelf = self;
    [_footerL addLinkToStr:@"《码市用户服务协议》" value:nil hasUnderline:YES clickedBlock:^(id value) {
        [weakSelf goToServiceTerms];
    }];
    RAC(self, footerBtn.enabled) = [RACSignal combineLatest:@[self.passwordF.rac_textSignal, self.confirm_passwordF.rac_textSignal, self.global_keyF.rac_textSignal, self.captchaCell.textF.rac_textSignal, RACObserve(self, captchaNeeded)] reduce:^id(NSString *password, NSString *confirm_password, NSString *global_key, NSString *captcha, NSNumber *captchaNeeded){
        return @(password.length > 0 && confirm_password.length > 0 && global_key.length > 0 && (captcha.length > 0 || !captchaNeeded.boolValue));
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
    return _captchaNeeded? 4 : 3;
}

#pragma mark Button

- (IBAction)footerBtnClicked:(id)sender {
//    if (![_passwordF.text isEqualToString:_confirm_passwordF.text]) {
//        [NSObject showHudTipStr:@"两次输入密码不一致"];
//        return;
//    }
//    [NSObject showHUDQueryStr:@"正在注册..."];
//    NSString *path = @"api/v2/account/register";
//    NSMutableDictionary *params = @{@"channel": kRegisterChannel,
//                                    @"global_key": _global_keyF.text,
//                                    @"phone": _phone,
//                                    @"code": _verify_code,
//                                    @"password": [_passwordF.text sha1Str],
//                                    @"confirm": [_confirm_passwordF.text sha1Str],
//                                    @"phoneCountryCode": [NSString stringWithFormat:@"+%@", _countryCodeDict[@"country_code"]],
//                                    @"country": _countryCodeDict[@"iso_code"],
//                                    @"from": @"mart"}.mutableCopy;
//    if (_captchaNeeded) {
//        params[@"j_captcha"] = _captchaCell.textF.text;
//    }
//    [[CodingNetAPIClient codingJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
//        if (data) {
//            [[Coding_NetAPIManager sharedManager] get_CurrentUserBlock:^(id dataU, NSError *errorU) {
//                [NSObject hideHUDQuery];
//                [self dismissViewControllerAnimated:YES completion:self.loginSucessBlock];
//            }];
//        }else{
//            [NSObject hideHUDQuery];
//            [self refreshCaptchaNeeded];
//        }
//    }];
}

#pragma mark goTo
- (void)goToServiceTerms{
//    NSString *pathForServiceterms = [[NSBundle mainBundle] pathForResource:@"service_terms" ofType:@"html"];
//    [self goToWebVCWithUrlStr:pathForServiceterms title:@"用户协议"];
    [self goToWebVCWithUrlStr:@"/agreement.html" title:@"码市用户服务协议"];
}


@end
