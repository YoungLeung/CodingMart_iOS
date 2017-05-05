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

@property (assign, nonatomic) BOOL captchaNeeded;

//@property (strong, nonatomic) NSString *password, *confirm_password;
@end

@implementation PasswordPhoneSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"手机号重置密码";
    [_footerBtn setTitle:@"设置新密码" forState:UIControlStateNormal];

    RAC(self, footerBtn.enabled) = [RACSignal combineLatest:@[self.passwordF.rac_textSignal, self.confirm_passwordF.rac_textSignal, self.captchaCell.textF.rac_textSignal, RACObserve(self, captchaNeeded)] reduce:^id(NSString *password, NSString *confirm_password, NSString *captcha, NSNumber *captchaNeeded){
        return @(password.length > 0 && confirm_password.length > 0 && (!captchaNeeded || captcha.length > 0));
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshCaptchaNeeded];
}

- (void)refreshCaptchaNeeded{
    [[Coding_NetAPIManager sharedManager] get_LoginCaptchaIsNeededBlock:^(id data, NSError *error) {
        if (data) {
            NSNumber *captchaNeededResult = (NSNumber *)data;
            self.captchaNeeded = captchaNeededResult.boolValue;
            [self.tableView reloadData];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _captchaNeeded? 3: 2;
}

#pragma mark - Button

- (IBAction)footerBtnClicked:(id)sender {
    if (![_passwordF.text isEqualToString:_confirm_passwordF.text]) {
        [NSObject showHudTipStr:@"两次输入密码不一致"];
        return;
    }
    NSString *path = @"api/password";
    NSMutableDictionary *params = @{@"phone": _phone,
                                    @"password": [_passwordF.text sha1Str],
                                    @"rePassword": [_confirm_passwordF.text sha1Str],
                                    @"verificationCode": _code,
                                    @"countryCode": @"+86",
                                    @"isoCode": @"cn"}.mutableCopy;
    if (_captchaNeeded) {
        params[@"captcha"] = _captchaCell.textF.text;
    }
    [NSObject showHUDQueryStr:@"正在设置密码..."];
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            [NSObject showHudTipStr:@"密码设置成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

@end
