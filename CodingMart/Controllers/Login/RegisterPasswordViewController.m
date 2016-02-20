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
    __weak typeof(self) weakSelf = self;
    [_footerL addLinkToStr:@"《码市用户协议》" whithValue:nil andBlock:^(id value) {
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
                self.captchaCell.textF = nil;
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
    NSString *path = @"api/v2/account/register";
    NSMutableDictionary *params = @{@"channel": kRegisterChannel,
                                    @"global_key": _global_key,
                                    @"phone": _phone,
                                    @"code": _code,
                                    @"password": [_passwordF.text sha1Str],
                                    @"confirm": [_confirm_passwordF.text sha1Str]}.mutableCopy;
    if (_captchaNeeded) {
        params[@"j_captcha"] = _captchaCell.textF.text;
    }
    [[CodingNetAPIClient codingJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            [self dismissViewControllerAnimated:YES completion:self.loginSucessBlock];
        }else{
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
